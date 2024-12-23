import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<Product, int> productQuantities = {};
  Directory? tempDir;
  bool isLoading = true;
  bool isAuthenticated = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAuthenticated = prefs.getBool('is_authenticated') ?? false;
      userId = prefs.getString('user_id') ?? '';
    });
    if (isAuthenticated) {
      await _loadCartData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadCartData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/cart?user_id=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> cartData = json.decode(response.body);
        productQuantities.clear();

        for (var item in cartData) {
          final productId = item['product_id'];
          final quantity = item['quantity'];
          final productResponse = await http.get(Uri.parse('http://10.0.2.2:8080/products/$productId'));
          if (productResponse.statusCode == 200) {
            final productData = json.decode(productResponse.body);
            final product = Product.fromJson(productData);
            setState(() {
              productQuantities[product] = quantity;
            });
          }
        }
      }
    } catch (e) {
      print('Ошибка загрузки корзины: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Корзина', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 6, 12, 24),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'Вы не авторизованы',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Корзина',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 12, 24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productQuantities.isEmpty
              ? const Center(
                  child: Text(
                    'Ваша корзина пуста',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: productQuantities.length,
                        itemBuilder: (context, index) {
                          final product = productQuantities.keys.elementAt(index);
                          final quantity = productQuantities[product]!;
                          return Card(
                            color: const Color.fromARGB(255, 17, 24, 39),
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'http://10.0.2.2:8080/uploads/${product.mainPhotoId}.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey,
                                              child: const Center(
                                                  child: Text(
                                                      'Ошибка загрузки',
                                                      style: TextStyle(color: Colors.white),
                                                  ),
                                              ),
                                          );
                                      },
                                  ),

                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.brand,
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Цена: ₽ ${product.currentPrice}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove, color: Colors.white),
                                              onPressed: () async {
                                                if (quantity > 1) {
                                                  await _decreaseQuantity(product);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Нельзя уменьшить количество меньше 1'),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              '$quantity',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add, color: Colors.white),
                                              onPressed: () async {
                                                await _increaseQuantity(product);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final bool isDeleted = await _deleteFromCart(product);
                                      if (isDeleted) {
                                        setState(() {
                                          productQuantities.remove(product);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Общая стоимость: ₽ ${_calculateTotalPrice()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              backgroundColor: const Color.fromARGB(255, 115, 76, 255),
                            ),
                            child: const Text(
                              'Перейти к оформлению',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  int _calculateTotalPrice() {
    int total = 0;
    productQuantities.forEach((product, quantity) {
      total += product.currentPrice * quantity;
    });
    return total;
  }

  Future<bool> _deleteFromCart(Product product) async {
    const String apiUrl = 'http://10.0.2.2:8080/cart/remove';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': product.id, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Товар успешно удален из корзины!')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления: ${response.statusCode}')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сети: $e')),
      );
      return false;
    }
  }

  Future<void> _increaseQuantity(Product product) async {
    const String apiUrl = 'http://10.0.2.2:8080/cart/increase';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': product.id, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          productQuantities[product] = productQuantities[product]! + 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка увеличения: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сети: $e')),
      );
    }
  }

  Future<void> _decreaseQuantity(Product product) async {
    const String apiUrl = 'http://10.0.2.2:8080/cart/decrease';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': product.id, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          productQuantities[product] = productQuantities[product]! - 1;
        });
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нельзя уменьшить количество меньше 1')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка уменьшения: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сети: $e')),
      );
    }
  }
}

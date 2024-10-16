import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../product.dart';

class CartPage extends StatefulWidget {
  final Set<Product> cartProducts;

  const CartPage({Key? key, required this.cartProducts}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<Product, int> productQuantities = {};
  Directory? tempDir;

  @override
  void initState() {
    super.initState();
    _initializeTempDir();
    for (var product in widget.cartProducts) {
      productQuantities[product] = 1; // Изначальное количество каждого товара - 1
    }
  }

  Future<void> _initializeTempDir() async {
    tempDir = await getTemporaryDirectory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      body: widget.cartProducts.isEmpty
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
                    itemCount: widget.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartProducts.elementAt(index);
                      return Card(
                        color: const Color.fromARGB(255, 17, 24, 39),
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: tempDir != null
                                    ? Image.file(
                                        File('${tempDir!.path}/photos/${product.mainPhotoId}.png'),
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
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
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
                                          onPressed: () {
                                            setState(() {
                                              if (productQuantities[product]! > 1) {
                                                productQuantities[product] = productQuantities[product]! - 1;
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '${productQuantities[product]}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              productQuantities[product] = productQuantities[product]! + 1;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    widget.cartProducts.remove(product);
                                    productQuantities.remove(product);
                                  });
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
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          backgroundColor: Color.fromARGB(255, 115, 76, 255)
                        ),
                        child: const Text('Перейти к оформлению', style: TextStyle(color: Colors.white),),
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
}

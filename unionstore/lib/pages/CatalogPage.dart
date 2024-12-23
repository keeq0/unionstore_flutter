import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import '../product.dart';
import '../data_service.dart';
import '../product_details_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../favorites_manager.dart';
import './CartPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




class CatalogPage extends StatefulWidget {

  const CatalogPage({Key? key}) : super(key: key);

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Product>> _products;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Directory? tempDir;
  FavoritesManager favoritesManager = FavoritesManager();

  bool isAuthenticated = false; 
  String userId = ''; 

  String searchQuery = '';
  String filterBy = 'none'; 


  
@override
void initState() {
  super.initState();
  _checkAuthentication(); 
  _products = fetchProducts();
  copyAssetsToTemp();
}

  Future<void> copyAssetsToTemp() async {
    try {
      tempDir = await getTemporaryDirectory();
      final photosTempDir = Directory('${tempDir!.path}/photos');

      if (!photosTempDir.existsSync()) {
        await photosTempDir.create(recursive: true);
      }

      final assetFileNames = [
        '1.png', '2.png', '3.png', '4.png', '5.png', '6.png', '7.png', '8.png', '9.png', '10.png'
      ];

      for (String fileName in assetFileNames) {
        try {
          final byteData = await rootBundle.load('assets/photos/$fileName');
          final newFile = File('${photosTempDir.path}/$fileName');
          await newFile.writeAsBytes(byteData.buffer.asUint8List());
          print('Файл успешно скопирован: ${newFile.path}');
        } catch (e) {
          print('Ошибка при копировании файла $fileName: $e');
        }
      }

      final copiedFiles = photosTempDir.listSync();
      for (var file in copiedFiles) {
        print('Скопированный файл: ${file.path}');
      }
    } catch (e) {
      print('Ошибка при копировании файлов в временную папку: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 6, 12, 24),
    body: Stack(
      children: [
        Positioned(
          left: 78,
          top: 133,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(47, 0, 255, 0.01),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(47, 0, 255, 0.1),
                  blurRadius: 70,
                  spreadRadius: 70,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: -82,
          top: 642,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(47, 0, 255, 0.01),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(47, 0, 255, 0.1),
                  blurRadius: 150,
                  spreadRadius: 70,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Каталог',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Обувь',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 75, 85, 99),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                  _products = fetchProducts();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Поиск...',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Image.asset(
                            'assets/images/search.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 75, 85, 99),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: filterBy,
                          dropdownColor: const Color.fromARGB(255, 75, 85, 99),
                          onChanged: (value) {
                            setState(() {
                              filterBy = value!;
                              _products = fetchProducts();
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'none',
                              child: Text(
                                'Без фильтра',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'price_asc',
                              child: Text(
                                'Цена: по возрастанию',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'price_desc',
                              child: Text(
                                'Цена: по убыванию',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'name_asc',
                              child: Text(
                                'Название: A-Z',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'name_desc',
                              child: Text(
                                'Название: Z-A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                          style: const TextStyle(color: Colors.white),
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showAddProductDialog(context);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 115, 76, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 370,
                height: 1,
                color: const Color.fromARGB(128, 162, 162, 162),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Ошибка загрузки данных'));
                    }
                    var products = snapshot.data!;

                  
                    if (filterBy == 'price_asc') {
                      products.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
                    } else if (filterBy == 'price_desc') {
                      products.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
                    } else if (filterBy == 'name_asc') {
                      products.sort((a, b) => a.name.compareTo(b.name));
                    } else if (filterBy == 'name_desc') {
                      products.sort((a, b) => b.name.compareTo(a.name));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 170 / 200,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return buildProductItem(product);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    ),
  );
}


 void showAddProductDialog(BuildContext context) {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController articleController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController materialController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        title: const Text('Добавить товар', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: brandController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Бренд',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Название',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: articleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Артикул',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: seasonController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Сезон',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: materialController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Материал',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    _selectedImage = File(pickedImage.path);
                    setState(() {});
                  }
                },
                child: const Text('Выбрать фото'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отменить', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              if (_selectedImage != null) {
                final uri = Uri.parse('http://10.0.2.2:8080/products/create');
                final request = http.MultipartRequest('POST', uri);

         
                request.fields['brand'] = brandController.text;
                request.fields['name'] = nameController.text;
                request.fields['description'] = descriptionController.text;
                request.fields['current_price'] = priceController.text;
                request.fields['article'] = articleController.text;
                request.fields['season'] = seasonController.text;
                request.fields['material'] = materialController.text;

             
                request.files.add(
                  await http.MultipartFile.fromPath(
                    'image',
                    _selectedImage!.path,
                  ),
                );

                try {
                  final streamedResponse = await request.send();
                  final response = await http.Response.fromStream(streamedResponse);

                  if (response.statusCode == 201) {
                    final newProduct = Product.fromJson(json.decode(response.body));
                    setState(() {
                      _products = _products.then((productList) => [newProduct, ...productList]);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Продукт успешно добавлен!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка сети: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пожалуйста, выберите фото')),
                );
              }

              Navigator.of(context).pop();
            },
            child: const Text('Добавить товар', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}




  Widget buildProductItem(Product product) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
          );
        },
        child: FutureBuilder<bool>(
          future: isInCart(product), 
          builder: (context, snapshot) {
            final isProductInCart = snapshot.data ?? false;
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 17, 24, 39),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'http://10.0.2.2:8080/uploads/${product.mainPhotoId}.png?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                          width: 170,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 170,
                              height: 100,
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
                      Positioned(
                        top: 5,
                        left: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (FavoritesManager.isFavorite(product)) {
                                FavoritesManager.removeProduct(product);
                              } else {
                                FavoritesManager.addProduct(product);
                              }
                            });
                          },
                          child: Icon(
                            Icons.favorite,
                            color: FavoritesManager.isFavorite(product) ? Colors.blue : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 45,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 75, 85, 99),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '₽ ${product.currentPrice}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₽ ${product.currentPrice}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 65,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 0, 255),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            'Подробнее',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
  onTap: () async {
    if (isProductInCart) {
      await _deleteFromCart(product);
    } else {
      await _addToCart(product);
    }
    setState(() {});
  },
  child: Container(
    width: 65,
    height: 20,
    decoration: BoxDecoration(
      color: isProductInCart
          ? const Color.fromARGB(255, 115, 76, 255) 
          : const Color.fromARGB(255, 75, 85, 99),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: isProductInCart
          ? const Text(
              'В корзине',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cart.png',
                  width: 10,
                  height: 10,
                ),
                const SizedBox(width: 2),
                const Text(
                  'Корзина',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    ),
  ),
),

                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 100, 0, 0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, product);
                          },
                          child: const Center(
                            child: Icon(Icons.delete, color: Colors.white, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}



  void showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 64, 64, 64),
          title: const Text('Удаление товара', style: TextStyle(color: Colors.white)),
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Вы уверены, что хотите удалить: \n \n',
                  style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
                ),
                TextSpan(
                  text: '${product.brand} ${product.name}',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const TextSpan(
                  text: '?',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отменить', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                try {
           
                  final uri = Uri.parse('http://10.0.2.2:8080/products/delete?id=${product.id}');
                  final response = await http.delete(uri);

                  if (response.statusCode == 200) {
                    
                    setState(() {
                      _products = _products.then(
                        (productList) => productList.where((p) => p.id != product.id).toList(),
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Продукт успешно удален!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка при удалении: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка сети: $e')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Удалить',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<Product>> fetchProducts() async {
  const String apiUrl = 'http://10.0.2.2:8080/products';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(decodedResponse);

      List<Product> products =
          data.map((item) => Product.fromJson(item)).toList();

   
      if (searchQuery.isNotEmpty) {
        products = products
            .where((product) =>
                product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                product.brand.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

   
      if (filterBy == 'price') {
        products.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
      } else if (filterBy == 'brand') {
        products.sort((a, b) => a.brand.compareTo(b.brand));
      }

      return products;
    } else {
      throw Exception('Ошибка загрузки данных. Код ошибки: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Ошибка при попытке загрузить данные: $e');
  }
}


Future<void> addToCart(Product product, {int quantity = 1}) async {
  const String apiUrl = 'http://10.0.2.2:8080/cart/add';

  try {

    final Map<String, dynamic> requestData = {
      'product_id': product.id,
      'quantity': quantity,
    };


    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

  
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар успешно добавлен в корзину!')),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Некорректные данные для добавления.')),
      );
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка сервера. Попробуйте позже.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неизвестная ошибка: ${response.statusCode}')),
      );
    }
  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка сети: $e')),
    );
  }
}

Future<bool> isInCart(Product product) async {
  if (!isAuthenticated) return false;

  const String apiUrl = 'http://10.0.2.2:8080/cart';

  try {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> cartItems = json.decode(response.body);
      return cartItems.any((item) => item['product_id'] == product.id);
    }
    return false;
  } catch (e) {
    print('Ошибка проверки корзины: $e');
    return false;
  }
}


Future<void> _addToCart(Product product) async {
  if (!isAuthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вы должны быть авторизованы, чтобы добавить товар в корзину')),
    );
    return;
  }

  const String apiUrl = 'http://10.0.2.2:8080/cart/add';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': product.id, 'user_id': userId, 'quantity': 1}),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар добавлен в корзину!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка добавления: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка сети: $e')),
    );
  }
}


Future<void> _deleteFromCart(Product product) async {
  if (!isAuthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вы должны быть авторизованы, чтобы удалить товар из корзины')),
    );
    return;
  }

  const String apiUrl = 'http://10.0.2.2:8080/cart/remove';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': product.id, 'user_id': userId}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар удален из корзины!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка сети: $e')),
    );
  }
}


Future<void> _checkAuthentication() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    userId = prefs.getString('user_id') ?? '';
  });
}



}

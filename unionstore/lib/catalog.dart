import 'package:flutter/material.dart';
import './product.dart'; // Не забудьте импортировать модель данных
import './data_service.dart'; // Импорт сервиса для загрузки данных

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Product>> _products;
  
  @override
  void initState() {
    super.initState();
    _products = loadProducts(); // Загружаем товары
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
                    blurRadius: 100,
                    spreadRadius: 100,
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Обувь',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Поиск и фильтры
                Row(
                  children: [
                    Container(
                      width: 250,
                      height: 30,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 75, 85, 99),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Поиск...',
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              textAlignVertical: TextAlignVertical.center,
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
                    const SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 75, 85, 99),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Фильтры',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Transform.rotate(
                            angle: 3.14 / 2,
                            child: Image.asset(
                              'assets/images/filter.png',
                              width: 13,
                              height: 13,
                            ),
                          ),
                        ],
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

                // Динамическая загрузка и отображение товаров
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
                      final products = snapshot.data!;
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
                Container(
                  width: 370,
                  height: 1,
                  color: const Color.fromARGB(128, 162, 162, 162),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      '© Union Store',
                      style: TextStyle(
                        color: Color.fromARGB(255, 162, 162, 162),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Функция для создания виджета товара
  Widget buildProductItem(Product product) {
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
                child: Image.asset(
                  'assets/photos/${product.mainPhotoId}.png',
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 40,
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
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
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
              fontSize: 10,
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
          const SizedBox(height: 10),
          Text(
            '₽ ${product.currentPrice}',
            style: const TextStyle(
              color: Color.fromARGB(255, 55, 0, 255),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 75,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 75, 85, 99),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/cart.png',
                      width: 10,
                      height: 10,
                    ),
                    const SizedBox(width: 3),
                    const Text(
                      'В Корзину',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 75,
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
            ],
          ),
        ],
      ),
    );
  }
}

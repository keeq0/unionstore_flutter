import 'package:flutter/material.dart';
import './product.dart'; 
import './data_service.dart'; 
import './product_details_page.dart'; 


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
    _products = loadProducts();
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

                // Блок поиска и фильтров
                Row(
                  children: [
                    Container(
                      width: 210,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
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
                              fontSize: 12,
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
                    const SizedBox(width: 10),
                    Container( // Кнопка "Добавить" ( сделать добавление ботинка )
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 115, 76, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            
                          });
                        },
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

                // Сетка товаров
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

  // Создание карточки товара
  Widget buildProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        );
      },
      child: Container(
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
                    width: 170,
                    height: 100,
                    fit: BoxFit.cover,
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
                Container(
                  width: 65,
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
                Container( // Кнопка "Удалить"
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
      ),
    );
  }
  void showDeleteDialog(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 64, 64, 64),
        title: Text('Удаление товара', style: TextStyle(color: Colors.white)),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Вы уверены, что хотите удалить: \n \n',
                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
              ),
              TextSpan(
                text: '${product.brand} ${product.name}',
                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              TextSpan(
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
            child: Text('Отменить', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _products = _products.then((productList) => productList.where((p) => p.id != product.id).toList());
              });
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
}

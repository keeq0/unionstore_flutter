import 'package:flutter/material.dart';
import 'dart:io';
import './product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 12, 24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Детали товара',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 6, 12, 24),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                product.brand,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File('/data/user/0/com.example.unionstore/cache/photos/${product.mainPhotoId}.png'),
                  width: 350,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 350,
                      height: 250,
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'Ошибка загрузки изображения',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Таблица размеров',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.transparent,
                  shadows: [Shadow(offset: Offset(0, -5), color: Colors.grey)],
                  decorationThickness: 1,
                  decorationColor: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 15),

              buildCharacteristics('Артикул:', product.article),
              buildCharacteristics('Состав:', product.material),
              buildCharacteristics('Сезон:', product.season),
              const SizedBox(height: 15),

              const Text(
                'Все характеристики и описание',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.transparent,
                  shadows: [Shadow(offset: Offset(0, -5), color: Colors.white)],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '₽ ${product.currentPrice}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (product.oldPrice != null)
                    Text(
                      '₽ ${product.oldPrice}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.withOpacity(0.5),
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 1,
                        decorationColor: Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/images/cart.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text(
                        'В корзину',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(75, 85, 99, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(55, 0, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Купить сейчас',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCharacteristics(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

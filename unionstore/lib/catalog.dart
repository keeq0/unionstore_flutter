import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 12, 24),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Добавляем горизонтальные отступы
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Выровнять элементы по левому краю
          children: [
            const Text(
              'Каталог',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2), // Отступ 2px вниз
            const Text(
              'Обувь',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Отступ 20px вниз

            // Поиск и фильтр блок
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Выравнивание по центру
              children: [
                // Поле поиска
                Container(
                  width: 250,
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 75, 85, 99),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Поиск...',
                            hintStyle: const TextStyle(
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
                const SizedBox(width: 10), // Отступ между Поиск и Фильтр

                // Фильтр блок
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
                        'Фильтр',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(width: 5), // Отступ между текстом и иконкой
                      Transform.rotate(
                        angle: 3.14 / 2, // Поворот на -90 градусов (в радианах)
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

            const SizedBox(height: 10), // Отступ 10px вниз

            // Полоса
            Container(
              width: 370,
              height: 1,
              color: const Color.fromARGB(128, 162, 162, 162),
            ),
          ],
        ),
      ),
    );
  }
}

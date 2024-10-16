import 'package:flutter/material.dart';
import '../pages/CartPage.dart'; // Импорт страницы корзины
import '../product.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Set<Product> cartProducts; // Добавляем переменную для хранения товаров в корзине

  CustomAppBar({required this.cartProducts}); // Конструктор с обязательным параметром

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 12, 24),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Transform.rotate(
            angle: 3.14,
            child: Image.asset(
              'assets/images/arrow.png',
              width: 40,
              height: 40,
            ),
          ),
        ),
        actions: [
          _buildCartIcon(context),
        ],
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartProducts: cartProducts), // Передаем список товаров в корзине
            ),
          );
        },
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 35);
}

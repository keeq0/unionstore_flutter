import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
          _buildBurgerMenuIcon(),
        ],
      ),
    );
  }

  Widget _buildBurgerMenuIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBurgerLine(),
            const SizedBox(height: 6),
            _buildBurgerLine(),
            const SizedBox(height: 6),
            _buildBurgerLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildBurgerLine() {
    return Container(
      width: 40,
      height: 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 35);
}

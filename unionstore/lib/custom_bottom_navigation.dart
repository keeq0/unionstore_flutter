import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 6, 12, 24),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      currentIndex: widget.currentIndex,
      onTap: widget.onTabSelected,
      iconSize: 20, 
      selectedLabelStyle: const TextStyle(
        fontSize: 12, 
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10, 
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Избранное',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }
}
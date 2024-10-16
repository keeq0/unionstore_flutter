import 'package:flutter/material.dart';
import 'package:unionstore/pages/CartPage.dart';
import 'appbar.dart'; 
import 'custom_bottom_navigation.dart'; 
import './pages/CatalogPage.dart';
import './pages/FavouritePage.dart'; 
import './pages/ProfilePage.dart';
import './product.dart'; // Импорт модели Product

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Union Store',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 6, 12, 24), 
        fontFamily: 'Montserrat',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final Set<Product> _cartProducts = {}; // Список для хранения товаров в корзине

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      CatalogPage(cartProducts: _cartProducts), 
      const FavoritesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: CustomAppBar(cartProducts: _cartProducts), // Передаем товары в корзине в AppBar
      body: _pages[_currentIndex], 
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected, 
      ),
    );
  }
}

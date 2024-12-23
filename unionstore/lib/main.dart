import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/ProfilePage.dart'; 
import './pages/CatalogPage.dart';
import './pages/FavouritePage.dart'; 
import './custom_bottom_navigation.dart';
import './appbar.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MainScreen(), 
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; 

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const CatalogPage(),
      const FavoritesPage(), 
      const ProfilePage(), 
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

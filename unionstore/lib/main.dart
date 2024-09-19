import 'package:flutter/material.dart';
import 'appbar.dart';  // Подключаем кастомный AppBar
import 'catalog.dart'; // Подключаем страницу Catalog

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
        fontFamily: 'Montserrat', // Устанавливаем шрифт Montserrat по умолчанию
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: const CatalogPage(),
    );
  }
}

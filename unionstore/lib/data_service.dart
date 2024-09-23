import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import './product.dart';

Future<List<Product>> loadProducts() async {
  final String response = await rootBundle.loadString('assets/data/products.json');
  final List<dynamic> data = json.decode(response);
  return data.map((item) => Product.fromJson(item)).toList();
}

Future<List<Photo>> loadPhotos() async {
  final String response = await rootBundle.loadString('assets/data/photos.json');
  final List<dynamic> data = json.decode(response);
  return data.map((item) => Photo.fromJson(item)).toList();
}

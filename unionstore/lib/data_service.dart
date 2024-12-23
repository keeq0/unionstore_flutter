import 'dart:convert';
import 'package:http/http.dart' as http;
import './product.dart';

class DataService {
  final String baseUrl = 'http://localhost:8080'; 

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные с сервера: $e');
    }
  }
}

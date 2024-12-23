import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8080'; 

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка входа: ${response.body}');
    }
  }

  Future<void> register(
      String username, String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка регистрации: ${response.body}');
    }
  }
}

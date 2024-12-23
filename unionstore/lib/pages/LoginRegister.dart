import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';
import './ProfilePage.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final ApiService _apiService = ApiService();
  bool isLogin = true;
  String debugInfo = ''; 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
      debugInfo = ''; 
    });
  }

  Future<void> authenticate() async {
    try {
      if (isLogin) {
 
        final response = await _apiService.login(
          emailController.text,
          passwordController.text,
        );

        setState(() {
          debugInfo = 'Данные при входе: $response';
        });

        await _saveSession(
          response['username'],
          response['first_name'],
          response['last_name'],
          response['email'],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      } else {
     
        await _apiService.register(
          usernameController.text,
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          passwordController.text,
        );

        toggleMode(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация прошла успешно!')),
        );
      }
    } catch (e) {
      setState(() {
        debugInfo = 'Ошибка: $e';
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveSession(
      String username, String firstName, String lastName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    await prefs.setString('profile_name', firstName);
    await prefs.setString('profile_username', username);
    await prefs.setString('profile_email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Вход' : 'Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLogin)
              Column(
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'Имя'),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Фамилия'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Имя пользователя'),
                  ),
                ],
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authenticate,
              child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
            ),
            TextButton(
              onPressed: toggleMode,
              child: Text(isLogin ? 'Создать аккаунт' : 'Уже есть аккаунт? Войти'),
            ),
            const SizedBox(height: 20),
            if (debugInfo.isNotEmpty)
              Text(
                debugInfo,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

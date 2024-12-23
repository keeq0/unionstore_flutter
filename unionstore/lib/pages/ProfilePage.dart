import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAuthenticated = false;
  bool isRegistering = false; 
  String name = ''; 
  String email = '';
  String userId = ''; 
  File? profileImage;

  final ApiService _apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    });
    if (isAuthenticated) {
      await _loadProfileData();
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('profile_name') ?? 'Имя Фамилия';
    email = prefs.getString('profile_email') ?? 'email@example.com';
    userId = prefs.getString('profile_username') ?? '@username'; // Загружаем username
    await _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final tempDir = await getTemporaryDirectory();
    final path = prefs.getString('profile_image_path') ?? '${tempDir.path}/profile_image.png';
    final file = File(path);
    if (await file.exists()) {
      setState(() {
        profileImage = file;
      });
    }
  }

  Future<void> _login() async {
    try {
      final response = await _apiService.login(
        emailController.text,
        passwordController.text,
      );

      // Сохраняем данные в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);
      await prefs.setString('profile_name', '${response['first_name']} ${response['last_name']}');
      await prefs.setString('profile_email', response['email']);
      await prefs.setString('profile_username', response['username']);

      // Обновляем состояние
      setState(() {
        isAuthenticated = true;
        name = '${response['first_name']} ${response['last_name']}';
        email = response['email'];
        userId = response['username'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа: $e')),
      );
    }
  }

  Future<void> _register() async {
    try {
      await _apiService.register(
        usernameController.text,
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
      );

      setState(() {
        isRegistering = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация успешна. Пожалуйста, войдите.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка регистрации: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очищаем данные
    setState(() {
      isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? _buildProfileContent(context) : _buildAuthForm(context);
  }

  Widget _buildAuthForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isRegistering)
            Column(
              children: [
                TextField(
                  controller: firstNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Имя', labelStyle: TextStyle(color: Colors.white)),
                ),
                TextField(
                  controller: lastNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Фамилия', labelStyle: TextStyle(color: Colors.white)),
                ),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Имя пользователя', labelStyle: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white)),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Пароль', labelStyle: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isRegistering ? _register : _login,
            child: Text(isRegistering ? 'Зарегистрироваться' : 'Войти'),
          ),
          TextButton(
            onPressed: () => setState(() {
              isRegistering = !isRegistering;
            }),
            child: Text(isRegistering ? 'Уже есть аккаунт? Войти' : 'Нет аккаунта? Зарегистрироваться'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : const AssetImage('assets/images/me.jpg') as ImageProvider,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white.withOpacity(0.7),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userId,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 115, 76, 255),
            ),
            child: TextButton(
              onPressed: _logout,
              child: const Text(
                'Выйти',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      await _saveProfileImage(image);
    }
  }

  Future<void> _saveProfileImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/profile_image.png';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
    await image.copy(path);
    setState(() {
      profileImage = image;
    });
  }
}

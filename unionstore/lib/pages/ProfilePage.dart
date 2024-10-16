import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Сергей Мякотных';
  String email = 'keeqocontact@gmail.com';
  String userId = '@keeq0';
  File? profileImage;

  late Future<void> _profileFuture = _loadProfileData();

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('profile_name') ?? 'Сергей Мякотных';
    email = prefs.getString('profile_email') ?? 'keeqocontact@gmail.com';
    await _loadProfileImage();
  }

  Future<void> _saveProfileData(String newName, String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', newName);
    await prefs.setString('profile_email', newEmail);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildProfileContent(context);
        }
      },
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Круглое фото
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

          // Имя и фамилия
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          // ID пользователя
          Text(
            userId,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),

          // Почта пользователя
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          // Кнопка "Редактировать"
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black, // Черный фон
              border: Border.all(color: Colors.grey), // Серая обводка
            ),
            child: TextButton(
              onPressed: _showEditProfileDialog,
              child: const Text(
                'Редактировать профиль',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Кнопка "Мои заказы"
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(128, 162, 162, 162),
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Мои заказы',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Кнопка "Выйти"
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 115, 76, 255),
            ),
            child: TextButton(
              onPressed: () {},
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

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 64, 64, 64),
          title: const Text(
            'Редактировать профиль',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Имя и фамилия',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Электронная почта',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Отменить',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                _saveProfileData(name, email);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      await _saveProfileImage(image);
    }
  }
}

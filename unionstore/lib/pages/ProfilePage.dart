import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Круглое фото
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/me.jpg'),
          ),
          const SizedBox(height: 20),

          // Имя и фамилия
          const Text(
            'Сергей Мякотных',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          // ID пользователя
          const Text(
            '@keeq0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),

          // Почта пользователя
          const Text(
            'keeqocontact@gmail.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          // Кнопка "Мои заказы"
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(128, 162, 162, 162),
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
              color: Color.fromARGB(255, 115, 76, 255),
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
}

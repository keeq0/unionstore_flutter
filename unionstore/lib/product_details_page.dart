import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import './product.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  void showEditProductDialog(BuildContext context) {
    final TextEditingController brandController =
        TextEditingController(text: widget.product.brand);
    final TextEditingController nameController =
        TextEditingController(text: widget.product.name);
    final TextEditingController descriptionController =
        TextEditingController(text: widget.product.description);
    final TextEditingController priceController =
        TextEditingController(text: widget.product.currentPrice.toString());
    final TextEditingController articleController =
        TextEditingController(text: widget.product.article);
    final TextEditingController seasonController =
        TextEditingController(text: widget.product.season);
    final TextEditingController materialController =
        TextEditingController(text: widget.product.material);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 64, 64, 64),
          title: const Text('Редактировать товар',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: brandController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Бренд',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Цена',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: articleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Артикул',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: seasonController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Сезон',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: materialController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Материал',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      _selectedImage = File(pickedImage.path);
                      setState(() {});
                    }
                  },
                  child: const Text('Изменить фото'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отменить',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(
                    'http://10.0.2.2:8080/products/update/${widget.product.id}');
                final request = http.MultipartRequest('PUT', uri);

                request.fields['brand'] = brandController.text;
                request.fields['name'] = nameController.text;
                request.fields['description'] = descriptionController.text;
                request.fields['current_price'] = priceController.text;
                request.fields['article'] = articleController.text;
                request.fields['season'] = seasonController.text;
                request.fields['material'] = materialController.text;

                if (_selectedImage != null) {
                  request.files.add(
                    await http.MultipartFile.fromPath(
                      'image',
                      _selectedImage!.path,
                    ),
                  );
                }

                try {
                  final streamedResponse = await request.send();
                  final response =
                      await http.Response.fromStream(streamedResponse);

                  if (response.statusCode == 200) {
                    final updatedProduct =
                        Product.fromJson(json.decode(response.body));
                    setState(() {
                      widget.product.brand = updatedProduct.brand;
                      widget.product.name = updatedProduct.name;
                      widget.product.description = updatedProduct.description;
                      widget.product.currentPrice =
                          updatedProduct.currentPrice;
                      widget.product.article = updatedProduct.article;
                      widget.product.season = updatedProduct.season;
                      widget.product.material = updatedProduct.material;
                      widget.product.mainPhotoId =
                          updatedProduct.mainPhotoId;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Продукт успешно обновлен!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка сети: $e')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Обновить товар',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 12, 24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Детали товара',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => showEditProductDialog(context),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 6, 12, 24),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                widget.product.brand,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.network(
    'http://10.0.2.2:8080/uploads/${widget.product.mainPhotoId}.png?timestamp=${DateTime.now().millisecondsSinceEpoch}',
    width: 350,
    height: 250,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: 350,
        height: 250,
        color: Colors.grey,
        child: const Center(
          child: Text(
            'Ошибка загрузки изображения',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    },
  ),
),

              const SizedBox(height: 20),
              Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Таблица размеров',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.transparent,
                  shadows: [Shadow(offset: Offset(0, -5), color: Colors.grey)],
                  decorationThickness: 1,
                  decorationColor: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 15),
              buildCharacteristics('Артикул:', widget.product.article),
              buildCharacteristics('Состав:', widget.product.material),
              buildCharacteristics('Сезон:', widget.product.season),
              const SizedBox(height: 15),
              const Text(
                'Все характеристики и описание',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.transparent,
                  shadows: [Shadow(offset: Offset(0, -5), color: Colors.white)],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '₽ ${widget.product.currentPrice}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.product.oldPrice != null)
                  Text(
                    '₽ ${widget.product.oldPrice}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.withOpacity(0.6), 
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey.withOpacity(0.6),
                      decorationThickness: 1.5,
                    ),
                  ),
              ],
            ),


              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/images/cart.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text(
                        'В корзину',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(75, 85, 99, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 170,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(55, 0, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Купить сейчас',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCharacteristics(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

class Product {
  final int id;
  final String brand;
  final String name;
  final int mainPhotoId;
  final String description;
  final int currentPrice;
  final int? oldPrice;
  final String article;
  final String season;
  final String material;
  bool isFavorite;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.mainPhotoId,
    required this.description,
    required this.currentPrice,
    this.oldPrice,
    required this.article,
    required this.season,
    required this.material,
    this.isFavorite = false, // Значение по умолчанию
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      name: json['name'],
      mainPhotoId: json['main_photo_id'],
      description: json['description'],
      currentPrice: json['current_price'],
      oldPrice: json['old_price'],
      article: json['article'],
      season: json['season'],
      material: json['material'],
      isFavorite: json['is_favorite'] ?? false, // Использование значения по умолчанию
    );
  }
}

class Photo {
  final int id;
  final String src;

  Photo({
    required this.id,
    required this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      src: json['src'],
    );
  }
}
import 'dart:convert';

class Product {
  int id;
  String brand;
  String name;
  int mainPhotoId;
  String description;
  int currentPrice;
  int? oldPrice;
  String article;
  String season;
  String material;
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
    this.isFavorite = false,
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
      isFavorite: json['is_favorite'] ?? false,
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
import 'dart:convert';

class Product {
  final int id;
  final String brand;
  final String name;
  final int mainPhotoId;
  final List<int> additionalPhotos;
  final String description;
  final int currentPrice;
  final int? oldPrice;
  final String article;
  final String season;
  final String material;
  final Map<String, bool> sizes;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.mainPhotoId,
    required this.additionalPhotos,
    required this.description,
    required this.currentPrice,
    this.oldPrice,
    required this.article,
    required this.season,
    required this.material,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      name: json['name'],
      mainPhotoId: json['main_photo_id'],
      additionalPhotos: List<int>.from(json['additional_photos']),
      description: json['description'],
      currentPrice: json['current_price'],
      oldPrice: json['old_price'],
      article: json['article'],
      season: json['season'],
      material: json['material'],
      sizes: Map<String, bool>.from(json['sizes']),
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

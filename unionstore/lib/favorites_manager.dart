import '../product.dart';

class FavoritesManager {
  static final List<Product> _favoriteProducts = [];

  static List<Product> get favoriteProducts => _favoriteProducts;

  static void addProduct(Product product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
    }
  }

  static void removeProduct(Product product) {
    _favoriteProducts.remove(product);
  }

  static bool isFavorite(Product product) {
    return _favoriteProducts.contains(product);
  }
}

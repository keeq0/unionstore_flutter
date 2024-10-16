import 'package:flutter/material.dart';
import '../product.dart';
import '../favorites_manager.dart';
import '../product_details_page.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; 

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Directory? tempDir;

  @override
  void initState() {
    super.initState();
    _loadTempDir();
  }

  Future<void> _loadTempDir() async {
    tempDir = await getTemporaryDirectory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = FavoritesManager.favoriteProducts;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 12, 24),
      appBar: AppBar(
        title: const Text('Избранное', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Text(
                'Нет избранных товаров',
                style: TextStyle(color: Colors.white),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 170 / 175,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return buildFavoriteProductItem(product);
              },
            ),
    );
  }

  Widget buildFavoriteProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 24, 39),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: tempDir == null
                      ? Container(
                          width: 170,
                          height: 100,
                          color: Colors.grey,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Image.file(
                          File('${tempDir!.path}/photos/${product.mainPhotoId}.png'),
                          width: 170,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 170,
                              height: 100,
                              color: Colors.grey,
                              child: const Center(
                                child: Text(
                                  'Ошибка загрузки',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (FavoritesManager.isFavorite(product)) {
                          FavoritesManager.removeProduct(product);
                        } else {
                          FavoritesManager.addProduct(product);
                        }
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: FavoritesManager.isFavorite(product) ? Colors.blue : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              product.brand,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '₽ ${product.currentPrice}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

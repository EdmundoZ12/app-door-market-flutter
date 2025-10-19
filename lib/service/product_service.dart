import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/model/product.dart';

class ProductService {
  const ProductService();

  Future<List<Product>> fetchPopularProducts() async {
    final products =
        await _loadProductsFromAsset('assets/data/populars.json', 'populars');
    products.sort((a, b) => b.popularity.compareTo(a.popularity));
    return products;
  }

  Future<List<Product>> fetchAllProducts() async {
    return _loadProductsFromAsset('assets/data/products.json', 'products');
  }

  Future<List<Product>> _loadProductsFromAsset(
    String assetPath,
    String key,
  ) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> rawList = data[key] as List<dynamic>? ?? [];

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }
}

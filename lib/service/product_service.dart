import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/model/product.dart';

class ProductService {
  const ProductService();

  Future<List<Product>> fetchPopularProducts() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/populars.json');
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> popularList = data['populars'] as List<dynamic>? ?? [];

    final products = popularList
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();

    products.sort(
      (a, b) => b.popularity.compareTo(a.popularity),
    );

    return products;
  }
}

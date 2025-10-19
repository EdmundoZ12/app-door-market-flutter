import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/model/category.dart';

class CategoryService {
  const CategoryService();

  Future<List<Category>> fetchCategories() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/categories.json');
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> rawList = data['categories'] as List<dynamic>? ?? [];

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(Category.fromJson)
        .toList();
  }
}

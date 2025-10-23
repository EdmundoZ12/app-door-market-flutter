import 'dart:convert';

import 'package:door_market_app/data/model/cart_item.dart';
import 'package:flutter/services.dart';

class CartService {
  const CartService({this.assetPath = 'assets/data/cart.json'});

  final String assetPath;

  Future<List<CartItem>> loadCartItems() async {
    final raw = await rootBundle.loadString(assetPath);
    final dynamic decoded = json.decode(raw);

    if (decoded is Map<String, dynamic>) {
      final List<dynamic>? items = decoded['cart-item'] as List<dynamic>?;
      return _parseItems(items ?? const []);
    }

    if (decoded is List) {
      return _parseItems(decoded);
    }

    throw const FormatException('Formato de carrito desconocido');
  }

  List<CartItem> _parseItems(List<dynamic> source) {
    return source
        .whereType<Map<String, dynamic>>()
        .map(CartItem.fromJson)
        .toList();
  }
}

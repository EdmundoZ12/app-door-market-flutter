import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/model/cart_item.dart';

class CartService {
  const CartService();

  // Cargar items del carrito desde JSON
  Future<List<CartItem>> fetchCartItems() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/cart_items.json',
      );
      final Map<String, dynamic> data =
          json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> itemsList = data['cartItems'] ?? <dynamic>[];

      return itemsList
          .whereType<Map<String, dynamic>>()
          .map(CartItem.fromJson)
          .toList();
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  // Calcular subtotal
  double calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Contar total de items
  int getTotalItemsCount(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Aplicar cupón
  double applyCoupon(String couponCode) {
    final validCoupons = {'ABC123': 15.0, 'PROMO10': 10.0, 'DESCUENTO20': 20.0};
    return validCoupons[couponCode.toUpperCase()] ?? 0.0;
  }

  // Calcular total final
  double calculateTotal({
    required double subtotal,
    required double deliveryCost,
    required double discount,
  }) {
    return subtotal + deliveryCost - discount;
  }
}

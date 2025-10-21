import 'package:flutter/foundation.dart';

@immutable
class OrderProduct {
  const OrderProduct({
    required this.id,
    required this.quantity,
  });

  final int id;
  final int quantity;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
    );
  }
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.state,
    required this.date,
    required this.products,
    required this.total,
  });

  final int id;
  final String state;
  final DateTime date;
  final List<OrderProduct> products;
  final double total;

  int get productsCount =>
      products.fold<int>(0, (sum, product) => sum + product.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? const [];

    return Order(
      id: json['id'] as int? ?? 0,
      state: json['state'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      products: productsJson
          .whereType<Map<String, dynamic>>()
          .map(OrderProduct.fromJson)
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}

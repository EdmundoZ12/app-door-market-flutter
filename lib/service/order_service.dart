import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/model/order.dart';

class OrderService {
  const OrderService();

  Future<List<Order>> fetchOrders() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/orders.json',
    );

    final dynamic data = json.decode(jsonString);
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(Order.fromJson)
        .toList();
  }
}

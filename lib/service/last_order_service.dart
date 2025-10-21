import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/model/last_order.dart';

class LastOrderService {
  const LastOrderService();

  Future<List<LastOrder>> fetchLastOrders() async {
    return _loadOrdersFromAsset('assets/data/last_orders.json', 'orders');
  }

  Future<LastOrder?> fetchOrderById(int orderId) async {
    final orders = await fetchLastOrders();
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<List<LastOrder>> _loadOrdersFromAsset(
    String assetPath,
    String key,
  ) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data =
          json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> rawList = data[key] as List<dynamic>? ?? [];

      return rawList
          .whereType<Map<String, dynamic>>()
          .map(LastOrder.fromJson)
          .toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }
}

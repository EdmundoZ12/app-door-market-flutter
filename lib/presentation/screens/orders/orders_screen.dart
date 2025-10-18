import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
   static const String name = 'orders_screen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      // body: const _HomeView(),
    );
  }
}

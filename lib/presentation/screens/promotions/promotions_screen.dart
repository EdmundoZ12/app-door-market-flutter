import 'package:flutter/material.dart';

class PromotionsScreen extends StatelessWidget {
  static const String name = 'promotions_screen';
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promotions')),
      // body: const _HomeView(),
    );
  }
}

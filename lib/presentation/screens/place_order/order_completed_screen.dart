import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCompletedScreen extends StatelessWidget {
  final int estimatedTime;
  final List<Map<String, dynamic>> items;

  const OrderCompletedScreen({
    Key? key,
    required this.estimatedTime,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                children: [
                  Image.asset('assets/images/icons/logo.png', width: 40),
                  const SizedBox(width: 8),
                  const Text('Pedido Realizado', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 32),
            Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Su pedido se encuentra en camino.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Tiempo de entrega estimado: $estimatedTime min.', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Items :', style: TextStyle(fontSize: 16)),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: Row(
                children: [
                  Expanded(child: Text(item['name'], style: const TextStyle(fontSize: 15))),
                  Text('${((item['unitPrice'] as num) * (item['quantity'] as num)).toStringAsFixed(2)} Bs', style: const TextStyle(fontSize: 15)),
                  Text(' x${item['quantity']}', style: const TextStyle(fontSize: 15)),
                ],
              ),
            )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  context.go('/delivery-status');
                },
                child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

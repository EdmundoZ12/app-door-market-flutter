import 'dart:convert';
import 'package:door_market_app/presentation/screens/place_order/order_completed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class OrderSummaryInformation extends StatefulWidget {
  const OrderSummaryInformation({Key? key}) : super(key: key);

  @override
  State<OrderSummaryInformation> createState() =>
      _OrderSummaryInformationState();
}

class _OrderSummaryInformationState extends State<OrderSummaryInformation> {
  List<Map<String, dynamic>> cartItems = [];
  double subtotal = 0;
  double deliveryCost = 8.0;
  double couponDiscount = 15.0;
  double total = 0;
  int estimatedTime = 15;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final String response = await rootBundle.loadString(
      'assets/data/order_items.json',
    );
    final data = json.decode(response);
    final items = data['OrderItems'] as List<dynamic>;
    setState(() {
      cartItems = items.map((e) => Map<String, dynamic>.from(e)).toList();
      subtotal = cartItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['unitPrice'] as num) * (item['quantity'] as num)),
      );
      total = subtotal + deliveryCost - couponDiscount;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = cartItems.fold(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de productos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Productos a pedir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              ...cartItems.map(
                (item) => ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text('Cantidad: ${item['quantity']}'),
                  trailing: Text(
                    '${((item['unitPrice'] as num) * (item['quantity'] as num)).toStringAsFixed(2)} Bs.',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Resumen del pedido
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Tiempo de entrega estimado',
                      '$estimatedTime min.',
                      isBold: true,
                    ),
                    _buildSummaryRow(
                      '$totalItems Items Subtotal',
                      '${subtotal.toStringAsFixed(2)} Bs.',
                      isBold: true,
                    ),
                    _buildSummaryRow(
                      'Costo de entrega',
                      '${deliveryCost.toStringAsFixed(2)} Bs.',
                      isBold: true,
                    ),
                    _buildSummaryRow(
                      'Cupón descuento',
                      '-${couponDiscount.toStringAsFixed(2)} Bs.',
                      isBold: true,
                    ),
                    _buildSummaryRow(
                      'Total',
                      '${total.toStringAsFixed(2)} Bs.',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Botón flotante centrado
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935), // Rojo principal
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderCompletedScreen(
                        estimatedTime: estimatedTime,
                        items: cartItems,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Confirmar pedido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // Importar la pantalla de pedido realizado
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

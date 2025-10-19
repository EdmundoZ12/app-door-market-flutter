import 'package:flutter/material.dart';

// --- MODELOS DE DATOS ---

class OrderProduct {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String image;

  OrderProduct({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}

class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final List<OrderProduct> products;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<OrderProduct> products = productList.map((i) => OrderProduct.fromJson(i)).toList();

    return Order(
      id: json['id'],
      date: json['date'],
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      products: products,
    );
  }
}

// --- WIDGET DE LA TARJETA ---

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  // Función para obtener el color según el estado
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Entregado':
        return Colors.green;
      case 'En Camino':
        return Colors.orange;
      case 'Pendiente':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: ID del pedido y Estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido: ${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Información: Fecha y Total
            Text('Fecha: ${order.date}'),
            const SizedBox(height: 4),
            Text(
              'Total: \$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const Divider(height: 24),
            // Resumen de productos y botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order.products.length} productos'),
                // --- MARCADOR DE POSICIÓN PARA NAVEGACIÓN ---
                TextButton(
                  onPressed: () {
                    // Funcionalidad vacía para ver productos
                    print('Navegar para ver productos del pedido ${order.id}');
                  },
                  child: const Row(
                    children: [
                      Text('Ver detalle'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

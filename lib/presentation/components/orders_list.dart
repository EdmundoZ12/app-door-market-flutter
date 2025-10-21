import 'package:flutter/material.dart';

import '../../data/model/order.dart';
import 'order_card.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({
    super.key,
    required this.orders,
    this.onOrderView,
    this.onOrderRepeat,
  });

  final List<Order> orders;
  final ValueChanged<Order>? onOrderView;
  final ValueChanged<Order>? onOrderRepeat;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron pedidos con los filtros seleccionados.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onViewDetails: () => onOrderView?.call(order),
          onRepeatOrder: () => onOrderRepeat?.call(order),
        );
      },
    );
  }
}

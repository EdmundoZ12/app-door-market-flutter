import 'package:door_market_app/data/model/last_order.dart';
import 'package:door_market_app/presentation/components/last_order_item.dart';
import 'package:door_market_app/service/last_order_service.dart';
import 'package:flutter/material.dart';

class LastOrderList extends StatefulWidget {
  const LastOrderList({
    super.key,
    this.order,
  });

  final LastOrder? order;

  @override
  State<LastOrderList> createState() => _LastOrderListState();
}

class _LastOrderListState extends State<LastOrderList> {
  final LastOrderService _service = const LastOrderService();
  late Future<List<_OrderItemEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.order != null ? _fromOrder(widget.order!) : _loadOrders();
  }

  Future<List<_OrderItemEntry>> _fromOrder(LastOrder order) async {
    return order.items
        .map((item) => _OrderItemEntry(order: order, item: item))
        .toList();
  }

  Future<List<_OrderItemEntry>> _loadOrders() async {
    final orders = await _service.fetchLastOrders();
    final entries = <_OrderItemEntry>[];

    for (final order in orders) {
      for (final item in order.items) {
        entries.add(_OrderItemEntry(order: order, item: item));
      }
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_OrderItemEntry>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar pedidos: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return const Center(child: Text('No hay pedidos recientes.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return LastOrderItem(
              key: ValueKey('${entry.order.id}-${entry.item.productId}'),
              item: entry.item,
              orderNumber: entry.order.orderNumber,
              status: entry.order.status,
              onIncrease: () {},
              onDecrease: () {},
              onDelete: () {},
            );
          },
        );
      },
    );
  }
}

class _OrderItemEntry {
  const _OrderItemEntry({required this.order, required this.item});

  final LastOrder order;
  final OrderItem item;
}

import 'package:door_market_app/data/model/order.dart';
import 'package:door_market_app/presentation/components/orders_list.dart';
import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:door_market_app/service/order_service.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  static const String name = 'orders_screen';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = const OrderService();

  static const List<String> _statusOptions = <String>[
    'Todos',
    'Entregado',
    'En camino',
    'Cancelado',
  ];

  String _selectedStatus = _statusOptions.first;
  DateTime? _selectedDate;
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderService.fetchOrders();
  }

  String _dateLabel(BuildContext context) {
    if (_selectedDate == null) return 'Hoy';
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatMediumDate(_selectedDate!);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tune_rounded, size: 20, color: Colors.black87),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isDense: true,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Colors.black87,
              ),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedStatus = value;
                });
              },
              items: _statusOptions
                  .map(
                    (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return OutlinedButton(
      onPressed: _pickDate,
      onLongPress: () {
        if (_selectedDate != null) {
          setState(() {
            _selectedDate = null;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_dateLabel(context), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          const Icon(Icons.calendar_month_outlined, size: 20),
        ],
      ),
    );
  }

  List<Order> _applyFilters(List<Order> orders) {
    return orders.where((order) {
      final matchesStatus =
          _selectedStatus == 'Todos' ||
          order.state.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesDate =
          _selectedDate == null ||
          (order.date.year == _selectedDate!.year &&
              order.date.month == _selectedDate!.month &&
              order.date.day == _selectedDate!.day);
      return matchesStatus && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const TopBar(title: 'Pedidos', showSearch: true, showFilters: false),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                _buildStatusFilter(),
                const SizedBox(width: 12),
                _buildDateFilter(context),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Error al cargar pedidos: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }

                final orders = snapshot.data ?? const <Order>[];
                final filteredOrders = _applyFilters(orders);

                return OrdersList(
                  orders: filteredOrders,
                  onOrderView: (order) =>
                      debugPrint('Ver detalles de pedido ${order.id}'),
                  onOrderRepeat: (order) =>
                      debugPrint('Repetir pedido ${order.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

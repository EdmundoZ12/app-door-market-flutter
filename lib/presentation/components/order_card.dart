import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/theme/app_theme.dart';
import '../../data/model/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onViewDetails,
    this.onRepeatOrder,
  });

  final Order order;
  final VoidCallback? onViewDetails;
  final VoidCallback? onRepeatOrder;

  Color _statusColor() {
    switch (order.state.toLowerCase()) {
      case 'en camino':
        return colorList.firstWhere(
          (color) => color == Colors.green,
          orElse: () => Colors.green,
        );
      case 'cancelado':
        return colorList.firstWhere(
          (color) => color == Colors.red,
          orElse: () => Colors.red,
        );
      case 'entregado':
        return colorList.firstWhere(
          (color) => color == Colors.deepPurple,
          orElse: () => Colors.deepPurple,
        );
      default:
        return Colors.black87;
    }
  }

  String _formattedDate(BuildContext context) {
    try {
      final locale = Localizations.localeOf(context).toLanguageTag();
      return DateFormat("d 'de' MMMM", locale).format(order.date);
    } catch (_) {
      final materialText = MaterialLocalizations.of(context);
      return materialText.formatMediumDate(order.date);
    }
  }

  String _formattedTotal() {
    final amount = order.total;
    return amount % 1 == 0
        ? '${amount.toInt()} BS'
        : '${amount.toStringAsFixed(2)} BS';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final buttonsColor = colorList.firstWhere(
      (color) => color == Colors.deepPurple,
      orElse: () => Colors.deepPurple,
    );
    final redColor = colorList.firstWhere(
      (color) => color == Colors.red,
      orElse: () => Colors.red,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.36),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icons/order-icon.png',
            width: 52,
            height: 52,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order.state,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formattedDate(context),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images/icons/date-icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/icons/product-icon.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${order.productsCount} Productos',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: redColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formattedTotal(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: buttonsColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: ElevatedButton.icon(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonsColor,
                          minimumSize: const Size.fromHeight(26),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                        icon: Image.asset(
                          'assets/images/icons/detail-icon.png',
                          width: 16,
                          height: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Ver',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 110,
                      child: ElevatedButton.icon(
                        onPressed: onRepeatOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonsColor,
                          minimumSize: const Size.fromHeight(26),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                        icon: Image.asset(
                          'assets/images/icons/repeat-icon.png',
                          width: 16,
                          height: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Repetir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

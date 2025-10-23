import 'package:door_market_app/data/model/last_order.dart';
import 'package:door_market_app/presentation/components/last_order_list.dart';
import 'package:door_market_app/presentation/components/menu_footer.dart';
import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LastOrderScreen extends StatelessWidget {
  const LastOrderScreen({super.key, this.navigationShell, this.order});

  static const String name = 'last_order_screen';

  final StatefulNavigationShell? navigationShell;
  final LastOrder? order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: navigationShell == null
          ? null
          : MenuFooter(navigationShell: navigationShell!),
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(
              title: 'Repetir pedido',
              showSearch: false,
              showFilters: false,
              showNotifications: false,
              showCart: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: const Color(0xFFE53935),
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              context.pop();
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                        if (order != null)
                          Text(
                            'Pedido: ${order!.orderNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE53935),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: LastOrderList(order: order)),
                    if (order != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE53935).withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              order!.formattedTotal,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE53935),
                              ),
                            ),
                            const Spacer(),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 160,
                                maxWidth: 220,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push('/place-order');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE53935),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Comprar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

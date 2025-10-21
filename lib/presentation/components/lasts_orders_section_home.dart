import 'package:door_market_app/data/model/last_order.dart';
import 'package:door_market_app/service/last_order_service.dart';
import 'package:flutter/material.dart';

class LastOrdersSection extends StatefulWidget {
  final Function(LastOrder)? onViewProducts;
  final Function(LastOrder)? onRepeatOrder;

  const LastOrdersSection({super.key, this.onViewProducts, this.onRepeatOrder});

  @override
  State<LastOrdersSection> createState() => _LastOrdersSectionState();
}

class _LastOrdersSectionState extends State<LastOrdersSection> {
  final LastOrderService _orderService = const LastOrderService();
  List<LastOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _orderService.fetchLastOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'Últimos Pedidos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_orders.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No hay pedidos recientes',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 240,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: _orders.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return AnimatedOrderCard(
                  order: order,
                  onViewProducts: () => widget.onViewProducts?.call(order),
                  onRepeat: () => widget.onRepeatOrder?.call(order),
                );
              },
            ),
          ),
      ],
    );
  }
}

class AnimatedOrderCard extends StatefulWidget {
  final LastOrder order;
  final VoidCallback? onViewProducts;
  final VoidCallback? onRepeat;

  const AnimatedOrderCard({
    super.key,
    required this.order,
    this.onViewProducts,
    this.onRepeat,
  });

  @override
  State<AnimatedOrderCard> createState() => _AnimatedOrderCardState();
}

class _AnimatedOrderCardState extends State<AnimatedOrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => _controller.forward(),
      onPanEnd: (_) => _controller.reverse(),
      onPanCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: OrderCard(
          order: widget.order,
          onViewProducts: widget.onViewProducts,
          onRepeat: widget.onRepeat,
        ),
      ),
    );
  }
}


class OrderCard extends StatefulWidget {
  final LastOrder order;
  final VoidCallback? onViewProducts;
  final VoidCallback? onRepeat;

  const OrderCard({
    super.key,
    required this.order,
    this.onViewProducts,
    this.onRepeat,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      color: Colors.white,
      child: SizedBox(
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mini carrusel de productos
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: widget.order.items.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.order.productImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF5F5F5),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Indicadores del carrusel
              if (widget.order.items.length > 1) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.order.items.length,
                      (index) {
                        final isActive = _currentPage == index;
                        return Container(
                          margin: EdgeInsets.only(
                            right: index < widget.order.items.length - 1 ? 4 : 0,
                          ),
                          width: isActive ? 16 : 6,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFD41307)
                                : Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Ver Productos
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: widget.onViewProducts,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Ver Productos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD41307),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.order.formattedTotal,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD41307),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Botón Repetir
              Center(
                child: SizedBox(
                  width: 110,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: widget.onRepeat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7907D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Repetir',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.refresh,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:math' as math;

import 'package:door_market_app/data/model/cart_item.dart';
import 'package:door_market_app/presentation/components/product_cart.dart';
import 'package:door_market_app/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const double _kCartPanelWidth = 300;
const double _kPanelVerticalOffset = 44;
const double _kTriggerWidth = 40;

class CartController {
  VoidCallback? _toggle;

  void _attach(VoidCallback toggle) {
    _toggle = toggle;
  }

  void _detach(VoidCallback toggle) {
    if (_toggle == toggle) {
      _toggle = null;
    }
  }

  void toggle() {
    _toggle?.call();
  }
}

class Cart extends StatefulWidget {
  const Cart({
    super.key,
    this.cartAssetPath = 'assets/data/cart.json',
    this.onCheckout,
    this.controller,
  });

  final String cartAssetPath;
  final VoidCallback? onCheckout;
  final CartController? controller;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late CartService _cartService;
  List<CartItem> _items = const [];
  bool _isOpen = false;
  bool _isLoading = true;
  String? _error;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  double get _subtotal =>
      _items.fold(0, (total, item) => total + item.totalCost);

  @override
  void initState() {
    super.initState();
    _cartService = CartService(assetPath: widget.cartAssetPath);
    _loadCart();
    widget.controller?._attach(_toggleCart);
  }

  @override
  void didUpdateWidget(Cart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartAssetPath != widget.cartAssetPath) {
      _cartService = CartService(assetPath: widget.cartAssetPath);
      _loadCart();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(_toggleCart);
      widget.controller?._attach(_toggleCart);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.controller?._detach(_toggleCart);
    super.dispose();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _notifyOverlay();

    try {
      final items = await _cartService.loadCartItems();
      if (!mounted) return;
      setState(() {
        _items = items;
      });
      _notifyOverlay();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _items = const [];
        _error = 'Error al leer el carrito: $error';
      });
      _notifyOverlay();
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _notifyOverlay();
    }
  }

  void _toggleCart() {
    if (_isOpen) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideOverlay,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(
              _kTriggerWidth - _kCartPanelWidth,
              _kPanelVerticalOffset,
            ),
            child: _CartPanel(
              isLoading: _isLoading,
              error: _error,
              items: _items,
              subtotal: _subtotal,
              onQuantityChanged: _updateQuantity,
              onCheckout: widget.onCheckout,
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _updateQuantity(int index, int quantity) {
    if (index < 0 || index >= _items.length) return;
    final clamped = quantity.clamp(0, 999);
    setState(() {
      final updated = List<CartItem>.from(_items);
      updated[index] = updated[index].copyWith(quantity: clamped);
      _items = updated;
    });
    _notifyOverlay();
  }

  void _notifyOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        onPressed: _toggleCart,
        icon: Icon(
          _isOpen ? Icons.close : Icons.shopping_cart,
          color: const Color(0xFFE53935),
          size: 26,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: _kTriggerWidth,
          minHeight: 40,
        ),
      ),
    );
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel({
    required this.isLoading,
    required this.error,
    required this.items,
    required this.subtotal,
    required this.onQuantityChanged,
    required this.onCheckout,
  });

  final bool isLoading;
  final String? error;
  final List<CartItem> items;
  final double subtotal;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final maxHeight = math.min(88.0 * items.length, 260.0);

    Widget content;
    if (isLoading) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (error != null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          error!,
          style: const TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      );
    } else if (items.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'Tu carrito está vacío.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: maxHeight,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return ProductCart(
                  key: ValueKey(item.product.id),
                  item: item,
                  onQuantityChanged: (value) => onQuantityChanged(index, value),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
              Text(
                '${subtotal.toStringAsFixed(2)} Bs.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/place-order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Realizar Pedido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: _kCartPanelWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE53935)),
        ),
        child: content,
      ),
    );
  }
}

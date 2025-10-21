import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/cart_item.dart';
import '../../../service/cart_service.dart';

// --- Pantalla Principal del Carrito ---
class CartScreen extends StatefulWidget {
  static const String name = 'cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  // --- Lógica de la Interfaz ---
  void _incrementQuantity(CartItem item) {
    _cartService.incrementItem(item);
  }

  void _decrementQuantity(CartItem item) {
    _cartService.decrementItem(item);
  }

  double _calculateSubtotal(List<CartItem> items) {
    double subtotal = 0;
    for (var item in items) {
      subtotal += item.subtotal;
    }
    return subtotal;
  }

  int _calculateTotalItems(List<CartItem> items) {
    int totalItems = 0;
    for (var item in items) {
      totalItems += item.quantity;
    }
    return totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: _cartService.itemsNotifier,
      builder: (context, cartItems, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    '${_calculateTotalItems(cartItems)} items',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --- Lista de Productos ---
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Tu carrito está vacío',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _buildCartItem(item);
                          },
                        ),
                ),
                // --- Resumen del Pedido ---
                _buildSummary(cartItems),
              ],
            ),
          ),
          // --- Botón para Realizar Pedido ---
          bottomNavigationBar: cartItems.isNotEmpty
              ? _buildCheckoutButton()
              : null,
        );
      },
    );
  }

  // --- Widgets Secundarios ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón de cerrar
          GestureDetector(
            onTap: () => context.pop(), // Vuelve a la pantalla anterior
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          // Información del usuario
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE53935),
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pepito Perez Palotes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Av. Santa cruz # 123',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
        ),
      ),
      child: Row(
        children: [
          // Columna con nombre y selector de cantidad
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Selector de cantidad
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(item),
                        iconSize: 18,
                        splashRadius: 20,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementQuantity(item),
                        iconSize: 18,
                        splashRadius: 20,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Precio e imagen
          Text(
            '${item.subtotal.toStringAsFixed(2)} Bs',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.product.primaryImage.isNotEmpty
                  ? Image.asset(item.product.primaryImage, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<CartItem> items) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tiempo estimado', style: TextStyle(fontSize: 16)),
              Text(
                '15 Min',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_calculateSubtotal(items).toStringAsFixed(2)} Bs',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ElevatedButton(
        onPressed: () {
          // Lógica para realizar el pedido
          print('Pedido realizado!');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF9FA8DA,
          ), // Un color similar al de la imagen
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Realizar Pedido >',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

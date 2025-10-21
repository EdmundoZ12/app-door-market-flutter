import 'package:door_market_app/data/model/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;

  // Helper para incrementar la cantidad
  void increment() {
    quantity++;
  }
}

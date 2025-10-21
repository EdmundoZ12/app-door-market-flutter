import 'package:door_market_app/data/model/cart_item.dart';
import 'package:door_market_app/data/model/product.dart';
import 'package:flutter/foundation.dart';

class CartService {
  // Singleton pattern para tener una única instancia del servicio en toda la app.
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // ValueNotifier notificará a los widgets que escuchan cuando la lista de items cambie.
  final ValueNotifier<List<CartItem>> itemsNotifier = ValueNotifier([]);

  List<CartItem> get items => itemsNotifier.value;

  void addProduct(Product product, int quantity) {
    final currentItems = List<CartItem>.from(items);
    // Buscamos si el producto ya está en el carrito.
    final existingItemIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Si ya existe, solo actualizamos la cantidad.
      currentItems[existingItemIndex].quantity += quantity;
    } else {
      // Si es nuevo, lo añadimos a la lista.
      currentItems.add(CartItem(product: product, quantity: quantity));
    }
    // Notificamos a los listeners que la lista ha cambiado.
    itemsNotifier.value = currentItems;
  }

  void incrementItem(CartItem item) {
    item.quantity++;
    itemsNotifier.value = List<CartItem>.from(items);
  }

  void decrementItem(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // Si la cantidad es 1, eliminamos el producto del carrito.
      items.remove(item);
    }
    itemsNotifier.value = List<CartItem>.from(items);
  }

  void removeItem(CartItem item) {
    items.remove(item);
    itemsNotifier.value = List<CartItem>.from(items);
  }
}

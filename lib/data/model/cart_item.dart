import 'package:door_market_app/data/model/product.dart';

class CartItem {
  CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get totalCost => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    if (productJson is! Map<String, dynamic>) {
      throw const FormatException('CartItem sin producto válido');
    }

    final quantityValue = json['quantity'];
    final quantity = quantityValue is int
        ? quantityValue
        : int.tryParse(quantityValue.toString()) ?? 0;

    return CartItem(
      product: Product.fromJson(
        productJson.map((key, value) => MapEntry(key.toString(), value)),
      ),
      quantity: quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'images': product.images,
        'categoryId': product.categoryId,
        'description': product.description,
        'popularity': product.popularity,
        'onPromotion': product.onPromotion,
      },
      'quantity': quantity,
    };
  }
}

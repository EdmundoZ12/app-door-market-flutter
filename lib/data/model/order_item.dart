class OrderItem {
  OrderItem({
    required this.productId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.image,
  });

  final int productId;
  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final String image;

  double get totalPrice => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'image': image,
    };
  }

  // Copiar con cambios
  OrderItem copyWith({
    int? productId,
    String? name,
    String? description,
    int? quantity,
    double? unitPrice,
    String? image,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      image: image ?? this.image,
    );
  }
}

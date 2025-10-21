class LastOrder {
  LastOrder({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });

  final int id;
  final String orderNumber;
  final String date;
  final String status;
  final double total;
  final List<OrderItem> items;

  String get formattedTotal => '${total.toInt()} BS';

  int get itemCount => items.length;

  List<String> get productImages => items.map((item) => item.image).toList();

  factory LastOrder.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsList = json['items'] ?? <dynamic>[];
    return LastOrder(
      id: json['id'] as int,
      orderNumber: json['orderNumber'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      items: itemsList
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'date': date,
      'status': status,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.image,
  });

  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String image;

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }
}

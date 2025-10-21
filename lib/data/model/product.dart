class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.categoryId,
    required this.description,
    required this.popularity,
    this.onPromotion = false,
  });

  final int id;
  final String name;
  final double price;
  final List<String> images;
  final int categoryId;
  final String description;
  final int popularity;
  final bool onPromotion;

  String get primaryImage => images.isNotEmpty ? images.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imageList = json['images'] ?? <dynamic>[];
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      images: imageList
          .whereType<String>()
          .map((path) => path.startsWith('assets/') ? path : 'assets/$path')
          .toList(),
      categoryId: json['categoryId'] as int,
      description: json['description'] as String? ?? '',
      popularity: json['popularity'] as int? ?? 0,
      onPromotion: json['onPromotion'] as bool? ?? false,
    );
  }
}

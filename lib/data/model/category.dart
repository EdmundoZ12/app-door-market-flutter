class Category {
  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.imagePath,
    required this.productCount,
  });

  final int id;
  final String name;
  final String icon;
  final String imagePath;
  final int productCount;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      imagePath: _resolveAssetPath(json['image'] as String? ?? ''),
      productCount: json['productCount'] as int? ?? 0,
    );
  }

  static String _resolveAssetPath(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('assets/')) return path;
    return 'assets/$path';
  }
}

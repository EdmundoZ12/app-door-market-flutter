import 'package:flutter/material.dart';

import '../../data/model/category.dart';
import '../../data/model/product.dart';
import 'product_carousel.dart';

class CategoryProductsSection extends StatelessWidget {
  const CategoryProductsSection({
    super.key,
    required this.category,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
  });

  final Category category;
  final List<Product> products;
  final ProductCallback? onProductTap;
  final ProductCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset(
                    category.imagePath,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.category, color: Color(0xFF7A3BFF)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2D46),
                    ),
                  ),
                ),
                if (category.productCount > 0)
                  Text(
                    'Ver más ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A3BFF),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProductCarousel(
            products: products,
            onProductTap: onProductTap,
            onAddToCart: onAddToCart,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/model/product.dart';
import 'product_carousel.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({
    super.key,
    required this.products,
    required this.title,
    required this.headerImagePath,
    this.onProductTap,
    this.onAddToCart,
  });

  final List<Product> products;
  final String title;
  final String headerImagePath;
  final ProductCallback? onProductTap;
  final ProductCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                headerImagePath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.local_offer_outlined,
                    color: Color(0xFFE53935),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
    );
  }
}

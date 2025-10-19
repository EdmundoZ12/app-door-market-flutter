import 'package:flutter/material.dart';

import '../../data/model/product.dart';
import 'product_card.dart';

typedef ProductCallback = void Function(Product product);

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
  });

  final List<Product> products;
  final ProductCallback? onProductTap;
  final ProductCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.none,
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            onTap: onProductTap == null
                ? null
                : () => onProductTap!(product),
            onAddToCart: onAddToCart == null
                ? null
                : () => onAddToCart!(product),
          );
        },
      ),
    );
  }
}

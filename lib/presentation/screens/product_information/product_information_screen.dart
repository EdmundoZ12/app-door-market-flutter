import 'package:door_market_app/data/model/category.dart';
import 'package:door_market_app/data/model/product.dart';
import 'package:door_market_app/presentation/components/cart.dart';
import 'package:door_market_app/presentation/components/menu_footer.dart';
import 'package:door_market_app/presentation/components/product_detail_carousel.dart';
import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:door_market_app/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductInformationScreen extends StatefulWidget {
  const ProductInformationScreen({
    super.key,
    required this.product,
    this.navigationShell,
    this.categoryName,
  });

  static const String name = 'product_information_screen';

  final Product product;
  final StatefulNavigationShell? navigationShell;
  final String? categoryName;

  @override
  State<ProductInformationScreen> createState() =>
      _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  final CategoryService _categoryService = const CategoryService();
  final CartController _cartController = CartController();

  late int _quantity;
  bool _isFavorite = false;
  String? _categoryName;
  bool _isLoadingCategory = false;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
    _categoryName = widget.categoryName;
    if (_categoryName == null) {
      _fetchCategoryName();
    }
  }

  Future<void> _fetchCategoryName() async {
    setState(() => _isLoadingCategory = true);
    try {
      final categories = await _categoryService.fetchCategories();
      Category? category;
      try {
        category = categories.firstWhere(
          (element) => element.id == widget.product.categoryId,
        );
      } catch (_) {
        category = null;
      }
      if (!mounted) return;
      setState(() {
        _categoryName = category?.name ?? 'Producto';
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _categoryName = 'Producto';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingCategory = false);
      }
    }
  }

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final price = product.price;
    final priceFormatted = price % 1 == 0
        ? price.toInt().toString()
        : price.toStringAsFixed(2);
    final priceLabel = 'Bs. $priceFormatted';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.navigationShell == null
          ? null
          : MenuFooter(navigationShell: widget.navigationShell!),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: 'Producto',
              showSearch: true,
              showFilters: false,
              cartController: _cartController,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: const Color(0xFFE53935),
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              context.pop();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        if (_isLoadingCategory)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Expanded(
                            child: Text(
                              _categoryName ?? 'Producto',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProductDetailCarousel(images: product.images),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _FavoriteToggle(
                          isFavorite: _isFavorite,
                          onToggle: _toggleFavorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            priceLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _QuantitySelector(
                          quantity: _quantity,
                          onDecrement: _decrementQuantity,
                          onIncrement: _incrementQuantity,
                        ),
                        const SizedBox(width: 12),
                        _CartButton(controller: _cartController, onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'Sin descripción disponible.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(label: '-', onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _QtyButton(label: '+', onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FavoriteToggle extends StatelessWidget {
  const _FavoriteToggle({required this.isFavorite, required this.onToggle});

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        size: 32,
        color: isFavorite ? const Color(0xFFE53935) : Colors.black,
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({this.controller, this.onTap});

  final CartController? controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller?.toggle();
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(12),
        child: const Icon(
          Icons.shopping_cart_outlined,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}

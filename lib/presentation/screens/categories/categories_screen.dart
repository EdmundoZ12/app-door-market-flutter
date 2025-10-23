import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/carrusel_home.dart';
import '../../components/category_products_section.dart';
import '../../components/top_bar.dart';
import '../../../data/model/category.dart';
import '../../../data/model/product.dart';
import '../../../service/category_service.dart';
import '../../../service/product_service.dart';
import '../product_information/product_information_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const String name = 'categories_screen';
  const CategoriesScreen({super.key, this.navigationShell});

  final StatefulNavigationShell? navigationShell;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = const CategoryService();
  final ProductService _productService = const ProductService();
  late Future<_CategoriesContent> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategoriesContent();
  }

  Future<_CategoriesContent> _loadCategoriesContent() async {
    final categories = await _categoryService.fetchCategories();
    final products = await _productService.fetchAllProducts();

    final Map<int, List<Product>> groupedProducts = {
      for (final category in categories) category.id: <Product>[],
    };

    for (final product in products) {
      final list = groupedProducts[product.categoryId];
      if (list != null) {
        list.add(product);
      }
    }

    for (final productsInCategory in groupedProducts.values) {
      productsInCategory.sort((a, b) => b.popularity.compareTo(a.popularity));
    }

    return _CategoriesContent(
      categories: categories,
      productsByCategory: groupedProducts,
    );
  }

  void _openProductDetail(
    BuildContext context,
    Product product,
    String categoryName,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductInformationScreen(
          product: product,
          navigationShell: widget.navigationShell,
          categoryName: categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const TopBar(
            title: 'Categorías',
            showSearch: true,
            showFilters: true,
          ),
          Expanded(
            child: FutureBuilder<_CategoriesContent>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Error al cargar categorías: ${snapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final data = snapshot.data;
                if (data == null || data.categories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay categorías disponibles por el momento.',
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const CarruselHome(),
                      const SizedBox(height: 24),
                      ...data.categories.map(
                        (category) => CategoryProductsSection(
                          category: category,
                          products:
                              data.productsByCategory[category.id] ?? const [],
                          onProductTap: (product) => _openProductDetail(
                            context,
                            product,
                            category.name,
                          ),
                          onAddToCart: (product) =>
                              print('Add to cart: ${product.name}'),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesContent {
  _CategoriesContent({
    required this.categories,
    required this.productsByCategory,
  });

  final List<Category> categories;
  final Map<int, List<Product>> productsByCategory;
}

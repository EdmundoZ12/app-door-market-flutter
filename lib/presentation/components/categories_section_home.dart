import 'package:flutter/material.dart';

import '../../data/model/category.dart';
import '../../service/category_service.dart';

class CategoriesSectionHome extends StatefulWidget {
  const CategoriesSectionHome({super.key, this.onCategoryTap});

  final ValueChanged<Category>? onCategoryTap;

  @override
  State<CategoriesSectionHome> createState() => _CategoriesSectionHomeState();
}

class _CategoriesSectionHomeState extends State<CategoriesSectionHome> {
  final CategoryService _categoryService = const CategoryService();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título "Categorías"
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categorías',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2D46),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Lista horizontal de categorías
        FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final categories = snapshot.data!;

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryItem(
                    category: category,
                    onTap: () => widget.onCategoryTap?.call(category),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor circular con la imagen
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  category.imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.category,
                    size: 40,
                    color: Color(0xFF2F2D46),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Nombre de la categoría
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2F2D46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

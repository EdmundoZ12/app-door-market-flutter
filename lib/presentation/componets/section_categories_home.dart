// app-door-market-flutter\lib\presentation\componets\section_categories_home.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. Modelo actualizado para coincidir con el JSON
class Category {
  final int id;
  final String name;
  final String imagePath;
  final String icon;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.icon,
    required this.productCount,
  });

  // Factory constructor para crear una instancia desde un mapa (JSON)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      // Añadimos el prefijo 'assets/' a la ruta de la imagen del JSON
      imagePath: 'assets/${json['image']}',
      icon: json['icon'],
      productCount: json['productCount'],
    );
  }
}

class CategoriesSection extends StatefulWidget {
  CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    // Carga el contenido del archivo JSON como un String
    final String response = await rootBundle.loadString(
      'assets/data/categories.json',
    );
    // Decodifica el String JSON a un Map
    final data = await json.decode(response);
    // Extrae la lista de categorías del Map
    final List<dynamic> categoriesJson = data['categories'];
    // Mapea la lista de JSON a una lista de objetos Category
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Usamos un FutureBuilder para manejar la carga asíncrona
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture, // Usamos la variable de estado
      builder: (context, snapshot) {
        // Mientras carga, muestra un indicador de progreso
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // Si hay un error, muéstralo
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar categorías: ${snapshot.error}'),
          );
        }
        // Si no hay datos (aunque no debería pasar si el JSON está bien), muestra un mensaje
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron categorías.'));
        }

        // Cuando los datos están listos, construye la UI
        final categories = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 100, // Altura ajustada para el nuevo tamaño
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == categories.length - 1 ? 0 : 12.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('Tapped on ${category.name}');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Image.asset(
                              category.imagePath,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.category,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

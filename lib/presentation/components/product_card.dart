// app-door-market-flutter\lib\presentation\components\product_card.dart

import 'package:flutter/material.dart';

// 1. Modelo de datos para el producto
class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });

  // Factory constructor para crear una instancia desde un mapa (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      // Añadimos el prefijo 'assets/' a la ruta de la imagen del JSON
      imagePath: 'assets/${json['image']}',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

// 2. Widget reutilizable para la tarjeta de producto
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Sombra y bordes redondeados
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen y botón de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  product.imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Manejo de error si la imagen no carga
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // Lógica para añadir al carrito
                      print('Añadir al carrito: ${product.name}');
                    },
                  ),
                ),
              ),
            ],
          ),

          // Detalles del producto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}', // Formato de precio
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

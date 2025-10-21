import 'package:door_market_app/data/model/product.dart';
import 'package:door_market_app/presentation/components/carrusel_home.dart';
import 'package:door_market_app/presentation/components/categories_section_home.dart';
import 'package:door_market_app/presentation/components/lasts_orders_section_home.dart';
import 'package:door_market_app/presentation/components/popular_products_section.dart';
import 'package:flutter/material.dart';

import '../../../service/product_service.dart';
import '../../components/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String name = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // TopBar como widget normal, NO como AppBar
          TopBar(
            title: 'DoorMarket',
            showSearch: true,
            showFilters: false,
            onSearchClick: () {
              print('Búsqueda clickeada');
            },
            onNotificationClick: () {
              print('Notificaciones clickeadas');
            },
            onCartClick: () {
              print('Carrito clickeado');
            },
          ),

          // Contenido scrolleable
          Expanded(child: _HomeView()),
        ],
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ProductService _productService = const ProductService();
  late Future<List<Product>> _popularProductsFuture;
  static const String _popularSectionTitle = 'Productos populares';
  static const String _popularSectionImage = 'assets/images/popular.png';

  @override
  void initState() {
    super.initState();
    _popularProductsFuture = _productService.fetchPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Componente 1: Carrusel
          const CarruselHome(),

          const SizedBox(height: 24),

          const CategoriesSectionHome(),

          const SizedBox(height: 24),

          // // Componente 3: Productos destacados
          const LastOrdersSection(),

          const SizedBox(height: 24),

          // // Componente 4: Ofertas especiales
          // const OfertasSection(),
          _PopularProductsLoader(
            future: _popularProductsFuture,
            title: _popularSectionTitle,
            headerImagePath: _popularSectionImage,
            onProductTap: (product) => print('Tapped on ${product.name}'),
            onAddToCart: (product) => print('Add to cart: ${product.name}'),
          ),
        ],
      ),
    );
  }
}

class _PopularProductsLoader extends StatelessWidget {
  const _PopularProductsLoader({
    required this.future,
    required this.title,
    required this.headerImagePath,
    this.onProductTap,
    this.onAddToCart,
  });

  final Future<List<Product>> future;
  final String title;
  final String headerImagePath;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Error al cargar productos: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const SizedBox(
            height: 80,
            child: Center(
              child: Text('No hay productos populares disponibles.'),
            ),
          );
        }

        return PopularProductsSection(
          products: products,
          title: title,
          headerImagePath: headerImagePath,
          onProductTap: onProductTap,
          onAddToCart: onAddToCart,
        );
      },
    );
  }
}

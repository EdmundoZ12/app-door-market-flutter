import 'package:door_market_app/presentation/components/carrusel_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Door Market')),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Componente 1: Carrusel
          const CarruselHome(),

          const SizedBox(height: 24),

          // // Componente 2: Sección de categorías
          // const CategoriasSection(),

          // const SizedBox(height: 24),

          // // Componente 3: Productos destacados
          // const ProductosDestacados(),

          // const SizedBox(height: 24),

          // // Componente 4: Ofertas especiales
          // const OfertasSection(),

          // const SizedBox(height: 16),
        ],
      ),
    );
  }
}

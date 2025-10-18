import 'package:door_market_app/presentation/components/carrusel_home.dart';
import 'package:flutter/material.dart';
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
          Expanded(child: const _HomeView()),
        ],
      ),
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
          const SizedBox(height: 100), // Espacio extra al final
        ],
      ),
    );
  }
}

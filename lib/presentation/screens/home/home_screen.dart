import 'package:door_market_app/presentation/components/carrusel_home.dart';
import 'package:door_market_app/presentation/components/order_card.dart';
import 'package:door_market_app/presentation/components/section_categories_home.dart';
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
      // Usamos un CustomScrollView para combinar widgets fijos y scrolleables
      body: CustomScrollView(
        slivers: [
          // 1. La TopBar se convierte en un SliverAppBar para que se quede fija arriba
          SliverAppBar(
            pinned: true, // La mantiene visible al hacer scroll
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: TopBar(
              title: 'DoorMarket',
              showSearch: true,
              onSearchClick: () => print('Búsqueda clickeada'),
              onNotificationClick: () => print('Notificaciones clickeadas'),
              onCartClick: () => print('Carrito clickeado'),
            ),
            // La altura de la barra
            toolbarHeight: 130,
          ),
          // 2. El resto del contenido va dentro de un SliverToBoxAdapter
          const SliverToBoxAdapter(child: _HomeView()),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    // Creamos un pedido de ejemplo para probar la tarjeta de pedido
    final testOrder = Order(
      id: 'ORD-2024-002',
      date: '2024-05-22',
      total: 44.00,
      status: 'En Camino',
      products: [
        OrderProduct(
          productId: 'prod-020',
          name: 'Pollo (Kg)',
          quantity: 2,
          price: 22.00,
          image: 'images/productos/pollo.jpg',
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Componente 1: Carrusel
        const CarruselHome(),
        const SizedBox(height: 24),

        // Componente 2: Sección de categorías
        CategoriesSection(),
        const SizedBox(height: 24),

        // Componente de prueba: Tarjeta de pedido
        OrderCard(order: testOrder),

        const SizedBox(height: 24),
        const SizedBox(height: 100), // Espacio extra al final
      ],
    );
  }
}

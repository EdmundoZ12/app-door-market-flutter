import 'package:door_market_app/presentation/components/promotions_section.dart';
import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:flutter/material.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);
  static const String name = 'promotions_screen';

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // TopBar como widget normal, NO como AppBar
          TopBar(
            title: 'Promociones',
            showSearch: true,
            showFilters: true,
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
          Expanded(child: _PromotionsView()),
        ],
      ),
    );
  }
}

class _PromotionsView extends StatefulWidget {
  @override
  State<_PromotionsView> createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<_PromotionsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Componente 1: Carrusel
          const PromotionsSection(),
        ],
      ),
    );
  }
}

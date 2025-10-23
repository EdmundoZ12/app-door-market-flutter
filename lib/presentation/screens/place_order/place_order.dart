import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:door_market_app/presentation/screens/place_order/delivery_address_information.dart';
import 'package:door_market_app/presentation/screens/place_order/personal_data_information.dart';
import 'package:door_market_app/presentation/screens/place_order/payment_method_information.dart';
import 'package:flutter/material.dart';
import 'package:door_market_app/presentation/screens/place_order/order_summary_information.dart';
import 'package:go_router/go_router.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({Key? key}) : super(key: key);
  static const String name = 'place_order_screen';

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // TopBar como widget normal, NO como AppBar
              TopBar(
                title: 'Realizar Pedido',
                showSearch: false,
                showFilters: false,
                showCart: false,
                showNotifications: false,
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
              Expanded(child: _PlaceOrderView()),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFE53935),
              onPressed: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceOrderView extends StatefulWidget {
  @override
  State<_PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<_PlaceOrderView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Componente 1: Carrusel
          const PersonalDataInformation(),
          const SizedBox(height: 24),
          const DeliveryAddressInformation(),
          const SizedBox(height: 24),
          const PaymentMethodInformation(),
          const SizedBox(height: 24),
          const OrderSummaryInformation(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

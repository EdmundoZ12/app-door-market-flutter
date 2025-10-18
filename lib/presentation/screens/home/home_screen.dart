import 'package:flutter/material.dart';
import '../../components/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String name = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TopBar reutilizable
            TopBar(
              title: 'DoorMarket',             
            ),
            // Resto del contenido del home
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Aquí irá el banner de promoción
                    // Las categorías
                    // Los últimos pedidos
                    // etc.
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Contenido del Home',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
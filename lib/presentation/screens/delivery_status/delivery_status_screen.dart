import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Pantalla Principal de Estado de Entrega ---
class DeliveryStatusScreen extends StatefulWidget {
  static const String name = 'delivery_status_screen';
  const DeliveryStatusScreen({super.key});

  @override
  State<DeliveryStatusScreen> createState() => _DeliveryStatusScreenState();
}

class _DeliveryStatusScreenState extends State<DeliveryStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // --- Mapa de Fondo (como una imagen fija) ---
          Image.asset(
            'assets/images/mapa_estatico.JPG',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // --- Botones flotantes sobre el mapa ---
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildMapButton(icon: Icons.layers_outlined),
                const SizedBox(height: 8),
                _buildMapButton(icon: Icons.send_outlined),
              ],
            ),
          ),

          // --- Panel Inferior de Estado ---
          _buildStatusPanel(),
        ],
      ),
    );
  }

  // --- Widgets Secundarios ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFE53935)),
        // Acción del botón de regreso
        onPressed: () => context.go('/'),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo_doormarket.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.store, color: Color(0xFFE53935));
            },
          ),
          const SizedBox(width: 8), // Espacio después del logo
          const Text(
            'Estado De Entrega',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton({required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black54),
        onPressed: () {
          // Lógica para los botones del mapa
        },
      ),
    );
  }

  Widget _buildStatusPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35, // Altura inicial del panel
      minChildSize: 0.35, // Altura mínima
      maxChildSize: 0.5, // Altura máxima al arrastrar
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0)],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: [
              // --- Mensaje de Estado ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.red.shade700, size: 40),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Se estan Alistando tus Productos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 12),

              // --- Indicador de Progreso ---
              _buildProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProgressStep(title: 'Preparacion', isActive: true),
          _buildProgressStep(title: 'En Camino', isActive: false),
          _buildProgressStep(title: 'En tu Puerta', isActive: false),
        ],
      ),
    );
  }

  Widget _buildProgressStep({required String title, required bool isActive}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8), // Aumentamos el espaciado
        Container(
          height: 8, // Hacemos la barra un poco más alta
          width: 95, // Y un poco más ancha
          decoration: BoxDecoration(
            // Si está activo, color sólido. Si no, borde rojo y fondo blanco.
            color: isActive ? Colors.red.shade700 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? null
                : Border.all(
                    color: Color(0xFFE53935),
                    width: 1.5,
                  ),
          ),
        ),
      ],
    );
  }
}

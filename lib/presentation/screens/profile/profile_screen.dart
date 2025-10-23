import 'package:door_market_app/presentation/components/top_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String name = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // TopBar como widget normal, NO como AppBar
          TopBar(
            title: 'Perfil',
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
          Expanded(child: _ProfileView()),
        ],
      ),
    );
  }
}

// --- ProfileSection content directly here ---
class _ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, nombre, email, barra de nivel, opciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.asset(
                      'assets/images/profile/avatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Arnulfo Morales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('arnulfo.morales@ejemplo.com', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nivel de usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 12,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Compras: 12/20', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Opciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 8),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.person_outline, color: Color(0xFFE53935)),
                title: Text('Editar perfil'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.lock_outline, color: Color(0xFFE53935)),
                title: Text('Cambiar contraseña'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.history, color: Color(0xFFE53935)),
                title: Text('Historial de pedidos'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFFE53935)),
                title: Text('Cerrar sesión'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:door_market_app/presentation/components/top_bar.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TopBar
          const TopBar(
            title: 'Perfil',
            showSearch: false,
            showFilters: false,
            showCart: false,
            showNotifications: false,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/profile/avatar.png'),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 12),
                // Nombre
                const Text('Joe Cooper', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
                const SizedBox(height: 4),
                // Email
                const Text('joe.cooper@gmail.com', style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 16),
                // Nivel
                const Text('Your level', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 4),
                Container(
                  width: 180,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ProfileOption(icon: Icons.notifications, label: 'Notificaciones'),
                _ProfileOption(icon: Icons.person, label: 'Información Personal'),
                _ProfileOption(icon: Icons.lightbulb_outline, label: 'Sugerir una función'),
                _ProfileOption(icon: Icons.language, label: 'Idioma', trailing: Text('Español', style: TextStyle(color: Colors.black54))),
                _ProfileOption(icon: Icons.settings, label: 'Configuración'),
                _ProfileOption(icon: Icons.help_outline, label: 'FAQ'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;

  const _ProfileOption({
    Key? key,
    required this.icon,
    required this.label,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFE53935)),
      title: Text(label, style: TextStyle(fontSize: 16)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: () {},
    );
  }
}

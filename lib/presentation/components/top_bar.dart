import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final bool showSearch;
  final bool showFilters;
  // Nuevas propiedades para controlar la visibilidad de Notificación y Carrito
  final bool showNotifications;
  final bool showCart;

  final VoidCallback? onSearchClick;
  final VoidCallback? onFilterClick;
  final VoidCallback? onNotificationClick;
  final VoidCallback? onCartClick;

  const TopBar({
    super.key,
    this.title = 'DoorMarket',
    this.showSearch = true,
    this.showFilters = false,
    // Asignamos 'true' por defecto a las nuevas propiedades
    this.showNotifications = true,
    this.showCart = true,
    this.onSearchClick,
    this.onFilterClick,
    this.onNotificationClick,
    this.onCartClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Fila 1: Logo + Título
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo_doormarket.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 28,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xFFE53935,
                      ), // Color primary, ajusta según tu colors.xml
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Fila 2: SearchBar + Todos + Iconos
              Row(
                children: [
                  // Barra de búsqueda
                  if (showSearch)
                    Expanded(
                      flex: 12,
                      child: GestureDetector(
                        onTap: onSearchClick,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFCCCCCC),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color(0xFFE53935), // Color primary
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Search',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (showSearch) const SizedBox(width: 12),

                  // Iconos de la derecha
                  Row(
                    children: [
                      // Texto "Todos" + Filtros
                      if (showFilters)
                        GestureDetector(
                          onTap: onFilterClick,
                          child: Row(
                            children: [
                              const Text(
                                'Todos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE53935), // Color primary
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.filter_list,
                                color: Color(0xFFE53935), // Color primary
                                size: 24,
                              ),
                            ],
                          ),
                        ),

                      if (showFilters) const SizedBox(width: 4),

                      // Notificaciones (ahora condicional)
                      if (showNotifications)
                        IconButton(
                          onPressed: onNotificationClick,
                          icon: const Icon(
                            Icons.notifications,
                            color: Color(0xFFE53935), // Color primary
                            size: 26,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),

                      // Carrito (ahora condicional)
                      if (showCart)
                        IconButton(
                          onPressed: onCartClick,
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Color(0xFFE53935), // Color primary
                            size: 26,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

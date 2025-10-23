import 'package:door_market_app/presentation/components/menu_footer.dart';
import 'package:door_market_app/presentation/screens/place_order/place_order.dart';
import 'package:door_market_app/presentation/screens/place_order/select_location_screen.dart';
import 'package:door_market_app/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final appRouter = GoRouter(
  initialLocation: '/place-order', // 👈 Cambia esto temporalmente para probar
  routes: [
    // 👇 RUTA INDEPENDIENTE - Sin menú inferior
    GoRoute(
      path: '/place-order',
      name: PlaceOrder.name,
      builder: (context, state) => const PlaceOrder(),
    ),
    GoRoute(
      path: '/select-location',
      name: SelectLocationScreen.name,
      builder: (context, state) {
        final LatLng? initialLocation = state.extra as LatLng?;
        return SelectLocationScreen(initialLocation: initialLocation);
      },
    ),

    // 👇 RUTAS CON MENÚ INFERIOR
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: HomeScreen.name,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              name: CategoriesScreen.name,
              builder: (context, state) => const CategoriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/promotions',
              name: PromotionsScreen.name,
              builder: (context, state) => const PromotionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              name: OrdersScreen.name,
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: ProfileScreen.name,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(ScaffoldWithNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _pageController.animateToPage(
        widget.navigationShell.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          HomeScreen(),
          CategoriesScreen(),
          PromotionsScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MenuFooter(navigationShell: widget.navigationShell),
    );
  }
}

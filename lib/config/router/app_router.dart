import 'package:door_market_app/presentation/components/menu_footer.dart';
import 'package:door_market_app/data/model/product.dart';
import 'package:door_market_app/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:door_market_app/presentation/screens/products_detail/product_detail_screen.dart';
import 'package:door_market_app/presentation/screens/cart/cart_screen.dart';
import 'package:door_market_app/presentation/screens/checkout/checkout_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
              routes: [
                GoRoute(
                  path: 'product-detail',
                  name: 'product-detail-home',
                  builder: (context, state) {
                    final product = state.extra as Product;
                    return ProductDetailScreen(product: product);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              name: CategoriesScreen.name,
              builder: (context, state) => const CategoriesScreen(),
              routes: [
                GoRoute(
                  path: 'product-detail',
                  name: 'product-detail-categories',
                  builder: (context, state) {
                    final product = state.extra as Product;
                    return ProductDetailScreen(product: product);
                  },
                ),
              ],
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
    GoRoute(
      path: '/cart',
      name: CartScreen.name,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: CheckoutScreen.name,
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // Acceso directo a la propiedad
      bottomNavigationBar: MenuFooter(
        navigationShell: navigationShell,
      ), // Acceso directo a la propiedad
    );
  }
}

import 'package:door_market_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: CategoriesScreen.name,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: OrdersScreen.name,
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/promotions',
      name: PromotionsScreen.name,
      builder: (context, state) => const PromotionsScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: ProfileScreen.name,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

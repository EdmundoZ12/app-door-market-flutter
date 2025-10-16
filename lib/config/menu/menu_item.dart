import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String route;
  final IconData? icon;
  const MenuItem({required this.title, required this.route, this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(title: 'Home', route: '/', icon: Icons.home_outlined),
  MenuItem(
    title: 'Categories',
    route: '/categories',
    icon: Icons.category_outlined,
  ),
  MenuItem(
    title: 'Promotions',
    route: '/promotions',
    icon: Icons.local_offer_outlined,
  ),
  MenuItem(
    title: 'Orders',
    route: '/orders',
    icon: Icons.shopping_bag_outlined,
  ),
  MenuItem(title: 'Profile', route: '/profile', icon: Icons.person_outline),
];

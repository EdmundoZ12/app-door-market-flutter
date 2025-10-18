import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:door_market_app/config/menu/menu_item.dart';

class MenuFooter extends StatelessWidget {
  const MenuFooter({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFD41307);
    const inactiveColor = Colors.black;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: activeColor.withOpacity(0.05),
          highlightColor: activeColor.withOpacity(0.005),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          items: appMenuItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}

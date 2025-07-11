import 'package:flutter/material.dart';

class MobileBottomNav extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabSelected;

  const MobileBottomNav({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: onTabSelected,
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded, size: 24),
              activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
              label: 'Legal Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_rounded, size: 24),
              activeIcon: Icon(Icons.description_rounded, size: 28),
              label: 'Letters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 24),
              activeIcon: Icon(Icons.description, size: 28),
              label: 'Documents',
            ),
          ],
        ),
      ),
    );
  }
}

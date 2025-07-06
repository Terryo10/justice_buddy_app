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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1F2E),
        border: Border(top: BorderSide(color: Color(0xFF2A2F3E), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: onTabSelected,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: const Color(0xFF8A8D93),
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
            icon: Icon(Icons.work_outline_rounded, size: 24),
            activeIcon: Icon(Icons.work_rounded, size: 28),
            label: 'Labor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.traffic_rounded, size: 24),
            activeIcon: Icon(Icons.traffic_rounded, size: 28),
            label: 'Traffic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 24),
            activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
            label: 'Ask Legal',
          ),
        ],
      ),
    );
  }
}


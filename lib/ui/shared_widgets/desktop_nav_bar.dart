import 'package:flutter/material.dart';

class DesktopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedTab;
  final List<String> tabs;
  final Function(int) onTabSelected;

  const DesktopNavBar({
    super.key,
    required this.selectedTab,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0E1A),
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Image.asset('assets/logo_1.png', height: 48, width: 48),
          const SizedBox(width: 20),
          const Text(
            'Justice Buddy SA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        for (int i = 0; i < tabs.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient:
                    selectedTab == i
                        ? const LinearGradient(
                          colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
                        )
                        : null,
              ),
              child: TextButton(
                onPressed: () => onTabSelected(i),
                style: TextButton.styleFrom(
                  foregroundColor:
                      selectedTab == i
                          ? const Color(0xFF0A0E1A)
                          : Colors.white70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontWeight:
                        selectedTab == i ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}


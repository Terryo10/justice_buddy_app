import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/theme_bloc/theme_bloc.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/logo_1.png', height: 40, width: 40),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'Justice Buddy SA',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              for (int i = 0; i < tabs.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient:
                          selectedTab == i
                              ? LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.8),
                                ],
                              )
                              : null,
                    ),
                    child: TextButton(
                      onPressed: () => onTabSelected(i),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            selectedTab == i
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        tabs[i],
                        style: TextStyle(
                          fontWeight:
                              selectedTab == i
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 20),
              // Theme Toggle Button
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      context.read<ThemeBloc>().toggleTheme();
                    },
                    icon: Icon(
                      state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    tooltip:
                        state.isDarkMode
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceVariant
                          .withOpacity(0.3),
                      padding: const EdgeInsets.all(12),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

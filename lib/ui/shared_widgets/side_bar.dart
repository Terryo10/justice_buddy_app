import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/theme_bloc/theme_bloc.dart';
import '../../routes/app_router.dart';
import '../../constants/app_theme.dart';

class SideBar extends StatelessWidget {
  final VoidCallback? onClose;

  const SideBar({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, theme),

            // Navigation Menu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      context,
                      title: 'Navigate',
                      children: [
                        _buildNavItem(
                          context: context,
                          icon: Icons.home_rounded,
                          title: 'Home',
                          onTap:
                              () => _navigateToPage(context, const HomeRoute()),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'Legal Chat',
                          onTap:
                              () => _navigateToPage(context, const ChatRoute()),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.description_outlined,
                          title: 'Get Documents',
                          onTap:
                              () => _navigateToPage(
                                context,
                                const GetDocumentsRoute(),
                              ),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.description_rounded,
                          title: 'Letter Generator',
                          onTap:
                              () => _navigateToPage(
                                context,
                                const LetterTemplatesRoute(),
                              ),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.people_outline,
                          title: 'Find Lawyers',
                          onTap:
                              () => _navigateToPage(
                                context,
                                const LawyersRoute(),
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSection(
                      context,
                      title: 'Settings',
                      children: [
                        _buildNavItem(
                          context: context,
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () {
                            _showComingSoonSnackBar(context, 'Settings');
                          },
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          onTap: () {
                            _showComingSoonSnackBar(context, 'Help & Support');
                          },
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.info_outline_rounded,
                          title: 'About',
                          onTap: () {
                            _showComingSoonSnackBar(context, 'About');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Theme Toggle at Bottom
            _buildThemeToggle(context, theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.balance, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Justice Buddy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                  iconSize: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your Legal Companion',
            style: TextStyle(
              color: Colors.white.withAlpha((0.9 * 255).round()),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color:
                    theme.textTheme.bodySmall?.color?.withAlpha(
                      (0.7 * 255).round(),
                    ) ??
                    theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  isSelected
                      ? AppTheme.primaryBlue.withAlpha((0.1 * 255).round())
                      : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color:
                      isSelected ? AppTheme.primaryBlue : theme.iconTheme.color,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isSelected
                              ? AppTheme.primaryBlue
                              : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withAlpha((0.3 * 255).round()),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppTheme.primaryBlue,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  themeState.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch.adaptive(
                value: themeState.isDarkMode,
                onChanged: (value) {
                  context.read<ThemeBloc>().toggleTheme();
                },
                activeColor: AppTheme.primaryBlue,
                inactiveTrackColor: theme.dividerColor.withAlpha(
                  (0.3 * 255).round(),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, PageRouteInfo route) {
    // Close the drawer first
    Navigator.of(context).pop();

    // For routes that are part of the main tabs, use navigate
    if (route is HomeRoute ||
        route is ChatRoute ||
        route is LetterTemplatesRoute ||
        route is GetDocumentsRoute) {
      context.router.navigate(route);
    } else {
      // For other routes (like lawyers), push them as separate pages
      context.router.push(route);
    }
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    Navigator.of(context).pop(); // Close the drawer first

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

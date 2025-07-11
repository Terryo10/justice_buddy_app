import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category_bloc/category_bloc.dart';
import '../../blocs/law_info_item_bloc/law_info_item_bloc.dart';
import '../../constants/app_urls.dart';
import '../../models/category_model.dart' as cat;
import '../../models/law_info_item_model.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _searchController = TextEditingController();

    // Load data
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<LawInfoItemBloc>().add(const LoadLawInfoItems());

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(cat.CategoryModel category) {
    context.read<LawInfoItemBloc>().add(
      LoadLawInfoItemsByCategory(category: category),
    );
  }

  void _onClearCategory() {
    context.read<CategoryBloc>().add(ClearCategorySelection());
    context.read<LawInfoItemBloc>().add(const LoadLawInfoItems());
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<LawInfoItemBloc>().add(SearchLawInfoItems(query: query));
    } else {
      context.read<LawInfoItemBloc>().add(const LoadLawInfoItems());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            // Hero Section
            SliverToBoxAdapter(child: _buildHeroSection(isWide)),

            // Search Section
            SliverToBoxAdapter(child: _buildSearchSection(isWide)),

            // Categories Section
            SliverToBoxAdapter(child: _buildCategoriesSection(isWide)),

            // Content Section
            _buildHomeContent(isWide),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isWide) {
    final heroHeight = isWide ? 280.0 : 200.0;
    // final heroRadius = isWide ? 40.0 : 24.0;
    final logoSize = isWide ? 80.0 : 64.0;
    final theme = Theme.of(context);

    final heroContainer = Container(
      width: double.infinity,
      height: heroHeight,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha((0.18 * 255).round()),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background image
          Positioned.fill(
            child: ClipRRect(
              child: Image.asset('assets/legal happy.jpeg', fit: BoxFit.cover),
            ),
          ),
          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((0.7 * 255).round()),
                  ],
                ),
              ),
            ),
          ),
          // Logo and text positioned at bottom
          Positioned(
            left: isWide ? 60 : 24,
            right: isWide ? 60 : 24,
            bottom: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo with white background
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withAlpha(
                          (0.12 * 255).round(),
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo_1.png',
                      height: logoSize,
                      width: logoSize,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Justice Buddy SA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your mobile legal partner. Know your rights. Access legal help. Stay protected.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          heroContainer,
          // Subtle divider
          Container(
            width: double.infinity,
            height: 1,
            color: theme.dividerColor,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchSection(bool isWide) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha((0.2 * 255).round()),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search legal information...',
            hintStyle: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(bool isWide) {
    final theme = Theme.of(context);

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }

        if (state is CategoryLoaded) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 60 : 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // All Categories Chip
                      _buildCategoryChip(
                        'All Categories',
                        state.selectedCategory == null,
                        () => _onClearCategory(),
                      ),
                      const SizedBox(width: 12),
                      // Category Chips
                      ...state.categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildCategoryChip(
                            category.name,
                            state.selectedCategory?.id == category.id,
                            () {
                              context.read<CategoryBloc>().add(
                                SelectCategory(category),
                              );
                              _onCategorySelected(category);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state is CategoryError) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories: ${state.message}',
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(LoadCategories());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withAlpha(
                          (0.8 * 255).round(),
                        ),
                      ],
                    )
                    : null,
            color: isSelected ? null : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : theme.dividerColor,
              width: 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(
                          (0.3 * 255).round(),
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(bool isWide) {
    final theme = Theme.of(context);

    return BlocBuilder<LawInfoItemBloc, LawInfoItemState>(
      builder: (context, state) {
        if (state is LawInfoItemLoading) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          );
        }

        if (state is LawInfoItemLoaded) {
          return SliverPadding(
            padding: EdgeInsets.all(isWide ? 32 : 12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 8 : 2,
                mainAxisSpacing: isWide ? 16 : 10,
                crossAxisSpacing: isWide ? 16 : 10,
                childAspectRatio: isWide ? 0.75 : 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = state.lawInfoItems[index];
                return _buildModernCard(item, compact: true);
              }, childCount: state.lawInfoItems.length),
            ),
          );
        }

        if (state is LawInfoItemError) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LawInfoItemBloc>().add(
                          const LoadLawInfoItems(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildModernCard(LawInfoItemModel item, {bool compact = false}) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(compact ? 16 : 24),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha((0.15 * 255).round()),
            blurRadius: compact ? 10 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 16 : 24),
          onTap: () {
            // Navigate to detail page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${item.name}'),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(compact ? 16 : 24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withAlpha(
                          (0.08 * 255).round(),
                        ),
                        theme.colorScheme.secondary.withAlpha(
                          (0.08 * 255).round(),
                        ),
                      ],
                    ),
                  ),
                  child:
                      item.image != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(compact ? 16 : 24),
                            ),
                            child: Image.network(
                              AppUrls.imageUrl(item.image!),
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary.withAlpha(
                                          (0.08 * 255).round(),
                                        ),
                                        theme.colorScheme.secondary.withAlpha(
                                          (0.08 * 255).round(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback for when images fail to load (like on web due to CORS)
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary.withAlpha(
                                          (0.1 * 255).round(),
                                        ),
                                        theme.colorScheme.secondary.withAlpha(
                                          (0.1 * 255).round(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.account_balance,
                                          size: compact ? 32 : 48,
                                          color: theme.colorScheme.primary
                                              .withAlpha((0.6 * 255).round()),
                                        ),
                                        if (!compact) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Legal',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(
                                                        (0.6 * 255).round(),
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          : Center(
                            child: Icon(
                              Icons.gavel_rounded,
                              size: compact ? 28 : 40,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                ),
              ),

              // Content Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(compact ? 10 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: compact ? 13 : 16,
                          color: theme.textTheme.titleMedium?.color,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          item.description,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: compact ? 10 : 12,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.category != null) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 6 : 8,
                            vertical: compact ? 2 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(
                              (0.08 * 255).round(),
                            ),
                            borderRadius: BorderRadius.circular(
                              compact ? 6 : 8,
                            ),
                            border: Border.all(
                              color: theme.colorScheme.primary.withAlpha(
                                (0.2 * 255).round(),
                              ),
                            ),
                          ),
                          child: Text(
                            item.category!.name,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: compact ? 8 : 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

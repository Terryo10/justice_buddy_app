import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category_bloc/category_bloc.dart';
import '../../blocs/law_info_item_bloc/law_info_item_bloc.dart';
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
    return Container(
      padding: EdgeInsets.all(isWide ? 60 : 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Text content
          Expanded(
            flex: isWide ? 1 : 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo_1.png', height: 64, width: 64),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        'Justice Buddy SA',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your mobile legal partner. Know your rights. Access legal help. Stay protected.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB0B3B8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          if (isWide) ...[
            const SizedBox(width: 60),
            // Right side - Image
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/legal happy.jpeg', fit: BoxFit.contain),
                  // Overlay gradient circle
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFFC107).withOpacity(0.7),
                            const Color(0xFFFFB300).withOpacity(0.7),
                            const Color(0xFFF57C00).withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchSection(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2F3E), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search legal information...',
            hintStyle: const TextStyle(color: Color(0xFF8A8D93), fontSize: 16),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFFFC107),
              size: 24,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Color(0xFF8A8D93),
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
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)),
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
                const Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories: ${state.message}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(LoadCategories());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      foregroundColor: const Color(0xFF0A0E1A),
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
                    ? const LinearGradient(
                      colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
                    )
                    : null,
            color: isSelected ? null : const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFF2A2F3E),
              width: 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: const Color(0xFFFFC107).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0A0E1A) : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(bool isWide) {
    return BlocBuilder<LawInfoItemBloc, LawInfoItemState>(
      builder: (context, state) {
        if (state is LawInfoItemLoading) {
          return SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFC107)),
              ),
            ),
          );
        }

        if (state is LawInfoItemLoaded) {
          return SliverPadding(
            padding: EdgeInsets.all(isWide ? 60 : 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: isWide ? 0.85 : 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = state.lawInfoItems[index];
                return _buildModernCard(item);
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
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: const Color(0xFF0A0E1A),
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

  Widget _buildModernCard(LawInfoItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2F3E), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Navigate to detail page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${item.name}'),
                backgroundColor: const Color(0xFFFFC107),
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFC107).withOpacity(0.1),
                        const Color(0xFF1976D2).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child:
                      item.image != null
                          ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Image.network(
                              item.image!,
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
                                        const Color(
                                          0xFFFFC107,
                                        ).withOpacity(0.1),
                                        const Color(
                                          0xFF1976D2,
                                        ).withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFFC107),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFFFFC107,
                                        ).withOpacity(0.1),
                                        const Color(
                                          0xFF1976D2,
                                        ).withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.gavel_rounded,
                                      size: 40,
                                      color: Color(0xFFFFC107),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          : const Center(
                            child: Icon(
                              Icons.gavel_rounded,
                              size: 40,
                              color: Color(0xFFFFC107),
                            ),
                          ),
                ),
              ),

              // Content Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            color: Color(0xFFB0B3B8),
                            fontSize: 12,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.category != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFFC107).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            item.category!.name,
                            style: const TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 10,
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

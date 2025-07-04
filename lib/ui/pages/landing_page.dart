import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routes/app_router.dart';
import '../../blocs/category_bloc/category_bloc.dart';
import '../../blocs/law_info_item_bloc/law_info_item_bloc.dart';
import '../../models/category_model.dart' as cat;
import '../../models/law_info_item_model.dart';

@RoutePage()
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final TextEditingController _searchController;

  final List<String> _tabs = ['Justice Buddy', 'Labor', 'Traffic', 'Ask Legal'];

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

  void _onTabSelected(int index) async {
    if (_selectedTab == index) return;
    await _fadeController.reverse();
    setState(() => _selectedTab = index);

    // Navigate to different routes based on tab
    if (index == 1 && context.router.current.name != LaborRoute.name) {
      context.router.replace(const LaborRoute());
    } else if (index == 2 && context.router.current.name != TrafficRoute.name) {
      context.router.replace(const TrafficRoute());
    } else if (index == 3 &&
        context.router.current.name != AskLegalRoute.name) {
      context.router.replace(const AskLegalRoute());
    }

    _fadeController.forward();
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

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: isWide ? _buildDesktopAppBar() : null,
      bottomNavigationBar: !isWide ? _buildMobileBottomNav() : null,
      body: FadeTransition(
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
              _buildContentSection(isWide),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDesktopAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0A0E1A),
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC107).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance,
              color: Color(0xFF0A0E1A),
              size: 32,
            ),
          ),
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
        for (int i = 0; i < _tabs.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient:
                    _selectedTab == i
                        ? const LinearGradient(
                          colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
                        )
                        : null,
              ),
              child: TextButton(
                onPressed: () => _onTabSelected(i),
                style: TextButton.styleFrom(
                  foregroundColor:
                      _selectedTab == i
                          ? const Color(0xFF0A0E1A)
                          : Colors.white70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    fontWeight:
                        _selectedTab == i ? FontWeight.bold : FontWeight.w500,
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

  Widget _buildMobileBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1F2E),
        border: Border(top: BorderSide(color: Color(0xFF2A2F3E), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onTabSelected,
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

  Widget _buildHeroSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 60 : 24),
      child: Column(
        children: [
          if (!isWide) ...[
            // Golden Arc with Hand
            Container(
              height: 160,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Golden Arc
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFC107),
                          Color(0xFFFFB300),
                          Color(0xFFF57C00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFC107).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                  // Hand holding effect
                  Positioned(
                    bottom: 20,
                    child: Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Logo and Title Section
          Row(
            mainAxisAlignment:
                isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFF1976D2),
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isWide
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Justice Buddy SA',
                      style: TextStyle(
                        fontSize: isWide ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your mobile legal partner. Know your rights. Access legal help. Stay protected.',
                      style: TextStyle(
                        fontSize: isWide ? 18 : 16,
                        color: const Color(0xFFB0B3B8),
                        height: 1.4,
                      ),
                      textAlign: isWide ? TextAlign.center : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildContentSection(bool isWide) {
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
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            color: Color(0xFFB0B3B8),
                            fontSize: 12,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.category != null) ...[
                        const SizedBox(height: 8),
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

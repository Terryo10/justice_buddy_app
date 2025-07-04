import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

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
  late final Animation<double> _fadeAnimation;

  final List<String> _tabs = ['Justice Buddy', 'Labor', 'Traffic', 'Ask Legal'];

  final List<PageRouteInfo> _tabRoutes = [
    const LandingRoute(),
    const LaborRoute(),
    const TrafficRoute(),
    const AskLegalRoute(),
  ];

  final List<_FeatureCardData> _features = [
    _FeatureCardData(
      title: 'Eviction Notice Help',
      subtitle:
          'Get assistance with understanding eviction notices and your rights as a tenant',
      image:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Unlawful Eviction Protection',
      subtitle:
          'Learn about protection against illegal evictions and emergency court orders',
      image:
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Tenant Rights Guide',
      subtitle:
          'Comprehensive guide to your rights as a tenant in South Africa',
      image:
          'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Landlord Dispute Resolution',
      subtitle:
          'Assistance with resolving disputes with landlords through proper channels',
      image:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Unfair Dismissal Claims',
      subtitle: 'Help with claiming unfair dismissal and workplace rights',
      image:
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Workplace Harassment',
      subtitle:
          'Support for dealing with workplace harassment and discrimination',
      image:
          'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'Unpaid Wages Claims',
      subtitle: 'Assistance with claiming unpaid wages and labor rights',
      image:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
    ),
    _FeatureCardData(
      title: 'CCMA Referral Process',
      subtitle: 'Guide to refer labor disputes to the CCMA',
      image:
          'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) async {
    if (_selectedTab == index) return;
    await _fadeController.reverse();
    setState(() => _selectedTab = index);
    if (index == 0 && context.router.current.name != LandingRoute.name) {
      context.router.replace(const LandingRoute());
    } else if (index == 1 && context.router.current.name != LaborRoute.name) {
      context.router.replace(const LaborRoute());
    } else if (index == 2 && context.router.current.name != TrafficRoute.name) {
      context.router.replace(const TrafficRoute());
    } else if (index == 3 &&
        context.router.current.name != AskLegalRoute.name) {
      context.router.replace(const AskLegalRoute());
    }
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          isWide
              ? AppBar(
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF1976D2),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Justice Buddy SA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  for (int i = 0; i < _tabs.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () => _onTabSelected(i),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _selectedTab == i
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          _tabs[i],
                          style: TextStyle(
                            fontWeight:
                                _selectedTab == i
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
                backgroundColor: const Color(0xFF1976D2),
                elevation: 0,
              )
              : null,
      bottomNavigationBar:
          !isWide
              ? BottomNavigationBar(
                currentIndex: _selectedTab,
                onTap: _onTabSelected,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                selectedItemColor: const Color(0xFF1976D2),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                elevation: 8,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_rounded),
                    label: 'Justice Buddy',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work_outline),
                    label: 'Labor',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.traffic),
                    label: 'Traffic',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.question_answer),
                    label: 'Ask Legal',
                  ),
                ],
              )
              : null,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.3, 1.0],
              colors: [
                const Color(0xFF1976D2).withOpacity(0.1),
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isWide ? 48 : 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1976D2).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    if (!isWide) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Justice Buddy SA',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your mobile legal partner. Know your rights. Access legal help. Stay protected.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 32),
                      const Text(
                        'Your mobile legal partner. Know your rights. Access legal help. Stay protected.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              // Cards Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isWide ? 48 : 16),
                  child: isWide ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(
          data: _features[index],
          heroTag: _features[index].title,
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(
          data: _features[index],
          heroTag: _features[index].title,
        );
      },
    );
  }
}

class _FeatureCardData {
  final String title;
  final String subtitle;
  final String image;
  const _FeatureCardData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureCardData data;
  final String heroTag;
  const _FeatureCard({required this.data, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isDark ? const Color(0xFF23262F) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder:
                  (context, animation, secondaryAnimation) => FadeTransition(
                    opacity: animation,
                    child: _FeatureDetailPage(data: data, heroTag: heroTag),
                  ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        data.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        data.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureDetailPage extends StatelessWidget {
  final _FeatureCardData data;
  final String heroTag;
  const _FeatureDetailPage({required this.data, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: heroTag,
            child: Image.network(
              data.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/law_info_item_bloc/law_info_item_bloc.dart';
import '../../models/law_info_item_model.dart';
import '../shared_widgets/desktop_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../constants/app_urls.dart';

@RoutePage()
class LawInfoItemDetailPage extends StatefulWidget {
  final String slug;

  const LawInfoItemDetailPage({
    super.key,
    @PathParam('slug') required this.slug,
  });

  @override
  State<LawInfoItemDetailPage> createState() => _LawInfoItemDetailPageState();
}

class _LawInfoItemDetailPageState extends State<LawInfoItemDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load law info item details by slug
    context.read<LawInfoItemBloc>().add(LoadLawInfoItemDetails(widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar:
          isWide
              ? DesktopNavBar(
                selectedTab: -1, // -1 indicates no main tab is selected
                tabs: const [
                  'Home',
                  'Ask Legal AI',
                  'Legal Drafter',
                  'Get Documents',
                ],
                onTabSelected: (index) {
                  // Navigate to main app tabs
                  switch (index) {
                    case 0:
                      context.router.navigate(const HomeRoute());
                      break;
                    case 1:
                      context.router.navigate(const ChatRoute());
                      break;
                    case 2:
                      context.router.navigate(const LetterTemplatesRoute());
                      break;
                    case 3:
                      context.router.navigate(const GetDocumentsRoute());
                      break;
                  }
                },
              )
              : null,
      body: BlocBuilder<LawInfoItemBloc, LawInfoItemState>(
        builder: (context, state) {
          if (state is LawInfoItemLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          } else if (state is LawInfoItemLoaded &&
              state.selectedLawInfoItem != null) {
            return _buildLawInfoItemDetails(state.selectedLawInfoItem!);
          } else if (state is LawInfoItemError) {
            return _buildErrorState(state.message);
          }
          return _buildErrorState('Law info item not found');
        },
      ),
    );
  }

  Widget _buildLawInfoItemDetails(LawInfoItemModel lawInfoItem) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;

    return CustomScrollView(
      slivers: [
        // App Bar with Law Info Item Header
        SliverAppBar(
          expandedHeight: isWide ? 350 : 300,
          pinned: true,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.appBarTheme.foregroundColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Law Info Item Image
                          Container(
                            width: isWide ? 120 : 100,
                            height: isWide ? 120 : 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: theme.cardTheme.color?.withValues(
                                alpha: 0.2,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child:
                                lawInfoItem.image != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        AppUrls.imageUrl(lawInfoItem.image!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return _buildDefaultIcon();
                                        },
                                      ),
                                    )
                                    : _buildDefaultIcon(),
                          ),
                          const SizedBox(width: 20),
                          // Law Info Item Basic Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lawInfoItem.name,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: isWide ? 28 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                if (lawInfoItem.category != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      lawInfoItem.category!.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Text(
                                  lawInfoItem.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 16,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content Section
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(isWide ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description Section
                _buildSection(
                  title: 'Overview',
                  content: lawInfoItem.description,
                  icon: Icons.info_outline,
                ),

                // More Description Section
                if (lawInfoItem.moreDescription != null &&
                    lawInfoItem.moreDescription!.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Detailed Information',
                    content: lawInfoItem.moreDescription!,
                    icon: Icons.description_outlined,
                  ),
                ],

                // Category Section
                if (lawInfoItem.category != null) ...[
                  const SizedBox(height: 32),
                  _buildCategorySection(lawInfoItem.category!),
                ],

                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: const Icon(Icons.gavel, size: 48, color: Colors.white),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor, width: 1),
          ),
          child: Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.6,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(dynamic category) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Category',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (category.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.router.navigate(const ChatRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.chat_outlined),
            label: const Text(
              'Ask Legal AI',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.router.navigate(const LetterTemplatesRoute());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit_document),
            label: const Text(
              'Generate Letters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.router.navigate(const HomeRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Go Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}

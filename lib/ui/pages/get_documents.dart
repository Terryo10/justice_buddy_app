import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class GetDocuments extends StatelessWidget {
  const GetDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          'Traffic Law Information',
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 60 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Traffic Law Information',
              style: TextStyle(
                fontSize: isWide ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineSmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Stay informed about traffic laws, driving regulations, and what to do in case of traffic violations.',
              style: TextStyle(
                fontSize: isWide ? 18 : 16,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 32),
            _buildFeatureGrid(context, isWide, [
              {
                'icon': Icons.credit_card,
                'title': 'Licensing',
                'description':
                    'Driver\'s license requirements and renewal procedures',
              },
              {
                'icon': Icons.speed,
                'title': 'Speed Limits',
                'description': 'Speed limits and traffic regulations',
              },
              {
                'icon': Icons.local_police,
                'title': 'Traffic Violations',
                'description': 'Common traffic violations and penalties',
              },
              {
                'icon': Icons.car_crash,
                'title': 'Accidents',
                'description': 'What to do in case of a traffic accident',
              },
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(
    BuildContext context,
    bool isWide,
    List<Map<String, dynamic>> features,
  ) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 2 : 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: isWide ? 2.5 : 2.0,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TrafficPage extends StatelessWidget {
  const TrafficPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        foregroundColor: Colors.white,
        title: const Text(
          'Traffic Law Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Stay informed about traffic laws, driving regulations, and what to do in case of traffic violations.',
              style: TextStyle(
                fontSize: isWide ? 18 : 16,
                color: const Color(0xFFB0B3B8),
              ),
            ),
            const SizedBox(height: 32),
            _buildFeatureGrid(isWide, [
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

  Widget _buildFeatureGrid(bool isWide, List<Map<String, dynamic>> features) {
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
            color: const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A2F3E), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFFFFC107),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      style: const TextStyle(
                        color: Color(0xFFB0B3B8),
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

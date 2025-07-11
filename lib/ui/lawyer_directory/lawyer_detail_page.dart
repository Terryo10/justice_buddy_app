import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/lawyer_bloc/lawyer_bloc.dart';
import '../../models/lawyer_model.dart';
import '../shared_widgets/desktop_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../constants/app_urls.dart';

@RoutePage()
class LawyerDetailPage extends StatefulWidget {
  final String slug;

  const LawyerDetailPage({super.key, @PathParam('slug') required this.slug});

  @override
  State<LawyerDetailPage> createState() => _LawyerDetailPageState();
}

class _LawyerDetailPageState extends State<LawyerDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load lawyer details by slug
    context.read<LawyerBloc>().add(LoadLawyerBySlug(widget.slug));
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
      body: BlocBuilder<LawyerBloc, LawyerState>(
        builder: (context, state) {
          if (state is LawyerLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          } else if (state is LawyerDetailsLoaded) {
            return _buildLawyerDetails(state.lawyer);
          } else if (state is LawyerError) {
            return _buildErrorState(state.message);
          }
          return _buildErrorState('Lawyer not found');
        },
      ),
    );
  }

  Widget _buildLawyerDetails(LawyerModel lawyer) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;

    return CustomScrollView(
      slivers: [
        // App Bar with Lawyer Info
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
                          // Profile Image
                          CircleAvatar(
                            radius: isWide ? 60 : 50,
                            backgroundImage:
                                lawyer.profileImage != null
                                    ? NetworkImage(
                                      AppUrls.imageUrl(lawyer.profileImage!),
                                    )
                                    : null,
                            backgroundColor: theme.cardTheme.color?.withValues(
                              alpha: 0.2,
                            ),
                            child:
                                lawyer.profileImage == null
                                    ? Text(
                                      lawyer.firstName[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 20),
                          // Lawyer Basic Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lawyer.fullName,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: isWide ? 28 : 24,
                                      ),
                                ),
                                if (lawyer.firmName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    lawyer.firmName!,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                if (lawyer.rating != null)
                                  Row(
                                    children: [
                                      ...List.generate(5, (index) {
                                        return Icon(
                                          index < lawyer.rating!.floor()
                                              ? Icons.star
                                              : index < lawyer.rating!
                                              ? Icons.star_half
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${lawyer.rating!.toStringAsFixed(1)} (${lawyer.reviewCount} reviews)',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Status Badge
                      Row(
                        children: [
                          if (lawyer.acceptsNewClients)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Accepting New Clients',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (lawyer.verifiedAt != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(isWide ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Actions
                _buildQuickActions(lawyer),
                const SizedBox(height: 24),

                // About Section
                if (lawyer.bio != null) ...[
                  _buildSectionHeader('About'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        lawyer.bio!,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Specializations
                if (lawyer.specializations.isNotEmpty) ...[
                  _buildSectionHeader('Areas of Practice'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            lawyer.specializations.map((specialization) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  specialization,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Professional Details
                _buildSectionHeader('Professional Details'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (lawyer.licenseNumber?.isNotEmpty == true)
                          _buildDetailRow(
                            'License Number',
                            lawyer.licenseNumber!,
                          ),
                        if (lawyer.lawSociety != null)
                          _buildDetailRow('Law Society', lawyer.lawSociety!),
                        if (lawyer.admissionDate != null)
                          _buildDetailRow(
                            'Admission Date',
                            _formatDate(lawyer.admissionDate!),
                          ),
                        if (lawyer.yearsExperience != null)
                          _buildDetailRow(
                            'Years of Experience',
                            '${lawyer.yearsExperience} years',
                          ),
                        if (lawyer.courtsAdmitted.isNotEmpty)
                          _buildDetailRow(
                            'Courts Admitted',
                            lawyer.courtsAdmitted.join(', '),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Information
                _buildSectionHeader('Contact Information'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildContactRow(
                          Icons.email,
                          lawyer.email,
                          () => _launchEmail(lawyer.email),
                        ),
                        if (lawyer.phone != null)
                          _buildContactRow(
                            Icons.phone,
                            lawyer.phone!,
                            () => _launchPhone(lawyer.phone!),
                          ),
                        if (lawyer.mobile != null)
                          _buildContactRow(
                            Icons.smartphone,
                            lawyer.mobile!,
                            () => _launchPhone(lawyer.mobile!),
                          ),
                        if (lawyer.fax != null)
                          _buildDetailRow('Fax', lawyer.fax!),
                        if (lawyer.website != null)
                          _buildContactRow(
                            Icons.web,
                            lawyer.website!,
                            () => _launchWebsite(lawyer.website!),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Office Location
                if (lawyer.address != null) ...[
                  _buildSectionHeader('Office Location'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  lawyer.formattedAddress ?? lawyer.address!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          if (lawyer.latitude != null &&
                              lawyer.longitude != null) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed:
                                    () => _launchMaps(
                                      lawyer.latitude!,
                                      lawyer.longitude!,
                                    ),
                                icon: const Icon(Icons.directions),
                                label: const Text('Get Directions'),
                                style: theme.elevatedButtonTheme.style,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Languages
                if (lawyer.languages.isNotEmpty) ...[
                  _buildSectionHeader('Languages'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            lawyer.languages.map((language) {
                              return Chip(
                                label: Text(language),
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Consultation Information
                if (lawyer.consultationFee != null ||
                    lawyer.consultationMethods.isNotEmpty) ...[
                  _buildSectionHeader('Consultation'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (lawyer.consultationFee != null)
                            _buildDetailRow(
                              'Consultation Fee',
                              '\$${lawyer.consultationFee!.toStringAsFixed(2)}',
                            ),
                          if (lawyer.consultationMethods.isNotEmpty)
                            _buildDetailRow(
                              'Consultation Methods',
                              lawyer.consultationMethods.join(', '),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(LawyerModel lawyer) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                lawyer.phone != null ? () => _launchPhone(lawyer.phone!) : null,
            icon: const Icon(Icons.phone),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: theme.elevatedButtonTheme.style?.elevation?.resolve(
                {},
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: theme.elevatedButtonTheme.style?.shape?.resolve({}),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchEmail(lawyer.email),
            icon: const Icon(Icons.email),
            label: const Text('Email'),
            style: theme.elevatedButtonTheme.style?.copyWith(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value, VoidCallback onTap) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: theme.textTheme.bodyMedium?.color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Lawyer Details', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Error Loading Lawyer', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<LawyerBloc>().add(LoadLawyerBySlug(widget.slug));
              },
              style: theme.elevatedButtonTheme.style,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWebsite(String website) async {
    Uri uri;
    if (website.startsWith('http://') || website.startsWith('https://')) {
      uri = Uri.parse(website);
    } else {
      uri = Uri.parse('https://$website');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    final Uri uri = Uri.parse(
      'https://maps.google.com/?q=$latitude,$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

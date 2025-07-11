import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/lawyer_bloc/lawyer_bloc.dart';
import '../../models/lawyer_model.dart';
import '../shared_widgets/desktop_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../constants/app_urls.dart';

@RoutePage()
class LawyersPage extends StatefulWidget {
  const LawyersPage({super.key});

  @override
  State<LawyersPage> createState() => _LawyersPageState();
}

class _LawyersPageState extends State<LawyersPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSpecialization;
  String? _selectedCity;
  String? _selectedProvince;
  bool? _acceptingNewClients;

  // Available options for filters
  List<String> _availableSpecializations = [];
  List<String> _availableCities = [];
  List<String> _availableProvinces = [];

  // Current lawyers data
  List<LawyerModel> _currentLawyers = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load lawyers and filter options on page initialization
    context.read<LawyerBloc>().add(const LoadLawyers());
    context.read<LawyerBloc>().add(LoadSpecializations());
    context.read<LawyerBloc>().add(LoadLocations());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're returning to this page and need to refresh lawyers
    final currentState = context.read<LawyerBloc>().state;
    if (currentState is LawyerDetailsLoaded && _currentLawyers.isEmpty) {
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    context.read<LawyerBloc>().add(
      LoadLawyers(
        search:
            _searchController.text.isNotEmpty ? _searchController.text : null,
        specialization: _selectedSpecialization,
        city: _selectedCity,
        province: _selectedProvince,
        acceptingClients: _acceptingNewClients,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedSpecialization = null;
      _selectedCity = null;
      _selectedProvince = null;
      _acceptingNewClients = null;
    });
    context.read<LawyerBloc>().add(const LoadLawyers());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: isWide
          ? DesktopNavBar(
              selectedTab: -1, // -1 indicates no main tab is selected
              tabs: const ['Home', 'Ask Legal AI', 'Legal Drafter', 'Get Documents'],
              onTabSelected: (index) {
                // Navigate to main app tabs
                switch (index) {
                  case 0:
                    context.router.navigate(const HomeRoute());
                    break;
                  case 1:
                    context.router.navigate(const AskLegalRoute());
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
          : AppBar(
              title: Text('Find a Lawyer', style: theme.appBarTheme.titleTextStyle),
              backgroundColor: theme.appBarTheme.backgroundColor,
              foregroundColor: theme.appBarTheme.foregroundColor,
              elevation: 0,
            ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(isWide ? 24 : 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withAlpha((0.15 * 255).round()),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        'Search lawyers by name, firm, or specialization...',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(
                        (0.6 * 255).round(),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      onPressed: () => _showFilterSheet(context),
                    ),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                const SizedBox(height: 12),
                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _performSearch,
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.cardTheme.color,
                          foregroundColor: theme.colorScheme.primary,
                          elevation: 2,
                          shadowColor: theme.shadowColor.withAlpha(
                            (0.2 * 255).round(),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.cardTheme.color?.withAlpha(
                          (0.3 * 255).round(),
                        ),
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 1,
                        shadowColor: theme.shadowColor.withAlpha(
                          (0.1 * 255).round(),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results Section
          Expanded(
            child: BlocConsumer<LawyerBloc, LawyerState>(
              listener: (context, state) {
                // Update filter options when they're loaded
                if (state is SpecializationsLoaded) {
                  setState(() {
                    _availableSpecializations = state.specializations;
                  });
                } else if (state is LocationsLoaded) {
                  setState(() {
                    _availableCities = state.cities;
                    _availableProvinces = state.provinces;
                  });
                } else if (state is LawyerLoading) {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                } else if (state is LawyersLoaded) {
                  setState(() {
                    _currentLawyers = state.lawyers;
                    _isLoading = false;
                    _errorMessage = null;
                  });
                } else if (state is LawyerDetailsLoaded) {
                  // When returning from lawyer detail page, reload the lawyers list
                  // but don't show loading since we might have cached data
                  if (_currentLawyers.isEmpty) {
                    _loadInitialData();
                  } else {
                    setState(() {
                      _isLoading = false;
                      _errorMessage = null;
                    });
                  }
                } else if (state is LawyerError) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = state.message;
                  });
                }
              },
              builder: (context, state) {
                if (_isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  );
                } else if (_errorMessage != null) {
                  return _buildErrorState(_errorMessage!);
                } else if (_currentLawyers.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return _buildLawyersList(_currentLawyers);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLawyersList(List<LawyerModel> lawyers) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return ListView.builder(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      itemCount: lawyers.length,
      itemBuilder: (context, index) {
        final lawyer = lawyers[index];
        return _buildLawyerCard(lawyer);
      },
    );
  }

  Widget _buildLawyerCard(LawyerModel lawyer) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      shape: theme.cardTheme.shape,
      child: InkWell(
        onTap: () {
          // Navigate to lawyer detail page
          context.router.pushNamed('/lawyers/${lawyer.slug}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        lawyer.profileImage != null
                            ? NetworkImage(
                              AppUrls.imageUrl(lawyer.profileImage!),
                            )
                            : null,
                    backgroundColor: theme.colorScheme.primary.withAlpha(
                      (0.1 * 255).round(),
                    ),
                    child:
                        lawyer.profileImage == null
                            ? Text(
                              lawyer.firstName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 16),
                  // Lawyer Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lawyer.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        if (lawyer.firmName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            lawyer.firmName!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (lawyer.rating != null) ...[
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lawyer.rating!.toStringAsFixed(1)} (${lawyer.reviewCount})',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (lawyer.city != null) ...[
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${lawyer.city}${lawyer.province != null ? ', ${lawyer.province}' : ''}',
                                  style: theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Accepting Clients Badge
                  if (lawyer.acceptsNewClients)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Accepting Clients',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Specializations
              if (lawyer.specializations.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      lawyer.specializations.take(3).map((specialization) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(
                              (0.1 * 255).round(),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withAlpha(
                                (0.3 * 255).round(),
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
                if (lawyer.specializations.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '+${lawyer.specializations.length - 3} more specializations',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 12),
              // Contact Info
              Row(
                children: [
                  if (lawyer.phone != null) ...[
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(lawyer.phone!, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                  ],
                  if (lawyer.consultationFee != null) ...[
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Consultation: \$${lawyer.consultationFee!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: theme.textTheme.bodyMedium?.color?.withAlpha(
              (0.4 * 255).round(),
            ),
          ),
          const SizedBox(height: 16),
          Text('No lawyers found', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearFilters,
            style: theme.elevatedButtonTheme.style,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Error Loading Lawyers', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<LawyerBloc>().add(const LoadLawyers());
            },
            style: theme.elevatedButtonTheme.style,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.95,
            minChildSize: 0.3,
            builder:
                (context, scrollController) => StatefulBuilder(
                  builder:
                      (context, setModalState) => Container(
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Handle
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // Header
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Filter Lawyers',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                            // Filter Content
                            Expanded(
                              child: ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                children: [
                                  // Specialization Filter
                                  if (_availableSpecializations.isNotEmpty) ...[
                                    Text(
                                      'Specialization',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                          _availableSpecializations.map((spec) {
                                            return FilterChip(
                                              label: Text(spec),
                                              selected:
                                                  _selectedSpecialization ==
                                                  spec,
                                              onSelected: (selected) {
                                                setModalState(() {
                                                  _selectedSpecialization =
                                                      selected ? spec : null;
                                                });
                                                setState(() {
                                                  _selectedSpecialization =
                                                      selected ? spec : null;
                                                });
                                              },
                                              selectedColor: theme
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.2),
                                              checkmarkColor:
                                                  theme.colorScheme.primary,
                                              backgroundColor:
                                                  theme.colorScheme.surface,
                                            );
                                          }).toList(),
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  // Province Filter
                                  if (_availableProvinces.isNotEmpty) ...[
                                    Text(
                                      'Province',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: _selectedProvince,
                                      decoration: InputDecoration(
                                        hintText: 'Select Province',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                      items:
                                          _availableProvinces.map((province) {
                                            return DropdownMenuItem<String>(
                                              value: province,
                                              child: Text(province),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setModalState(() {
                                          _selectedProvince = value;
                                          // Clear city when province changes
                                          _selectedCity = null;
                                        });
                                        setState(() {
                                          _selectedProvince = value;
                                          // Clear city when province changes
                                          _selectedCity = null;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // City Filter
                                  if (_availableCities.isNotEmpty) ...[
                                    Text(
                                      'City',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: _selectedCity,
                                      decoration: InputDecoration(
                                        hintText: 'Select City',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                      items:
                                          _availableCities.map((city) {
                                            return DropdownMenuItem<String>(
                                              value: city,
                                              child: Text(city),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setModalState(() {
                                          _selectedCity = value;
                                        });
                                        setState(() {
                                          _selectedCity = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Accepting New Clients Filter
                                  Card(
                                    child: CheckboxListTile(
                                      title: Text(
                                        'Accepting New Clients',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                      subtitle: Text(
                                        'Show only lawyers currently accepting new clients',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      value: _acceptingNewClients,
                                      tristate: true,
                                      onChanged: (value) {
                                        setModalState(() {
                                          _acceptingNewClients = value;
                                        });
                                        setState(() {
                                          _acceptingNewClients = value;
                                        });
                                      },
                                      activeColor: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _clearFilters();
                                          },
                                          icon: const Icon(Icons.clear),
                                          label: const Text('Clear All'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.surface,
                                            foregroundColor:
                                                theme
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _performSearch();
                                          },
                                          icon: const Icon(Icons.search),
                                          label: const Text('Apply Filters'),
                                          style: theme.elevatedButtonTheme.style
                                              ?.copyWith(
                                                padding: WidgetStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
          ),
    );
  }
}

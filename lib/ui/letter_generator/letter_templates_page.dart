import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/letter_bloc/letter_bloc.dart';
import '../../models/letter_template_model.dart';
import '../../models/letter_request_model.dart';

@RoutePage()
class LetterTemplatesPage extends StatefulWidget {
  const LetterTemplatesPage({super.key});

  @override
  State<LetterTemplatesPage> createState() => _LetterTemplatesPageState();
}

class _LetterTemplatesPageState extends State<LetterTemplatesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<LetterBloc>().add(const LoadTemplates());
    // Load letter history when the page initializes
    context.read<LetterBloc>().add(const LoadLetterHistory());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Templates', icon: Icon(Icons.description_outlined)),
            Tab(text: 'My Letters', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTemplatesTab(), _buildMyLettersTab()],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: BlocBuilder<LetterBloc, LetterState>(
            builder: (context, state) {
              if (state is LetterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is LetterError) {
                return _buildErrorWidget(state.message);
              }

              if (state is TemplatesLoaded) {
                return _buildTemplatesList(state);
              }

              return const Center(child: Text('No templates available'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyLettersTab() {
    return BlocBuilder<LetterBloc, LetterState>(
      builder: (context, state) {
        if (state is LetterLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LetterError) {
          return _buildLetterHistoryError(state.message);
        }

        if (state is HistoryLoaded) {
          return _buildLetterHistoryList(state.history);
        }

        return _buildEmptyLetterHistory();
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search templates...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          BlocBuilder<LetterBloc, LetterState>(
            builder: (context, state) {
              if (state is TemplatesLoaded && state.categories != null) {
                return _buildCategoryFilter(state.categories!);
              }
              return const SizedBox.shrink();
            },
          ),
          // Clear filters button
          if (_selectedCategory != null || _searchController.text.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                onPressed: _clearAllFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All Filters'),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(Map<String, String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedCategory == null,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedCategory = null);
                _onCategoryChanged(null);
              }
            },
          ),
          const SizedBox(width: 8),
          ...categories.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(entry.value),
                selected: _selectedCategory == entry.key,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? entry.key : null;
                  });
                  _onCategoryChanged(selected ? entry.key : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTemplatesList(TemplatesLoaded state) {
    if (state.templates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No templates found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.templates.length,
      itemBuilder: (context, index) {
        final template = state.templates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildLetterHistoryList(List<LetterRequestModel> letters) {
    if (letters.isEmpty) {
      return _buildEmptyLetterHistory();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LetterBloc>().add(const LoadLetterHistory());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: letters.length,
        itemBuilder: (context, index) {
          final letter = letters[index];
          return _buildLetterHistoryCard(letter);
        },
      ),
    );
  }

  Widget _buildLetterHistoryCard(LetterRequestModel letter) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (letter.status) {
      case LetterRequestStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case LetterRequestStatus.processing:
        statusColor = Colors.orange;
        statusIcon = Icons.refresh;
        statusText = 'Processing';
        break;
      case LetterRequestStatus.failed:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Failed';
        break;
      case LetterRequestStatus.pending:
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        statusText = 'Pending';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _onLetterHistoryItemTapped(letter),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      letter.letterTemplate?.name ?? 'Unknown Template',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Client: ${letter.clientName}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (letter.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Created: ${_formatDate(letter.createdAt!)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
              if (letter.requestId != null) ...[
                const SizedBox(height: 4),
                Text(
                  'ID: ${letter.requestId}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLetterHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No generated letters yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Letters you generate will appear here',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _tabController.animateTo(0); // Switch to Templates tab
            },
            child: const Text('Browse Templates'),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterHistoryError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading letter history',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LetterBloc>().add(const LoadLetterHistory());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(LetterTemplateModel template) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _onTemplateSelected(template),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      _getCategoryDisplayName(template.category),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                template.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${template.requiredFields.length} required fields',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${template.optionalFields.length} optional fields',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading templates',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LetterBloc>().add(const LoadTemplates());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _searchController.clear();
    });
    context.read<LetterBloc>().add(const LoadTemplates());
  }

  void _onSearchChanged(String query) {
    context.read<LetterBloc>().add(
      LoadTemplates(
        search: query.trim().isEmpty ? null : query.trim(),
        category: _selectedCategory,
      ),
    );
  }

  void _onCategoryChanged(String? category) {
    context.read<LetterBloc>().add(
      LoadTemplates(
        category: category,
        search:
            _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
      ),
    );
  }

  void _onTemplateSelected(LetterTemplateModel template) {
    context.read<LetterBloc>().add(SelectTemplate(template));
    context.router.pushNamed('/letter-form/${template.id}');
  }

  void _onLetterHistoryItemTapped(LetterRequestModel letter) {
    if (letter.requestId != null) {
      // Navigate to the result page to view/check status of the letter
      context.router.pushNamed('/letter-result/${letter.requestId}');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getCategoryDisplayName(String category) {
    // Map category keys to display names
    const categoryNames = {
      'eviction': 'Eviction',
      'employment': 'Employment',
      'family': 'Family Law',
      'consumer': 'Consumer Rights',
      'criminal': 'Criminal Law',
      'property': 'Property Law',
      'debt': 'Debt & Credit',
      'general': 'General',
    };
    return categoryNames[category] ?? category.toUpperCase();
  }
}

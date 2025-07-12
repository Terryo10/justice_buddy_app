import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/letter_bloc/letter_bloc.dart';
import '../../models/letter_request_model.dart';

@RoutePage()
class LetterHistoryPage extends StatefulWidget {
  const LetterHistoryPage({super.key});

  @override
  State<LetterHistoryPage> createState() => _LetterHistoryPageState();
}

class _LetterHistoryPageState extends State<LetterHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Load letter history when the page loads
    context.read<LetterBloc>().add(const LoadLetterHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter History'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LetterBloc>().add(const LoadLetterHistory());
            },
          ),
        ],
      ),
      body: BlocBuilder<LetterBloc, LetterState>(
        builder: (context, state) {
          if (state is LetterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LetterError) {
            return _buildErrorWidget(state.message);
          }

          if (state is HistoryLoaded) {
            if (state.history.isEmpty) {
              return _buildEmptyState();
            }
            return _buildHistoryList(state.history, isWide);
          }

          return const Center(child: Text('Loading history...'));
        },
      ),
    );
  }

  Widget _buildHistoryList(List<LetterRequestModel> history, bool isWide) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LetterBloc>().add(const LoadLetterHistory());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isWide ? 24 : 16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final letter = history[index];
          return _buildHistoryCard(letter, isWide);
        },
      ),
    );
  }

  Widget _buildHistoryCard(LetterRequestModel letter, bool isWide) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to letter enhancement page
          if (letter.requestId != null) {
            context.router.pushNamed('/letter-enhance/${letter.requestId}');
          }
        },
        child: Padding(
          padding: EdgeInsets.all(isWide ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          letter.letterTemplate?.name ?? 'Unknown Template',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Client: ${letter.clientName}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(letter.status.name),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Created: ${letter.createdAt != null ? _formatDate(letter.createdAt!) : 'Unknown'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (letter.generatedAt != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Generated: ${_formatDate(letter.generatedAt!)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'ID: ${letter.requestId ?? 'Unknown'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const Spacer(),
                  if (letter.status == LetterRequestStatus.completed &&
                      letter.requestId != null) ...[
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // Download letter functionality
                        _downloadLetter(letter.requestId!);
                      },
                      tooltip: 'Download Letter',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to enhancement page
                        context.router.pushNamed(
                          '/letter-enhance/${letter.requestId}',
                        );
                      },
                      tooltip: 'Edit Letter',
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

  Widget _buildStatusChip(String status) {
    final theme = Theme.of(context);

    Color chipColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = theme.colorScheme.primary.withAlpha((0.1 * 255).round());
        textColor = theme.colorScheme.primary;
        icon = Icons.check_circle;
        break;
      case 'processing':
        chipColor = Colors.orange.withAlpha((0.1 * 255).round());
        textColor = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      case 'failed':
        chipColor = theme.colorScheme.error.withAlpha((0.1 * 255).round());
        textColor = theme.colorScheme.error;
        icon = Icons.error;
        break;
      case 'pending':
      default:
        chipColor = Colors.grey.withAlpha((0.1 * 255).round());
        textColor = Colors.grey;
        icon = Icons.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
            Icons.description_outlined,
            size: 80,
            color: theme.colorScheme.primary.withAlpha((0.3 * 255).round()),
          ),
          const SizedBox(height: 24),
          Text(
            'No Letters Generated Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate your first letter to see it here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to letter templates
              context.router.pushNamed('/letter-templates');
            },
            icon: const Icon(Icons.add),
            label: const Text('Generate Letter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Error Loading History',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _downloadLetter(String requestId) {
    // Show download dialog or start download
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download Letter'),
            content: const Text(
              'Download functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

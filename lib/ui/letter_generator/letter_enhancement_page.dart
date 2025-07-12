import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/letter_bloc/letter_bloc.dart';
import '../../models/letter_request_model.dart';
// Web-specific imports
import 'dart:html' as html show Blob, Url, AnchorElement;

@RoutePage()
class LetterEnhancementPage extends StatefulWidget {
  final String requestId;

  const LetterEnhancementPage({
    super.key,
    @PathParam('requestId') required this.requestId,
  });

  @override
  State<LetterEnhancementPage> createState() => _LetterEnhancementPageState();
}

class _LetterEnhancementPageState extends State<LetterEnhancementPage> {
  late TextEditingController _letterContentController;
  late TextEditingController _clientNameController;
  LetterRequestModel? _currentLetter;
  bool _isEditing = false;
  bool _hasChanges = false;
  bool _previousUpdating = false;

  @override
  void initState() {
    super.initState();
    _letterContentController = TextEditingController();
    _clientNameController = TextEditingController();

    // Load the letter details
    _loadLetterDetails();
  }

  @override
  void dispose() {
    _letterContentController.dispose();
    _clientNameController.dispose();
    super.dispose();
  }

  void _loadLetterDetails() {
    context.read<LetterBloc>().add(CheckLetterStatus(widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Details'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          if (_currentLetter != null && _currentLetter!.isCompleted) ...[
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadLetter,
              tooltip: 'Download Letter',
            ),
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: _isEditing ? _saveLetter : _toggleEditing,
              tooltip: _isEditing ? 'Save Changes' : 'Edit Letter',
            ),
          ],
        ],
      ),
      body: BlocListener<LetterBloc, LetterState>(
        listener: (context, state) {
          if (state is LetterDataState && state.currentLetter != null) {
            _setCurrentLetter(state.currentLetter!);

            // Show success message if letter was updated
            if (state.isUpdating == false && _previousUpdating == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Letter saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            _previousUpdating = state.isUpdating;
          } else if (state is LetterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<LetterBloc, LetterState>(
          builder: (context, state) {
            if (state is LetterLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LetterError) {
              return _buildErrorWidget(state.message);
            }

            if (_currentLetter == null) {
              return const Center(child: Text('Loading letter details...'));
            }

            return _buildLetterContent(isWide);
          },
        ),
      ),
    );
  }

  Widget _buildLetterContent(bool isWide) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Letter Header
          _buildLetterHeader(theme),
          const SizedBox(height: 24),

          // Letter Status
          _buildLetterStatus(theme),
          const SizedBox(height: 24),

          // Letter Content
          if (_currentLetter!.isCompleted)
            _buildLetterContentSection(theme, isWide),

          // Client Information
          const SizedBox(height: 24),
          _buildClientInfoSection(theme),

          // Actions
          const SizedBox(height: 32),
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildLetterHeader(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                        _currentLetter!.letterTemplate?.name ??
                            'Unknown Template',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentLetter!.letterTemplate?.description ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(_currentLetter!.status.name),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.fingerprint,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${_currentLetter!.requestId ?? 'Unknown'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                if (_currentLetter!.createdAt != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Created: ${_formatDate(_currentLetter!.createdAt!)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterStatus(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(_currentLetter!.status.name),
              color: _getStatusColor(_currentLetter!.status.name),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(_currentLetter!.status.name),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusDescription(_currentLetter!.status.name),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (_currentLetter!.status == LetterRequestStatus.processing) ...[
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadLetterDetails,
                tooltip: 'Refresh Status',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLetterContentSection(ThemeData theme, bool isWide) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Letter Content',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isEditing) ...[
                  TextButton(
                    onPressed: _cancelEditing,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<LetterBloc, LetterState>(
                    builder: (context, state) {
                      final isLoading = state is LetterLoading;
                      return ElevatedButton(
                        onPressed:
                            (_hasChanges && !isLoading) ? _saveLetter : null,
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Save'),
                      );
                    },
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: _toggleEditing,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: isWide ? 400 : 300),
              child:
                  _isEditing
                      ? TextField(
                        controller: _letterContentController,
                        maxLines: null,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Edit your letter content here...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _hasChanges =
                                value != _currentLetter!.generatedLetter;
                          });
                        },
                      )
                      : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentLetter!.generatedLetter ??
                              'No content available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentLetter!.clientName,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (_currentLetter!.clientEmail != null) ...[
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentLetter!.clientEmail!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (_currentLetter!.clientPhone != null) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentLetter!.clientPhone!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentLetter!.isCompleted ? _downloadLetter : null,
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
            'Error Loading Letter',
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
            onPressed: _loadLetterDetails,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _setCurrentLetter(LetterRequestModel letter) {
    setState(() {
      _currentLetter = letter;
      _letterContentController.text = letter.generatedLetter ?? '';
      _clientNameController.text = letter.clientName;
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _letterContentController.text = _currentLetter!.generatedLetter ?? '';
      }
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _hasChanges = false;
      _letterContentController.text = _currentLetter!.generatedLetter ?? '';
    });
  }

  void _saveLetter() {
    if (_currentLetter?.requestId != null) {
      // Save to backend
      context.read<LetterBloc>().add(
        UpdateLetter(
          requestId: _currentLetter!.requestId!,
          generatedLetter: _letterContentController.text,
          clientName:
              _clientNameController.text.trim().isNotEmpty
                  ? _clientNameController.text.trim()
                  : null,
        ),
      );

      setState(() {
        _isEditing = false;
        _hasChanges = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_currentLetter?.generatedLetter != null) {
      Clipboard.setData(ClipboardData(text: _currentLetter!.generatedLetter!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Letter copied to clipboard!')),
      );
    }
  }

  void _downloadLetter() {
    if (_currentLetter?.requestId != null) {
      if (kIsWeb) {
        // For web, create a downloadable file
        final content = _currentLetter!.generatedLetter ?? '';
        final blob = html.Blob([content], 'text/plain');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: url)
              ..download = 'letter_${_currentLetter!.requestId}.txt'
              ..click();
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Letter downloaded!')));
      } else {
        // For mobile, show download dialog
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Download Letter'),
                content: const Text(
                  'Download functionality is not yet implemented for mobile platforms.',
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
  }

  Color _getStatusColor(String status) {
    final theme = Theme.of(context);

    switch (status.toLowerCase()) {
      case 'completed':
        return theme.colorScheme.primary;
      case 'processing':
        return Colors.orange;
      case 'failed':
        return theme.colorScheme.error;
      case 'pending':
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'processing':
        return Icons.hourglass_empty;
      case 'failed':
        return Icons.error;
      case 'pending':
      default:
        return Icons.pending;
    }
  }

  String _getStatusTitle(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Letter Generated Successfully';
      case 'processing':
        return 'Generating Letter...';
      case 'failed':
        return 'Generation Failed';
      case 'pending':
      default:
        return 'Letter Generation Pending';
    }
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Your letter has been generated and is ready for download.';
      case 'processing':
        return 'Your letter is being generated. This may take a few moments.';
      case 'failed':
        return 'There was an error generating your letter. Please try again.';
      case 'pending':
      default:
        return 'Your letter generation request is in the queue.';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

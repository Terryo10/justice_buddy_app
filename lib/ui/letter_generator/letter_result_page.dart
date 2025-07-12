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
class LetterResultPage extends StatefulWidget {
  final String requestId;

  const LetterResultPage({
    super.key,
    @PathParam('requestId') required this.requestId,
  });

  @override
  State<LetterResultPage> createState() => _LetterResultPageState();
}

class _LetterResultPageState extends State<LetterResultPage> {
  @override
  void initState() {
    super.initState();
    // Check the status of the letter request
    context.read<LetterBloc>().add(CheckLetterStatus(widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Letter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          BlocBuilder<LetterBloc, LetterState>(
            builder: (context, state) {
              if (state is LetterDataState &&
                  state.currentLetter != null &&
                  state.currentLetter!.isCompleted &&
                  state.currentLetter!.generatedLetter != null) {
                return IconButton(
                  onPressed: () => _copyToClipboard(state.currentLetter!.generatedLetter!),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy to clipboard',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<LetterBloc, LetterState>(
        listener: (context, state) {
          if (state is LetterError) {
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

            if (state is LetterDataState && state.currentLetter != null) {
              if (state.currentLetter!.isCompleted) {
                return _buildLetterContent(state.currentLetter!);
              } else if (state.isGenerating || state.currentLetter!.isProcessing) {
                return _buildGeneratingContent(state.currentLetter!);
              }
            }

            return const Center(child: Text('Loading letter details...'));
          },
        ),
      ),
    );
  }

  Widget _buildLetterContent(LetterRequestModel request) {
    if (request.generatedLetter == null || request.generatedLetter!.isEmpty) {
      return _buildErrorWidget('Letter content is not available');
    }

    return Column(
      children: [
        _buildRequestInfo(request),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Generated Letter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(
                      request.generatedLetter!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildActionButtons(request),
      ],
    );
  }

  Widget _buildGeneratingContent(LetterRequestModel request) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Generating your letter...',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Request Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Request ID', request.requestId ?? 'N/A'),
                  _buildDetailRow('Client Name', request.clientName),
                  _buildDetailRow('Status', request.status.name.toUpperCase()),
                  if (request.letterTemplate != null) ...[
                    _buildDetailRow('Template', request.letterTemplate!.name),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<LetterBloc>().add(
                CheckLetterStatus(widget.requestId),
              );
            },
            child: const Text('Refresh Status'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfo(LetterRequestModel request) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Letter Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Request ID', request.requestId ?? 'N/A'),
            _buildDetailRow('Client Name', request.clientName),
            if (request.clientEmail != null) ...[
              _buildDetailRow('Client Email', request.clientEmail!),
            ],
            if (request.clientPhone != null) ...[
              _buildDetailRow('Client Phone', request.clientPhone!),
            ],
            if (request.letterTemplate != null) ...[
              _buildDetailRow('Template', request.letterTemplate!.name),
              _buildDetailRow('Category', request.letterTemplate!.category ?? 'N/A'),
            ],
            if (request.generatedAt != null) ...[
              _buildDetailRow(
                'Generated At',
                _formatDateTime(request.generatedAt!),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(request.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                request.status.name.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(request.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(LetterRequestModel request) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _copyToClipboard(request.generatedLetter!),
              icon: const Icon(Icons.copy),
              label: const Text('Copy to Clipboard'),
            ),
          ),
          const SizedBox(height: 8),
          if (request.documentPath != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadDocument(request),
                icon: const Icon(Icons.download),
                label: const Text('Download Document'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          // PDF Download Button (placeholder, will be enabled when PDF is available)
          if (request.documentPath != null &&
              request.documentPath!.endsWith('.pdf')) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadDocument(request),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Download as PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          // Enhance/Edit Letter Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  request.requestId != null
                      ? () {
                        context.router.pushNamed(
                          '/letter-enhance/${request.requestId}',
                        );
                      }
                      : null,
              icon: const Icon(Icons.edit),
              label: const Text('Enhance / Edit Letter'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.router.pushNamed('/letter-templates');
              },
              child: const Text('Generate Another Letter'),
            ),
          ),
        ],
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
            'Error Loading Letter',
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
              context.read<LetterBloc>().add(
                CheckLetterStatus(widget.requestId),
              );
            },
            child: const Text('Retry'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              context.router.pushNamed('/letter-templates');
            },
            child: const Text('Back to Templates'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Letter copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadDocument(LetterRequestModel request) async {
    if (request.requestId == null) return;

    try {
      if (kIsWeb) {
        // For web, create a downloadable file
        final content = request.generatedLetter ?? '';
        final blob = html.Blob([content], 'text/plain');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..download = 'letter_${request.requestId}.txt'
          ..click();
        html.Url.revokeObjectUrl(url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Letter downloaded!')),
          );
        }
      } else {
        // For mobile, show download dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(LetterRequestStatus status) {
    switch (status) {
      case LetterRequestStatus.pending:
        return Colors.orange;
      case LetterRequestStatus.processing:
        return Colors.blue;
      case LetterRequestStatus.completed:
        return Colors.green;
      case LetterRequestStatus.failed:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

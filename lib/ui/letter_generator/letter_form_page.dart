import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../blocs/letter_bloc/letter_bloc.dart';
import '../../models/letter_template_model.dart';

@RoutePage()
class LetterFormPage extends StatefulWidget {
  final int templateId;

  const LetterFormPage({
    super.key,
    @PathParam('templateId') required this.templateId,
  });

  @override
  State<LetterFormPage> createState() => _LetterFormPageState();
}

class _LetterFormPageState extends State<LetterFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _clientMatters = {};

  bool _isGeneratingDialogShown = false;

  late TextEditingController _clientNameController;
  late TextEditingController _clientEmailController;
  late TextEditingController _clientPhoneController;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _clientEmailController = TextEditingController();
    _clientPhoneController = TextEditingController();

    // Load template details if not already loaded
    context.read<LetterBloc>().add(LoadTemplate(widget.templateId));
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientEmailController.dispose();
    _clientPhoneController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Letter Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<LetterBloc, LetterState>(
        listener: (context, state) {
          if (state is LetterDataState &&
              state.currentLetter != null &&
              state.isGenerating &&
              state.currentLetter!.requestId != null &&
              !_isGeneratingDialogShown) {
            // Show generating dialog with status polling
            _showGeneratingDialog(state.currentLetter!.requestId!);
          } else if (state is LetterError) {
            // Show error snackbar
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

            if (state is LetterDataState) {
              if (state.selectedTemplate != null) {
                return _buildForm(state.selectedTemplate!);
              }
            }

            return const Center(child: Text('Loading template details...'));
          },
        ),
      ),
      floatingActionButton: BlocBuilder<LetterBloc, LetterState>(
        builder: (context, state) {
          final isFormValid = _isFormValid(state);
          final isGenerating = state is LetterDataState && state.isGenerating;
          final isLoading = state is LetterLoading;

          return FloatingActionButton.extended(
            onPressed:
                (isFormValid && !isGenerating && !isLoading)
                    ? _generateLetter
                    : null,
            backgroundColor:
                (isFormValid && !isGenerating && !isLoading)
                    ? null
                    : Colors.grey,
            icon:
                isGenerating || isLoading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.send),
            label: Text(isGenerating ? 'Generating...' : 'Generate Letter'),
          );
        },
      ),
    );
  }

  Widget _buildForm(LetterTemplateModel template) {
    _initializeControllers(template);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemplateHeader(template),
                  const SizedBox(height: 24),
                  _buildClientDetailsSection(),
                  const SizedBox(height: 24),
                  _buildRequiredFieldsSection(template),
                  if (template.optionalFields.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildOptionalFieldsSection(template),
                  ],
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateHeader(LetterTemplateModel template) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              template.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _getCategoryDisplayName(template.category ?? 'general'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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

  Widget _buildClientDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Client Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Client name is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientEmailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredFieldsSection(LetterTemplateModel template) {
    if (template.requiredFields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Required Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...template.requiredFields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildFormField(field, true),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalFieldsSection(LetterTemplateModel template) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...template.optionalFields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildFormField(field, false),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String fieldName, bool isRequired) {
    final controller = _controllers[fieldName]!;
    final displayName = _getFieldDisplayName(fieldName);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$displayName${isRequired ? ' *' : ''}',
        border: const OutlineInputBorder(),
        helperText: _getFieldHelpText(fieldName),
      ),
      maxLines: _shouldBeMultiline(fieldName) ? 3 : 1,
      validator:
          isRequired
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$displayName is required';
                }
                return null;
              }
              : null,
      onChanged: (value) {
        _clientMatters[fieldName] = value;
        _updateFormValidation();
      },
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
            'Error loading template',
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
              context.read<LetterBloc>().add(LoadTemplate(widget.templateId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _initializeControllers(LetterTemplateModel template) {
    // Initialize controllers for template fields if not already done
    for (final field in template.allFields) {
      if (!_controllers.containsKey(field)) {
        _controllers[field] = TextEditingController();
      }
    }
  }

  void _updateFormValidation() {
    // This will trigger form validation updates
    setState(() {});
  }

  void _generateLetter() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<LetterBloc>().state;
      if (state is LetterDataState && state.selectedTemplate != null) {
        final template = state.selectedTemplate!;

        context.read<LetterBloc>().add(
          GenerateLetter(
            templateId: template.id,
            clientName: _clientNameController.text.trim(),
            clientEmail:
                _clientEmailController.text.trim().isEmpty
                    ? null
                    : _clientEmailController.text.trim(),
            clientPhone:
                _clientPhoneController.text.trim().isEmpty
                    ? null
                    : _clientPhoneController.text.trim(),
            clientMatters: _clientMatters,
          ),
        );
      }
    }
  }

  void _showGeneratingDialog(String requestId) {
    _isGeneratingDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<LetterBloc>(),
            child: BlocListener<LetterBloc, LetterState>(
              listener: (context, state) {
                if (state is LetterDataState &&
                    state.currentLetter != null &&
                    state.currentLetter!.isCompleted) {
                  // Close dialog and navigate to result
                  Navigator.of(dialogContext).pop();
                  _isGeneratingDialogShown = false;
                  context.router.pushNamed(
                    '/letter-result/${state.currentLetter!.requestId}',
                  );
                } else if (state is LetterError) {
                  // Close dialog and show error
                  Navigator.of(dialogContext).pop();
                  _isGeneratingDialogShown = false;
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
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text('Generating your letter...'),
                        const SizedBox(height: 8),
                        Text(
                          'Request ID: $requestId',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please wait while we generate your letter. This may take a few moments.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
    ).then((_) {
      // Reset dialog flag when dialog is closed
      _isGeneratingDialogShown = false;
    });

    // Start polling for status updates
    _startStatusPolling(requestId);
  }

  void _startStatusPolling(String requestId) {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentState = context.read<LetterBloc>().state;

      // Stop polling if letter is completed, failed, or not generating
      if (currentState is LetterDataState &&
          currentState.currentLetter != null &&
          currentState.currentLetter!.isCompleted) {
        timer.cancel();
        return;
      }

      if (currentState is LetterError) {
        timer.cancel();
        return;
      }

      if (currentState is LetterDataState && !currentState.isGenerating) {
        timer.cancel();
        return;
      }

      // Check status
      context.read<LetterBloc>().add(CheckLetterStatus(requestId));
    });
  }

  String _getFieldDisplayName(String fieldName) {
    // Convert snake_case or camelCase to display name
    return fieldName
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty
                  ? ''
                  : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String? _getFieldHelpText(String fieldName) {
    // Provide help text for common fields
    const helpTexts = {
      'property_address': 'Full address of the property in question',
      'rental_amount': 'Monthly rental amount in dollars',
      'lease_start_date': 'Start date of the lease (e.g., January 1, 2024)',
      'lease_end_date': 'End date of the lease (e.g., December 31, 2024)',
      'notice_period': 'Required notice period (e.g., 30 days)',
      'incident_date': 'Date when the incident occurred',
      'employer_name': 'Full legal name of the employer/company',
      'employee_position': 'Job title or position held',
      'incident_description': 'Detailed description of what happened',
    };
    return helpTexts[fieldName];
  }

  bool _shouldBeMultiline(String fieldName) {
    // Fields that should have multiple lines
    const multilineFields = {
      'incident_description',
      'additional_details',
      'specific_concerns',
      'background_information',
      'description',
      'details',
      'notes',
    };
    return multilineFields.contains(fieldName) ||
        fieldName.contains('description') ||
        fieldName.contains('details');
  }

  String _getCategoryDisplayName(String category) {
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

  bool _isFormValid(LetterState state) {
    // Check if client name is filled
    if (_clientNameController.text.trim().isEmpty) {
      return false;
    }

    // Check if all required template fields are filled
    if (state is LetterDataState && state.selectedTemplate != null) {
      final template = state.selectedTemplate!;

      for (final field in template.requiredFields) {
        final controller = _controllers[field];
        if (controller == null || controller.text.trim().isEmpty) {
          return false;
        }
      }
    }

    return true;
  }
}

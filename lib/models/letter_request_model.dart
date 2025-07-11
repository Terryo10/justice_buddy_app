import 'package:equatable/equatable.dart';
import 'letter_template_model.dart';

enum LetterRequestStatus { pending, processing, completed, failed }

class LetterRequestModel extends Equatable {
  final int? id;
  final int letterTemplateId;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final Map<String, dynamic> clientMatters;
  final String? generatedLetter;
  final LetterRequestStatus status;
  final String? errorMessage;
  final String? documentPath;
  final String? requestId;
  final DateTime? generatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final LetterTemplateModel? letterTemplate;

  const LetterRequestModel({
    this.id,
    required this.letterTemplateId,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.clientMatters = const {},
    this.generatedLetter,
    required this.status,
    this.errorMessage,
    this.documentPath,
    this.requestId,
    this.generatedAt,
    this.createdAt,
    this.updatedAt,
    this.letterTemplate,
  });

  factory LetterRequestModel.fromJson(Map<String, dynamic> json) {
    return LetterRequestModel(
      id: json['id'] as int?,
      letterTemplateId: json['letter_template_id'] as int? ?? 0,
      clientName: json['client_name'] as String? ?? '',
      clientEmail: json['client_email'] as String?,
      clientPhone: json['client_phone'] as String?,
      clientMatters: Map<String, dynamic>.from(json['client_matters'] ?? {}),
      generatedLetter: json['generated_letter'] as String?,
      status: _parseStatus(json['status'] as String?),
      errorMessage: json['error_message'] as String?,
      documentPath: json['document_path'] as String?,
      requestId: json['request_id'] as String?,
      generatedAt:
          json['generated_at'] != null
              ? DateTime.parse(json['generated_at'])
              : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      letterTemplate:
          json['letter_template'] != null
              ? LetterTemplateModel.fromJson(json['letter_template'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'letter_template_id': letterTemplateId,
      'client_name': clientName,
      'client_email': clientEmail,
      'client_phone': clientPhone,
      'client_matters': clientMatters,
      'generated_letter': generatedLetter,
      'status': status.name,
      'error_message': errorMessage,
      'document_path': documentPath,
      'request_id': requestId,
      'generated_at': generatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'letter_template': letterTemplate?.toJson(),
    };
  }

  LetterRequestModel copyWith({
    int? id,
    int? letterTemplateId,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    Map<String, dynamic>? clientMatters,
    String? generatedLetter,
    LetterRequestStatus? status,
    String? errorMessage,
    String? documentPath,
    String? requestId,
    DateTime? generatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    LetterTemplateModel? letterTemplate,
  }) {
    return LetterRequestModel(
      id: id ?? this.id,
      letterTemplateId: letterTemplateId ?? this.letterTemplateId,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhone: clientPhone ?? this.clientPhone,
      clientMatters: clientMatters ?? this.clientMatters,
      generatedLetter: generatedLetter ?? this.generatedLetter,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      documentPath: documentPath ?? this.documentPath,
      requestId: requestId ?? this.requestId,
      generatedAt: generatedAt ?? this.generatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      letterTemplate: letterTemplate ?? this.letterTemplate,
    );
  }

  static LetterRequestStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return LetterRequestStatus.pending;
      case 'processing':
        return LetterRequestStatus.processing;
      case 'completed':
        return LetterRequestStatus.completed;
      case 'failed':
        return LetterRequestStatus.failed;
      default:
        return LetterRequestStatus.pending;
    }
  }

  bool get isCompleted => status == LetterRequestStatus.completed;
  bool get isPending => status == LetterRequestStatus.pending;
  bool get isProcessing => status == LetterRequestStatus.processing;
  bool get isFailed => status == LetterRequestStatus.failed;

  @override
  List<Object?> get props => [
    id,
    letterTemplateId,
    clientName,
    clientEmail,
    clientPhone,
    clientMatters,
    generatedLetter,
    status,
    errorMessage,
    documentPath,
    requestId,
    generatedAt,
    createdAt,
    updatedAt,
    letterTemplate,
  ];
}

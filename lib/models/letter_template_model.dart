import 'package:equatable/equatable.dart';

class LetterTemplateModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String? category;
  final List<String> requiredFields;
  final List<String> optionalFields;
  final String? templateContent;
  final String? aiInstructions;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  const LetterTemplateModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.category,
    required this.requiredFields,
    required this.optionalFields,
    this.templateContent,
    this.aiInstructions,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
  });

  factory LetterTemplateModel.fromJson(Map<String, dynamic> json) {
    return LetterTemplateModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      requiredFields: List<String>.from(json['required_fields'] ?? []),
      optionalFields: List<String>.from(json['optional_fields'] ?? []),
      templateContent: json['template_content'] as String?,
      aiInstructions: json['ai_instructions'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'category': category,
      'required_fields': requiredFields,
      'optional_fields': optionalFields,
      'template_content': templateContent,
      'ai_instructions': aiInstructions,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  LetterTemplateModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? category,
    List<String>? requiredFields,
    List<String>? optionalFields,
    String? templateContent,
    String? aiInstructions,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return LetterTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      category: category ?? this.category,
      requiredFields: requiredFields ?? this.requiredFields,
      optionalFields: optionalFields ?? this.optionalFields,
      templateContent: templateContent ?? this.templateContent,
      aiInstructions: aiInstructions ?? this.aiInstructions,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get all field names (required + optional)
  List<String> get allFields => [...requiredFields, ...optionalFields];

  /// Validate client matters against template requirements
  List<String> validateClientMatters(Map<String, dynamic> clientMatters) {
    final errors = <String>[];

    for (final field in requiredFields) {
      if (!clientMatters.containsKey(field) ||
          clientMatters[field] == null ||
          clientMatters[field].toString().trim().isEmpty) {
        errors.add("Required field '$field' is missing or empty");
      }
    }

    return errors;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    category,
    requiredFields,
    optionalFields,
    templateContent,
    aiInstructions,
    isActive,
    sortOrder,
    createdAt,
  ];
}

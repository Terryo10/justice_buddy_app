import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String fileName;
  final String fileType;
  final String fileExtension;
  final int fileSize;
  final String? fileSizeFormatted;
  final String? category;
  final List<String> tags;
  final int downloadCount;
  final bool isActive;
  final bool isFeatured;
  final bool isWordDocument;
  final bool isPdfDocument;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.fileName,
    required this.fileType,
    required this.fileExtension,
    required this.fileSize,
    this.fileSizeFormatted,
    this.category,
    required this.tags,
    required this.downloadCount,
    required this.isActive,
    required this.isFeatured,
    required this.isWordDocument,
    required this.isPdfDocument,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    final fileExtension = json['file_extension'] as String? ?? '';

    return DocumentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      fileExtension: fileExtension,
      fileSize: json['file_size'] as int,
      fileSizeFormatted: json['formatted_file_size'] as String?,
      category: json['category'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      downloadCount: json['download_count'] as int,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      isWordDocument: _isWordDocument(fileExtension),
      isPdfDocument: _isPdfDocument(fileExtension),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static bool _isWordDocument(String extension) {
    return ['doc', 'docx'].contains(extension.toLowerCase());
  }

  static bool _isPdfDocument(String extension) {
    return extension.toLowerCase() == 'pdf';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'file_name': fileName,
      'file_type': fileType,
      'file_extension': fileExtension,
      'file_size': fileSize,
      'formatted_file_size': fileSizeFormatted,
      'category': category,
      'tags': tags,
      'download_count': downloadCount,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DocumentModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? fileName,
    String? fileType,
    String? fileExtension,
    int? fileSize,
    String? fileSizeFormatted,
    String? category,
    List<String>? tags,
    int? downloadCount,
    bool? isActive,
    bool? isFeatured,
    bool? isWordDocument,
    bool? isPdfDocument,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSize: fileSize ?? this.fileSize,
      fileSizeFormatted: fileSizeFormatted ?? this.fileSizeFormatted,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      downloadCount: downloadCount ?? this.downloadCount,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isWordDocument: isWordDocument ?? this.isWordDocument,
      isPdfDocument: isPdfDocument ?? this.isPdfDocument,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    fileName,
    fileType,
    fileExtension,
    fileSize,
    fileSizeFormatted,
    category,
    tags,
    downloadCount,
    isActive,
    isFeatured,
    isWordDocument,
    isPdfDocument,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'DocumentModel(id: $id, name: $name, slug: $slug, category: $category, '
        'fileExtension: $fileExtension, downloadCount: $downloadCount)';
  }

  // Helper methods
  String get displayFileSize => fileSizeFormatted ?? '${fileSize} bytes';

  String get displayCategory =>
      category
          ?.replaceAll('-', ' ')
          .split(' ')
          .map(
            (word) =>
                word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1)
                    : word,
          )
          .join(' ') ??
      'Uncategorized';

  String get fileTypeDisplay {
    switch (fileExtension.toLowerCase()) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
        return 'Word Document';
      case 'docx':
        return 'Word Document (Modern)';
      default:
        return 'Document';
    }
  }

  bool get hasDescription => description != null && description!.isNotEmpty;
  bool get hasTags => tags.isNotEmpty;
  bool get hasCategory => category != null && category!.isNotEmpty;
}

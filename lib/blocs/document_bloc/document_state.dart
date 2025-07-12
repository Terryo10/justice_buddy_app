part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

class DocumentsLoaded extends DocumentState {
  final List<DocumentModel> documents;
  final String? selectedCategory;
  final String? selectedFileType;
  final String? selectedExtension;
  final String? searchQuery;
  final bool? featuredFilter;
  final String sortBy;
  final String sortDirection;

  const DocumentsLoaded({
    required this.documents,
    this.selectedCategory,
    this.selectedFileType,
    this.selectedExtension,
    this.searchQuery,
    this.featuredFilter,
    this.sortBy = 'name',
    this.sortDirection = 'asc',
  });

  @override
  List<Object?> get props => [
    documents,
    selectedCategory,
    selectedFileType,
    selectedExtension,
    searchQuery,
    featuredFilter,
    sortBy,
    sortDirection,
  ];
}

class DocumentDetailsLoaded extends DocumentState {
  final DocumentModel document;

  const DocumentDetailsLoaded({required this.document});

  @override
  List<Object?> get props => [document];
}

class DocumentCategoriesLoaded extends DocumentState {
  final List<String> categories;

  const DocumentCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class DocumentDownloading extends DocumentState {
  final String slug;

  const DocumentDownloading({required this.slug});

  @override
  List<Object?> get props => [slug];
}

class DocumentDownloaded extends DocumentState {
  final String filePath;
  final String documentName;

  const DocumentDownloaded({
    required this.filePath,
    required this.documentName,
  });

  @override
  List<Object?> get props => [filePath, documentName];
}

class DocumentError extends DocumentState {
  final String message;

  const DocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DocumentMultipleStates extends DocumentState {
  final List<DocumentModel>? documents;
  final List<String>? categories;
  final DocumentModel? selectedDocument;
  final String? selectedCategory;
  final String? selectedFileType;
  final String? selectedExtension;
  final String? searchQuery;
  final bool? featuredFilter;
  final String sortBy;
  final String sortDirection;
  final bool isLoading;
  final String? errorMessage;

  const DocumentMultipleStates({
    this.documents,
    this.categories,
    this.selectedDocument,
    this.selectedCategory,
    this.selectedFileType,
    this.selectedExtension,
    this.searchQuery,
    this.featuredFilter,
    this.sortBy = 'name',
    this.sortDirection = 'asc',
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    documents,
    categories,
    selectedDocument,
    selectedCategory,
    selectedFileType,
    selectedExtension,
    searchQuery,
    featuredFilter,
    sortBy,
    sortDirection,
    isLoading,
    errorMessage,
  ];

  DocumentMultipleStates copyWith({
    List<DocumentModel>? documents,
    List<String>? categories,
    DocumentModel? selectedDocument,
    String? selectedCategory,
    String? selectedFileType,
    String? selectedExtension,
    String? searchQuery,
    bool? featuredFilter,
    String? sortBy,
    String? sortDirection,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedDocument = false,
  }) {
    return DocumentMultipleStates(
      documents: documents ?? this.documents,
      categories: categories ?? this.categories,
      selectedDocument:
          clearSelectedDocument
              ? null
              : selectedDocument ?? this.selectedDocument,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFileType: selectedFileType ?? this.selectedFileType,
      selectedExtension: selectedExtension ?? this.selectedExtension,
      searchQuery: searchQuery ?? this.searchQuery,
      featuredFilter: featuredFilter ?? this.featuredFilter,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

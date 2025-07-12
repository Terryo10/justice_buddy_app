part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentEvent {
  final String? category;
  final String? fileType;
  final String? extension;
  final String? search;
  final bool? featured;
  final String sortBy;
  final String sortDirection;
  final int perPage;
  final int page;

  const LoadDocuments({
    this.category,
    this.fileType,
    this.extension,
    this.search,
    this.featured,
    this.sortBy = 'name',
    this.sortDirection = 'asc',
    this.perPage = 15,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
    category,
    fileType,
    extension,
    search,
    featured,
    sortBy,
    sortDirection,
    perPage,
    page,
  ];
}

class LoadDocumentsByCategory extends DocumentEvent {
  final String category;
  final String sortBy;
  final String sortDirection;
  final int perPage;
  final int page;

  const LoadDocumentsByCategory({
    required this.category,
    this.sortBy = 'name',
    this.sortDirection = 'asc',
    this.perPage = 15,
    this.page = 1,
  });

  @override
  List<Object?> get props => [category, sortBy, sortDirection, perPage, page];
}

class LoadFeaturedDocuments extends DocumentEvent {
  const LoadFeaturedDocuments();
}

class LoadPopularDocuments extends DocumentEvent {
  const LoadPopularDocuments();
}

class LoadDocumentCategories extends DocumentEvent {
  const LoadDocumentCategories();
}

class SearchDocuments extends DocumentEvent {
  final String searchQuery;
  final String? category;
  final String? fileType;
  final String sortBy;
  final String sortDirection;
  final int perPage;
  final int page;

  const SearchDocuments({
    required this.searchQuery,
    this.category,
    this.fileType,
    this.sortBy = 'name',
    this.sortDirection = 'asc',
    this.perPage = 15,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
    searchQuery,
    category,
    fileType,
    sortBy,
    sortDirection,
    perPage,
    page,
  ];
}

class LoadDocumentDetails extends DocumentEvent {
  final String slug;

  const LoadDocumentDetails({required this.slug});

  @override
  List<Object?> get props => [slug];
}

class DownloadDocument extends DocumentEvent {
  final String slug;

  const DownloadDocument({required this.slug});

  @override
  List<Object?> get props => [slug];
}

class FilterDocuments extends DocumentEvent {
  final String? category;
  final String? fileType;
  final String? extension;
  final bool? featured;

  const FilterDocuments({
    this.category,
    this.fileType,
    this.extension,
    this.featured,
  });

  @override
  List<Object?> get props => [category, fileType, extension, featured];
}

class SortDocuments extends DocumentEvent {
  final String sortBy;
  final String sortDirection;

  const SortDocuments({required this.sortBy, required this.sortDirection});

  @override
  List<Object?> get props => [sortBy, sortDirection];
}

class ClearDocuments extends DocumentEvent {
  const ClearDocuments();
}

class ResetDocumentState extends DocumentEvent {
  const ResetDocumentState();
}

class SelectDocument extends DocumentEvent {
  final DocumentModel document;

  const SelectDocument({required this.document});

  @override
  List<Object?> get props => [document];
}

class ClearSelectedDocument extends DocumentEvent {
  const ClearSelectedDocument();
}

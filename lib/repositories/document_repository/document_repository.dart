import '../../models/document_model.dart';
import 'document_provider.dart';

class DocumentRepository {
  final DocumentProvider _documentProvider;

  DocumentRepository({required DocumentProvider documentProvider})
    : _documentProvider = documentProvider;

  /// Get all documents with optional filtering
  Future<List<DocumentModel>> getDocuments({
    String? category,
    String? fileType,
    String? extension,
    String? search,
    bool? featured,
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      return await _documentProvider.getDocuments(
        category: category,
        fileType: fileType,
        extension: extension,
        search: search,
        featured: featured,
        sortBy: sortBy,
        sortDirection: sortDirection,
        perPage: perPage,
        page: page,
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get a single document by slug
  Future<DocumentModel> getDocumentBySlug(String slug) async {
    try {
      return await _documentProvider.getDocumentBySlug(slug);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get featured documents
  Future<List<DocumentModel>> getFeaturedDocuments() async {
    try {
      return await _documentProvider.getFeaturedDocuments();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get popular documents (most downloaded)
  Future<List<DocumentModel>> getPopularDocuments() async {
    try {
      return await _documentProvider.getPopularDocuments();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get all available document categories
  Future<List<String>> getDocumentCategories() async {
    try {
      return await _documentProvider.getDocumentCategories();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Download a document and return the local file path
  Future<String> downloadDocument(String slug) async {
    try {
      return await _documentProvider.downloadDocument(slug);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get documents by category
  Future<List<DocumentModel>> getDocumentsByCategory(
    String category, {
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      category: category,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }

  /// Search documents
  Future<List<DocumentModel>> searchDocuments(
    String searchQuery, {
    String? category,
    String? fileType,
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      search: searchQuery,
      category: category,
      fileType: fileType,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }

  /// Get documents by file type
  Future<List<DocumentModel>> getDocumentsByFileType(
    String fileType, {
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      fileType: fileType,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }

  /// Get documents by file extension
  Future<List<DocumentModel>> getDocumentsByExtension(
    String extension, {
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      extension: extension,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }

  /// Get PDF documents
  Future<List<DocumentModel>> getPdfDocuments({
    String? category,
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      extension: 'pdf',
      category: category,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }

  /// Get Word documents
  Future<List<DocumentModel>> getWordDocuments({
    String? category,
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await getDocuments(
      fileType: 'application/msword',
      category: category,
      sortBy: sortBy,
      sortDirection: sortDirection,
      perPage: perPage,
      page: page,
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/document_model.dart';
import '../../repositories/document_repository/document_repository.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository documentRepository;

  DocumentBloc({required this.documentRepository}) : super(DocumentInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<LoadDocumentsByCategory>(_onLoadDocumentsByCategory);
    on<LoadFeaturedDocuments>(_onLoadFeaturedDocuments);
    on<LoadPopularDocuments>(_onLoadPopularDocuments);
    on<LoadDocumentCategories>(_onLoadDocumentCategories);
    on<SearchDocuments>(_onSearchDocuments);
    on<LoadDocumentDetails>(_onLoadDocumentDetails);
    on<DownloadDocument>(_onDownloadDocument);
    on<FilterDocuments>(_onFilterDocuments);
    on<SortDocuments>(_onSortDocuments);
    on<ClearDocuments>(_onClearDocuments);
    on<ResetDocumentState>(_onResetDocumentState);
    on<SelectDocument>(_onSelectDocument);
    on<ClearSelectedDocument>(_onClearSelectedDocument);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.getDocuments(
        category: event.category,
        fileType: event.fileType,
        extension: event.extension,
        search: event.search,
        featured: event.featured,
        sortBy: event.sortBy,
        sortDirection: event.sortDirection,
        perPage: event.perPage,
        page: event.page,
      );
      emit(
        DocumentsLoaded(
          documents: documents,
          selectedCategory: event.category,
          selectedFileType: event.fileType,
          selectedExtension: event.extension,
          searchQuery: event.search,
          featuredFilter: event.featured,
          sortBy: event.sortBy,
          sortDirection: event.sortDirection,
        ),
      );
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onLoadDocumentsByCategory(
    LoadDocumentsByCategory event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.getDocumentsByCategory(
        event.category,
        sortBy: event.sortBy,
        sortDirection: event.sortDirection,
        perPage: event.perPage,
        page: event.page,
      );
      emit(
        DocumentsLoaded(
          documents: documents,
          selectedCategory: event.category,
          sortBy: event.sortBy,
          sortDirection: event.sortDirection,
        ),
      );
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onLoadFeaturedDocuments(
    LoadFeaturedDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.getFeaturedDocuments();
      emit(DocumentsLoaded(documents: documents, featuredFilter: true));
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onLoadPopularDocuments(
    LoadPopularDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.getPopularDocuments();
      emit(
        DocumentsLoaded(
          documents: documents,
          sortBy: 'downloads',
          sortDirection: 'desc',
        ),
      );
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onLoadDocumentCategories(
    LoadDocumentCategories event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final categories = await documentRepository.getDocumentCategories();
      emit(DocumentCategoriesLoaded(categories: categories));
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.searchDocuments(
        event.searchQuery,
        category: event.category,
        fileType: event.fileType,
        sortBy: event.sortBy,
        sortDirection: event.sortDirection,
        perPage: event.perPage,
        page: event.page,
      );
      emit(
        DocumentsLoaded(
          documents: documents,
          searchQuery: event.searchQuery,
          selectedCategory: event.category,
          selectedFileType: event.fileType,
          sortBy: event.sortBy,
          sortDirection: event.sortDirection,
        ),
      );
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onLoadDocumentDetails(
    LoadDocumentDetails event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final document = await documentRepository.getDocumentBySlug(event.slug);
      emit(DocumentDetailsLoaded(document: document));
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onDownloadDocument(
    DownloadDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentDownloading(slug: event.slug));
    try {
      final filePath = await documentRepository.downloadDocument(event.slug);
      emit(DocumentDownloaded(filePath: filePath, documentName: event.slug));
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onFilterDocuments(
    FilterDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.getDocuments(
        category: event.category,
        fileType: event.fileType,
        extension: event.extension,
        featured: event.featured,
      );
      emit(
        DocumentsLoaded(
          documents: documents,
          selectedCategory: event.category,
          selectedFileType: event.fileType,
          selectedExtension: event.extension,
          featuredFilter: event.featured,
        ),
      );
    } catch (error) {
      emit(DocumentError(message: error.toString()));
    }
  }

  Future<void> _onSortDocuments(
    SortDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    if (state is DocumentsLoaded) {
      final currentState = state as DocumentsLoaded;
      emit(DocumentLoading());
      try {
        final documents = await documentRepository.getDocuments(
          category: currentState.selectedCategory,
          fileType: currentState.selectedFileType,
          extension: currentState.selectedExtension,
          search: currentState.searchQuery,
          featured: currentState.featuredFilter,
          sortBy: event.sortBy,
          sortDirection: event.sortDirection,
        );
        emit(
          DocumentsLoaded(
            documents: documents,
            selectedCategory: currentState.selectedCategory,
            selectedFileType: currentState.selectedFileType,
            selectedExtension: currentState.selectedExtension,
            searchQuery: currentState.searchQuery,
            featuredFilter: currentState.featuredFilter,
            sortBy: event.sortBy,
            sortDirection: event.sortDirection,
          ),
        );
      } catch (error) {
        emit(DocumentError(message: error.toString()));
      }
    }
  }

  Future<void> _onClearDocuments(
    ClearDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentsLoaded(documents: [], sortBy: 'name', sortDirection: 'asc'));
  }

  Future<void> _onResetDocumentState(
    ResetDocumentState event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentInitial());
  }

  Future<void> _onSelectDocument(
    SelectDocument event,
    Emitter<DocumentState> emit,
  ) async {
    if (state is DocumentMultipleStates) {
      final currentState = state as DocumentMultipleStates;
      emit(currentState.copyWith(selectedDocument: event.document));
    } else {
      emit(DocumentMultipleStates(selectedDocument: event.document));
    }
  }

  Future<void> _onClearSelectedDocument(
    ClearSelectedDocument event,
    Emitter<DocumentState> emit,
  ) async {
    if (state is DocumentMultipleStates) {
      final currentState = state as DocumentMultipleStates;
      emit(currentState.copyWith(clearSelectedDocument: true));
    }
  }
}

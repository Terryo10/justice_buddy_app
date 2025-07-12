import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justice_buddy/models/law_info_item_model.dart';
import 'package:justice_buddy/models/category_model.dart';

import '../../repositories/law_info_repository/law_info_repository.dart';

part 'law_info_item_event.dart';
part 'law_info_item_state.dart';

class LawInfoItemBloc extends Bloc<LawInfoItemEvent, LawInfoItemState> {
  final LawInfoItemRepository lawInfoItemRepository;

  LawInfoItemBloc({required this.lawInfoItemRepository})
    : super(LawInfoItemInitial()) {
    on<LoadLawInfoItems>(_onLoadLawInfoItems);
    on<LoadLawInfoItemsByCategory>(_onLoadLawInfoItemsByCategory);
    on<SearchLawInfoItems>(_onSearchLawInfoItems);
    on<LoadLawInfoItemDetails>(_onLoadLawInfoItemDetails);
    on<ClearLawInfoItems>(_onClearLawInfoItems);
    on<ClearSelectedLawInfoItem>(_onClearSelectedLawInfoItem);
  }

  Future<void> _onLoadLawInfoItems(
    LoadLawInfoItems event,
    Emitter<LawInfoItemState> emit,
  ) async {
    emit(LawInfoItemLoading());
    try {
      final lawInfoItems = await lawInfoItemRepository.getLawInfoItems(
        perPage: event.perPage,
        page: event.page,
      );

      // Preserve selectedLawInfoItem if it exists
      final selectedLawInfoItem =
          state is LawInfoItemLoaded
              ? (state as LawInfoItemLoaded).selectedLawInfoItem
              : null;

      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: null,
          searchQuery: null,
          selectedLawInfoItem: selectedLawInfoItem,
        ),
      );
    } catch (error) {
      emit(LawInfoItemError(message: error.toString()));
    }
  }

  Future<void> _onLoadLawInfoItemsByCategory(
    LoadLawInfoItemsByCategory event,
    Emitter<LawInfoItemState> emit,
  ) async {
    emit(LawInfoItemLoading());
    try {
      final lawInfoItems = await lawInfoItemRepository.getLawInfoItems(
        categoryId: event.category.id,
        perPage: event.perPage,
        page: event.page,
      );

      // Preserve selectedLawInfoItem if it exists
      final selectedLawInfoItem =
          state is LawInfoItemLoaded
              ? (state as LawInfoItemLoaded).selectedLawInfoItem
              : null;

      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: event.category,
          searchQuery: null,
          selectedLawInfoItem: selectedLawInfoItem,
        ),
      );
    } catch (error) {
      emit(LawInfoItemError(message: error.toString()));
    }
  }

  Future<void> _onSearchLawInfoItems(
    SearchLawInfoItems event,
    Emitter<LawInfoItemState> emit,
  ) async {
    emit(LawInfoItemLoading());
    try {
      final lawInfoItems = await lawInfoItemRepository.getLawInfoItems(
        search: event.query,
        categoryId: event.categoryId,
        perPage: event.perPage,
        page: event.page,
      );

      // Preserve selectedLawInfoItem if it exists
      final selectedLawInfoItem =
          state is LawInfoItemLoaded
              ? (state as LawInfoItemLoaded).selectedLawInfoItem
              : null;

      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: null,
          searchQuery: event.query,
          selectedLawInfoItem: selectedLawInfoItem,
        ),
      );
    } catch (error) {
      emit(LawInfoItemError(message: error.toString()));
    }
  }

  Future<void> _onLoadLawInfoItemDetails(
    LoadLawInfoItemDetails event,
    Emitter<LawInfoItemState> emit,
  ) async {
    // Only show loading if we don't have existing data
    if (state is! LawInfoItemLoaded) {
      emit(LawInfoItemLoading());
    }

    try {
      final lawInfoItem = await lawInfoItemRepository.getLawInfoItemBySlug(
        event.slug,
      );

      // If we have existing loaded state, preserve it and just update the selected item
      if (state is LawInfoItemLoaded) {
        final currentState = state as LawInfoItemLoaded;
        emit(currentState.copyWith(selectedLawInfoItem: lawInfoItem));
      } else {
        // If no existing state, create a new one with just the selected item
        emit(
          LawInfoItemLoaded(lawInfoItems: [], selectedLawInfoItem: lawInfoItem),
        );
      }
    } catch (error) {
      emit(LawInfoItemError(message: error.toString()));
    }
  }

  void _onClearLawInfoItems(
    ClearLawInfoItems event,
    Emitter<LawInfoItemState> emit,
  ) {
    emit(LawInfoItemInitial());
  }

  void _onClearSelectedLawInfoItem(
    ClearSelectedLawInfoItem event,
    Emitter<LawInfoItemState> emit,
  ) {
    if (state is LawInfoItemLoaded) {
      final currentState = state as LawInfoItemLoaded;
      emit(currentState.copyWith(clearSelectedLawInfoItem: true));
    }
  }
}

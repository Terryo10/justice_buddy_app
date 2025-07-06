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
      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: null,
          searchQuery: null,
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
      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: event.category,
          searchQuery: null,
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
      emit(
        LawInfoItemLoaded(
          lawInfoItems: lawInfoItems,
          selectedCategory: null,
          searchQuery: event.query,
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
    emit(LawInfoItemLoading());
    try {
      final lawInfoItem = await lawInfoItemRepository.getLawInfoItemBySlug(
        event.slug,
      );
      emit(LawInfoItemDetailLoaded(lawInfoItem: lawInfoItem));
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
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justice_buddy/models/category_model.dart';
import 'package:justice_buddy/repositories/categories_repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<ClearCategorySelection>(_onClearCategorySelection);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(
        categories: categories,
        selectedCategory: null,
      ));
    } catch (error) {
      emit(CategoryError(message: error.toString()));
    }
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  void _onClearCategorySelection(
    ClearCategorySelection event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(currentState.copyWith(selectedCategory: null));
    }
  }
}


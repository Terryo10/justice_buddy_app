part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  const CategoryLoaded({required this.categories, this.selectedCategory});

  CategoryLoaded copyWith({
    List<CategoryModel>? categories,
    CategoryModel? selectedCategory,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

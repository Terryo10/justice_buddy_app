// category_event.dart
part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SelectCategory extends CategoryEvent {
  final CategoryModel category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ClearCategorySelection extends CategoryEvent {}

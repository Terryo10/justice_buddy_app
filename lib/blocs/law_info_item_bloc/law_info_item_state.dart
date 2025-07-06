// law_info_item_state.dart
part of 'law_info_item_bloc.dart';

abstract class LawInfoItemState extends Equatable {
  const LawInfoItemState();

  @override
  List<Object?> get props => [];
}

class LawInfoItemInitial extends LawInfoItemState {}

class LawInfoItemLoading extends LawInfoItemState {}

class LawInfoItemLoaded extends LawInfoItemState {
  final List<LawInfoItemModel> lawInfoItems;
  final CategoryModel? selectedCategory;
  final String? searchQuery;

  const LawInfoItemLoaded({
    required this.lawInfoItems,
    this.selectedCategory,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [lawInfoItems, selectedCategory, searchQuery];
}

class LawInfoItemDetailLoaded extends LawInfoItemState {
  final LawInfoItemModel lawInfoItem;

  const LawInfoItemDetailLoaded({required this.lawInfoItem});

  @override
  List<Object?> get props => [lawInfoItem];
}

class LawInfoItemError extends LawInfoItemState {
  final String message;

  const LawInfoItemError({required this.message});

  @override
  List<Object?> get props => [message];
}

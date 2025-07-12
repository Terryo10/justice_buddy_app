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
  final LawInfoItemModel? selectedLawInfoItem;

  const LawInfoItemLoaded({
    required this.lawInfoItems,
    this.selectedCategory,
    this.searchQuery,
    this.selectedLawInfoItem,
  });

  @override
  List<Object?> get props => [
    lawInfoItems,
    selectedCategory,
    searchQuery,
    selectedLawInfoItem,
  ];

  LawInfoItemLoaded copyWith({
    List<LawInfoItemModel>? lawInfoItems,
    CategoryModel? selectedCategory,
    String? searchQuery,
    LawInfoItemModel? selectedLawInfoItem,
    bool clearSelectedLawInfoItem = false,
  }) {
    return LawInfoItemLoaded(
      lawInfoItems: lawInfoItems ?? this.lawInfoItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLawInfoItem:
          clearSelectedLawInfoItem
              ? null
              : selectedLawInfoItem ?? this.selectedLawInfoItem,
    );
  }
}

class LawInfoItemError extends LawInfoItemState {
  final String message;

  const LawInfoItemError({required this.message});

  @override
  List<Object?> get props => [message];
}

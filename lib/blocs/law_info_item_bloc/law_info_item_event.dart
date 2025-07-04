part of 'law_info_item_bloc.dart';

abstract class LawInfoItemEvent extends Equatable {
  const LawInfoItemEvent();

  @override
  List<Object?> get props => [];
}

class LoadLawInfoItems extends LawInfoItemEvent {
  final int perPage;
  final int page;

  const LoadLawInfoItems({this.perPage = 15, this.page = 1});

  @override
  List<Object?> get props => [perPage, page];
}

class LoadLawInfoItemsByCategory extends LawInfoItemEvent {
  final cat.CategoryModel category;
  final int perPage;
  final int page;

  const LoadLawInfoItemsByCategory({
    required this.category,
    this.perPage = 15,
    this.page = 1,
  });

  @override
  List<Object?> get props => [category, perPage, page];
}

class SearchLawInfoItems extends LawInfoItemEvent {
  final String query;
  final int? categoryId;
  final int perPage;
  final int page;

  const SearchLawInfoItems({
    required this.query,
    this.categoryId,
    this.perPage = 15,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, categoryId, perPage, page];
}

class LoadLawInfoItemDetails extends LawInfoItemEvent {
  final String slug;

  const LoadLawInfoItemDetails(this.slug);

  @override
  List<Object?> get props => [slug];
}

class ClearLawInfoItems extends LawInfoItemEvent {}

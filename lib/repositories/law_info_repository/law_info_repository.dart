import '../../models/law_info_item_model.dart';
import 'law_info_provider.dart';

class LawInfoItemRepository {
  final LawInfoItemProvider provider;

  LawInfoItemRepository({required this.provider});

  Future<List<LawInfoItemModel>> getLawInfoItems({
    int? categoryId,
    String? categorySlug,
    String? search,
    int perPage = 15,
    int page = 1,
  }) => provider.getLawInfoItems(
    categoryId: categoryId,
    categorySlug: categorySlug,
    search: search,
    perPage: perPage,
    page: page,
  );

  Future<LawInfoItemModel> getLawInfoItemById(int id) => 
      provider.getLawInfoItemById(id);

  Future<LawInfoItemModel> getLawInfoItemBySlug(String slug) => 
      provider.getLawInfoItemBySlug(slug);

  Future<List<LawInfoItemModel>> getRelatedLawInfoItems(String slug) => 
      provider.getRelatedLawInfoItems(slug);
}
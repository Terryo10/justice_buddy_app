import 'package:justice_buddy/repositories/categories_repository/category_provider.dart';
import '../../models/category_model.dart';

class CategoryRepository {
  final CategoryProvider provider;

  CategoryRepository({required this.provider});

  Future<List<CategoryModel>> getCategories() => provider.getCategories();

  Future<CategoryModel> getCategoryById(int id) => provider.getCategoryById(id);
}

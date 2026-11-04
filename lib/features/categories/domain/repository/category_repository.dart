import 'package:quiz_app/features/categories/domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getCategories();
}
import 'package:quiz_app/features/categories/domain/entities/category.dart';
import 'package:quiz_app/features/categories/domain/repositories/category_repository.dart';

class GetCategoriesUsecase {
  GetCategoriesUsecase(this._categoryRepository);
  final CategoryRepository _categoryRepository;

  Future<List<Category>> call() => _categoryRepository.getCategories();
}
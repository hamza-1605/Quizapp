import 'package:quiz_app/features/categories/data/datasources/category_local_data_source.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';
import 'package:quiz_app/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  
  CategoryRepositoryImpl(this._localDataSource);
  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<Category>> getCategories() => _localDataSource.getCategories();
}
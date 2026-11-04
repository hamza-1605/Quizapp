import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/categories/data/models/category_model.dart';

class CategoryLocalDataSource {
  CategoryLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<List<CategoryModel>> getCategories() async {
    final db = await _appDatabase.database;
    final rows = await db.query('categories', orderBy: 'name COLLATE NOCASE'); // otherwise 'Zoology' will appear before 'art'
    return rows.map( CategoryModel.fromMap ).toList();
  }
}
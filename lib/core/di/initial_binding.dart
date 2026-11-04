import 'package:get/get.dart';
import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/categories/data/datasources/category_local_data_source.dart';
import 'package:quiz_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:quiz_app/features/categories/domain/repositories/category_repository.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';

/// Creates the objects that live for the whole life of the app.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppDatabase>(AppDatabase(), permanent: true);

    Get.put<CategoryLocalDataSource>(
      CategoryLocalDataSource(Get.find<AppDatabase>()),
      permanent: true,
    );

    Get.put<CategoryRepository>(
      CategoryRepositoryImpl(Get.find<CategoryLocalDataSource>()),
      permanent: true,
    );
    
    Get.put<GetCategoriesUsecase>(
      GetCategoriesUsecase(Get.find<CategoryRepository>()),
      permanent: true,
    );
  }
}
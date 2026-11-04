import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/categories/data/datasources/category_local_data_source.dart';
import 'package:quiz_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:quiz_app/features/categories/domain/repositories/category_repository.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:quiz_app/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';
import 'package:quiz_app/features/sync/domain/usecases/get_last_checked_at_usecase.dart';
import 'package:quiz_app/features/sync/domain/usecases/sync_content_usecase.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';

/// Creates the objects that live for the whole life of the app.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppDatabase>(AppDatabase(), permanent: true);
    Get.put<http.Client>(http.Client(), permanent: true);

    // Categories
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

    // Sync
    Get.put<SyncRepository>(
      SyncRepositoryImpl(
        remoteDataSource: SyncRemoteDataSource(Get.find<http.Client>()),
        localDataSource: SyncLocalDataSource(Get.find<AppDatabase>()),
      ),
      permanent: true,
    );
    Get.put<SyncContentUsecase>(
      SyncContentUsecase(Get.find<SyncRepository>()),
      permanent: true,
    );
    Get.put<GetLastCheckedAtUsecase>(
      GetLastCheckedAtUsecase(Get.find<SyncRepository>()),
      permanent: true,
    );
    Get.put<SyncController>(
      SyncController(
        syncContentUsecase: Get.find<SyncContentUsecase>(),
        getLastCheckedAtUsecase: Get.find<GetLastCheckedAtUsecase>(),
      ),
      permanent: true,
    );
  }
}
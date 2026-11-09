import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/categories/data/datasources/category_local_data_source.dart';
import 'package:quiz_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:quiz_app/features/categories/domain/repositories/category_repository.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:quiz_app/features/quiz/domain/usecases/get_available_question_count_usecase.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:quiz_app/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';
import 'package:quiz_app/features/sync/domain/usecases/get_last_checked_at_usecase.dart';
import 'package:quiz_app/features/sync/domain/usecases/sync_content_usecase.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';
import 'package:quiz_app/core/cache/app_image_cache.dart';
import 'package:quiz_app/features/sync/data/repositories/image_cache_repository_impl.dart';
import 'package:quiz_app/features/sync/domain/repositories/image_cache_repository.dart';
import 'package:quiz_app/features/sync/domain/usecases/prefetch_images_usecase.dart';
import 'package:quiz_app/features/quiz/data/datasources/question_local_data_source.dart';
import 'package:quiz_app/features/quiz/data/repositories/question_repository_impl.dart';
import 'package:quiz_app/features/quiz/domain/repositories/question_repository.dart';
import 'package:quiz_app/features/quiz/domain/usecases/build_round_usecase.dart';

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

    // Quiz
    Get.put<QuestionLocalDataSource>(
      QuestionLocalDataSource(Get.find<AppDatabase>()),
      permanent: true,
    );
    Get.put<QuestionRepository>(
      QuestionRepositoryImpl(Get.find<QuestionLocalDataSource>()),
      permanent: true,
    );
    Get.put<BuildRoundUsecase>(
      BuildRoundUsecase(Get.find<QuestionRepository>()),
      permanent: true,
    );
    Get.put<GetAvailableQuestionCountUsecase>(
      GetAvailableQuestionCountUsecase(Get.find<QuestionRepository>()),
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

    // Caching Images
    Get.put<ImageCacheRepository>(
      ImageCacheRepositoryImpl(AppImageCache.instance),
      permanent: true,
    );
    Get.put<PrefetchImagesUsecase>(
      PrefetchImagesUsecase(
        Get.find<SyncRepository>(),
        Get.find<ImageCacheRepository>(),
      ),
      permanent: true,
    );
    
    Get.put<SyncController>(
      SyncController(
        syncContentUsecase: Get.find<SyncContentUsecase>(),
        getLastCheckedAtUsecase: Get.find<GetLastCheckedAtUsecase>(),
        prefetchImagesUsecase: Get.find<PrefetchImagesUsecase>(),
      ),
      permanent: true,
    );
  }
}
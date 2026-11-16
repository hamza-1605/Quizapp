import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/models/round_setup_arguments.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';

class HomeController extends GetxController {
  HomeController(this._getCategoriesUsecase, this._syncController);

  final GetCategoriesUsecase _getCategoriesUsecase;
  final SyncController _syncController;

  final categories = <Category>[].obs;
  final isLoading = true.obs;
  final isFirstRun = false.obs;
  
  /// True while the first launch is being set up: no content yet, or still
  /// syncing or downloading images on a first run.
  bool get showSetup =>
      categories.isEmpty ||
      (isFirstRun.value &&
          (_syncController.isSyncing.value || _syncController.isDownloadingImages.value));

  @override
  void onInit() {
    super.onInit();
    _initialLoad();
    // When a sync brings new content, show it.
    ever(_syncController.lastResult, (result) {
      if (result is SyncUpdated) loadCategories();
    });
    // When the first image download ends, the normal home screen takes over.
    ever(_syncController.isDownloadingImages, (isDownloading) {
      if (!isDownloading) isFirstRun.value = false;
    });
  }

  void skipImageWait() => isFirstRun.value = false;


   Future<void> loadCategories() async {
    categories.assignAll(await _getCategoriesUsecase());
  }

  Future<void> _initialLoad() async {
    try {
      await loadCategories();
      isFirstRun.value = categories.isEmpty;
    } 
    finally {
      isLoading.value = false;
    }
  }


  void openCategory(Category category) {
    Get.toNamed(
      AppRoutes.roundSetup,
      arguments: RoundSetupArguments(
        categoryIds: [category.id],
        title: category.name,
      ),
    );
  }

  void openRandomRound() {
    Get.toNamed(
      AppRoutes.roundSetup,
      arguments: RoundSetupArguments(
        categoryIds: categories.map((category) => category.id).toList(),
        title: 'Random mix',
      ),
    );
  }

  void openCustomRound() {
    Get.toNamed(
      AppRoutes.roundSetup,
      arguments: RoundSetupArguments(
        categoryIds: const [],
        title: 'Custom quiz',
        selectableCategories: categories.toList(),
      ),
    );
  }
}
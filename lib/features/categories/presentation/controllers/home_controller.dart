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

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    // When a sync brings new content, show it.
    ever(_syncController.lastResult, (result) {
      if (result is SyncUpdated) loadCategories();
    });
  }

  Future<void> loadCategories() async {
    if (categories.isEmpty) isLoading.value = true; // spinner on first load only
    try {
      categories.assignAll(await _getCategoriesUsecase());
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
}
import 'package:get/get.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';

class HomeController extends GetxController {
  HomeController(this._getCategoriesUsecase);

  final GetCategoriesUsecase _getCategoriesUsecase;

  final categories = <Category>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      categories.assignAll(await _getCategoriesUsecase());
    } 
    finally {
      isLoading.value = false;
    }
  }
}
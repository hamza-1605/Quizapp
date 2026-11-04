import 'package:get/get.dart';
import 'package:quiz_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetCategoriesUsecase>()),
    );
  }
}
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/results_controller.dart';
import 'package:quiz_app/features/quiz/presentation/models/results_arguments.dart';

class ResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultsController>(
      () => ResultsController(Get.arguments as ResultsArguments),
    );
  }
}
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/domain/usecases/build_round_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(
      () => QuizController(
        Get.find<BuildRoundUsecase>(),
        Get.arguments as QuizArguments,
      ),
    );
  }
}
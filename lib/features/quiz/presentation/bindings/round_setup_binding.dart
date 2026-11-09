import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/domain/usecases/get_available_question_count_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/round_setup_controller.dart';
import 'package:quiz_app/features/quiz/presentation/models/round_setup_arguments.dart';

class RoundSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoundSetupController>(
      () => RoundSetupController(
        Get.find<GetAvailableQuestionCountUsecase>(),
        Get.arguments as RoundSetupArguments,
      ),
    );
  }
}
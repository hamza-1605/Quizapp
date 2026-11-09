import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/usecases/get_available_question_count_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';
import 'package:quiz_app/features/quiz/presentation/models/round_setup_arguments.dart';

class RoundSetupController extends GetxController {
  RoundSetupController(
    this._getAvailableQuestionCountUsecase,
    this.roundArguments,
  );

  static const countOptions = [10, 20, 30];

  final GetAvailableQuestionCountUsecase _getAvailableQuestionCountUsecase;
  final RoundSetupArguments roundArguments;

  final isLoading = true.obs;
  final availableCount = 0.obs;
  final selectedCount = 10.obs;

  bool isAvailable(int count) => count <= availableCount.value;

  bool get canStart => !isLoading.value && isAvailable(selectedCount.value);

  @override
  void onInit() {
    super.onInit();
    _loadAvailableCount();
  }
  

  Future<void> _loadAvailableCount() async {
    try {
      availableCount.value = await _getAvailableQuestionCountUsecase(roundArguments.categoryIds);
      selectedCount.value = countOptions.firstWhere(isAvailable, orElse: () => countOptions.first);
    } 
    finally {
      isLoading.value = false;
    }
  }


  void selectCount(int count) {
    if( isAvailable(count) )   selectedCount.value = count;
  }


    void start() {
    if (!canStart) return;
    Get.toNamed(
      AppRoutes.quiz,
      arguments: QuizArguments(
        categoryIds: roundArguments.categoryIds,
        questionCount: selectedCount.value,
        title: roundArguments.title,
      ),
    );
  }
}
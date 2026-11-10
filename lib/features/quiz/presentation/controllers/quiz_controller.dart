import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/domain/usecases/build_round_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';
import 'package:quiz_app/features/quiz/presentation/models/results_arguments.dart';

class QuizController extends GetxController {
  QuizController(this._buildRoundUsecase, this.arguments);

  final BuildRoundUsecase _buildRoundUsecase;
  final QuizArguments arguments;

  final isLoading = true.obs;
  final errorMessage = Rxn<String>();
  final currentIndex = 0.obs;
  final selectedOptionId = Rxn<int>();
  final isSubmitted = false.obs;

  // The round lives in memory, so a background sync can never change it.
  List<Question> _questions = const [];
  final Map<int, int> _answers = {}; // question id -> chosen option id

  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;

  // True while the user is answering questions (not loading or failed).
  bool get isRoundInProgress => !isLoading.value && errorMessage.value == null;

  bool get isCurrentAnswerCorrect => currentQuestion.options.any(
        (option) => option.isCorrect && option.id == selectedOptionId.value,
  );

  String get appBarTitle {
    if (isLoading.value || errorMessage.value != null) {
      return arguments.title;
    }
    return 'Question ${currentIndex.value + 1} of $totalQuestions';
  }

  @override
  void onInit() {
    super.onInit();
    _startRound();
  }

  Future<void> _startRound() async {
    try {
      _questions = await _buildRoundUsecase(
        categoryIds: arguments.categoryIds,
        questionCount: arguments.questionCount,
      );
      if (_questions.isEmpty) {
        errorMessage.value = 'No questions are available for this round.';
      }
    } on Exception {
      errorMessage.value = 'Could not load the questions.';
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(int optionId) {
    if (isSubmitted.value) return;
    selectedOptionId.value = optionId;
  }

  void submit() {
    final selected = selectedOptionId.value;
    if (selected == null || isSubmitted.value) return;
    _answers[currentQuestion.id] = selected;
    isSubmitted.value = true;
  }

  void next() {
    if (!isSubmitted.value) return;
    if (isLastQuestion) {
      _finishRound();
      return;
    }
    currentIndex.value++;
    selectedOptionId.value = null;
    isSubmitted.value = false;
  }

  void _finishRound() {
    // offNamed replaces this page, so "back" from the results never
    // returns to a finished round.
    Get.offNamed(
      AppRoutes.results,
      arguments: ResultsArguments(
        result: RoundResult(questions: _questions, answers: Map.of(_answers)),
        quizArguments: arguments,
      ),
    );
  }
}
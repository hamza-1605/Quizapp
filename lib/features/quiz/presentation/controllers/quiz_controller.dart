import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/domain/usecases/build_round_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';

class QuizController extends GetxController {
  QuizController(this._buildRoundUsecase, this.arguments);

  final BuildRoundUsecase _buildRoundUsecase;
  final QuizArguments arguments;

  final isLoading = true.obs;
  final errorMessage = Rxn<String>();
  final currentIndex = 0.obs;
  final selectedOptionId = Rxn<int>();
  final isSubmitted = false.obs;
  final isFinished = false.obs;

  // The round lives in memory, so a background sync can never change it.
  List<Question> _questions = const [];
  final Map<int, int> _answers = {}; // question id -> chosen option id

  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;
  Map<int, int> get answers => Map.unmodifiable(_answers);

  bool get isCurrentAnswerCorrect => currentQuestion.options.any(
        (option) => option.isCorrect && option.id == selectedOptionId.value,
      );

  int get score => _questions
      .where((q) => q.options.any(
            (option) => option.isCorrect && option.id == _answers[q.id],
          ))
      .length;

  String get appBarTitle {
    if (isLoading.value || errorMessage.value != null || isFinished.value) {
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
      isFinished.value = true;
      return;
    }
    currentIndex.value++;
    selectedOptionId.value = null;
    isSubmitted.value = false;
  }

  void backToHome() => Get.until((route) => route.isFirst);
}
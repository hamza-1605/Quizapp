import 'dart:async';

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
  final remainingSeconds = 0.obs;

  // The round lives in memory, so a background sync can never change it.
  List<Question> _questions = const [];
  final Map<int, int> _answers = {}; // question id -> chosen option id

  Timer? _ticker;
  DateTime? _deadline;
  bool _hasFinished = false;

  bool get isTimed => arguments.isTimed;
  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;

  /// True while the user is answering questions (not loading or failed).
  bool get isRoundInProgress =>
      !isLoading.value && errorMessage.value == null;

  bool get isCurrentAnswerCorrect => currentQuestion.options.any(
        (option) => option.isCorrect && option.id == selectedOptionId.value,
      );

  String get appBarTitle {
    if (isLoading.value || errorMessage.value != null) {
      return arguments.title;
    }
    return '${currentIndex.value + 1} of $totalQuestions';
  }

  @override
  void onInit() {
    super.onInit();
    _startRound();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  Future<void> _startRound() async {
    try {
      _questions = await _buildRoundUsecase(
        categoryIds: arguments.categoryIds,
        questionCount: arguments.questionCount,
      );
      if (_questions.isEmpty) {
        errorMessage.value = 'No questions are available for this round.';
      } else if (isTimed) {
        _startTimer();
      }
    } on Exception {
      errorMessage.value = 'Could not load the questions.';
    } finally {
      isLoading.value = false;
    }
  }

  // ---- Timer ----

  void _startTimer() {
    final total = arguments.totalTime!;
    // We store the moment the round ends, not a counter, so time keeps running even if the app is in the background.
    _deadline = DateTime.now().add(total);
    remainingSeconds.value = total.inSeconds;
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _tick(),
    );
  }

  void _tick() {
    final timeLeft = _deadline!.difference(DateTime.now());
    if (timeLeft <= Duration.zero) {
      remainingSeconds.value = 0;
      _finishRound(timedOut: true);
      return;
    }
    remainingSeconds.value = (timeLeft.inMilliseconds / 1000).ceil();
  }


  // ---- Answering ----

  void selectOption(int optionId) {
    if (isSubmitted.value) return;
    selectedOptionId.value = optionId;
  }

  // Normal rounds: lock in the answer and show the feedback.
  void submit() {
    final selected = selectedOptionId.value;
    if (selected == null || isSubmitted.value) return;
    _answers[currentQuestion.id] = selected;
    isSubmitted.value = true;
  }

  // Normal rounds: leave the feedback and move on.
  void next() {
    if (!isSubmitted.value) return;
    if (isLastQuestion) {
      _finishRound();
      return;
    }
    _goToNextQuestion();
  }

  /// Timed rounds: lock in the answer and move on, with no feedback.
  void answerAndNext() {
    final selected = selectedOptionId.value;
    if (selected == null) return;
    _answers[currentQuestion.id] = selected;
    if (isLastQuestion) {
      _finishRound();
      return;
    }
    _goToNextQuestion();
  }

  void _goToNextQuestion() {
    currentIndex.value++;
    selectedOptionId.value = null;
    isSubmitted.value = false;
  }

  void _finishRound({bool timedOut = false}) {
    if (_hasFinished) return;
    _hasFinished = true;
    _ticker?.cancel();

    // If the quit dialog is open when time runs out, close it first,
    // otherwise offNamed would replace the dialog instead of this page.
    Get.until((route) => route.settings.name == AppRoutes.quiz);

    // offNamed replaces this page, so "back" from the results never
    // returns to a finished round.
    Get.offNamed(
      AppRoutes.results,
      arguments: ResultsArguments(
        result: RoundResult(
          questions: _questions,
          answers: Map.of(_answers),
          timedOut: timedOut,
        ),
        quizArguments: arguments,
      ),
    );
  }
}
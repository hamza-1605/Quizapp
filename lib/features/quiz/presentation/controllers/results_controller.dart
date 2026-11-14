import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/presentation/models/results_arguments.dart';

class ResultsController extends GetxController {
  ResultsController(this.arguments);

  final ResultsArguments arguments;

  RoundResult get result => arguments.result;
  bool confettiLaunched = false;

  void launchConfetti(BuildContext context) {
    if (confettiLaunched) return;

    confettiLaunched = true;

    Confetti.launch(
      context,
      options: ConfettiOptions(
        colors: [
          Colors.blue,
          Colors.yellow,
          Colors.white,
          Colors.green,
          Colors.red,
          Colors.purple,
        ],
        gravity: 0.8,
        particleCount: 70,
        particleDuration: const Duration(seconds: 5),
        spread: 50,
      ),
    );
  }

  /// Starts a new round with the same category and question count.
  void playAgain() =>
      Get.offNamed(AppRoutes.quiz, arguments: arguments.quizArguments);

  void openReview() => Get.toNamed(AppRoutes.review, arguments: result);
  
  void backToHome() => Get.until((route) => route.isFirst);
}
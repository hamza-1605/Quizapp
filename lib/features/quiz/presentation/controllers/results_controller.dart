import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/presentation/models/results_arguments.dart';

class ResultsController extends GetxController {
  ResultsController(this.arguments);

  final ResultsArguments arguments;

  RoundResult get result => arguments.result;

  /// Starts a new round with the same category and question count.
  void playAgain() =>
      Get.offNamed(AppRoutes.quiz, arguments: arguments.quizArguments);

  void openReview() => Get.toNamed(AppRoutes.review, arguments: result);
  
  void backToHome() => Get.until((route) => route.isFirst);
}
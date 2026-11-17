import 'package:get/get.dart';
import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/feedback/domain/entities/feedback_report.dart';
import 'package:quiz_app/features/feedback/domain/entities/feedback_type.dart';
import 'package:quiz_app/features/feedback/domain/usecases/submit_feedback_usecase.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';

enum FeedbackStatus { idle, sending, sent, failed }

class FeedbackController extends GetxController {
  FeedbackController(this._submitFeedbackUsecase, {this.question});

  static const minLength = 5;
  static const maxLength = 500;
  static const _cooldown = Duration(seconds: 15);
  static DateTime? _lastSentAt;

  final SubmitFeedbackUsecase _submitFeedbackUsecase;

  /// Set when the report is about one specific question.
  final Question? question;

  List<FeedbackType> get types =>
      question == null ? FeedbackType.general : FeedbackType.forQuestion;

  late final selectedType = Rx<FeedbackType>(types.first);
  final status = FeedbackStatus.idle.obs;
  final errorMessage = Rxn<String>();

  void selectType(FeedbackType type) => selectedType.value = type;

  Future<void> submit(String rawMessage) async {
    if (status.value == FeedbackStatus.sending) return;

    final message = rawMessage.trim();
    if (message.length < minLength) {
      errorMessage.value = 'Please write at least $minLength characters.';
      return;
    }
    final last = _lastSentAt;
    if (last != null && DateTime.now().difference(last) < _cooldown) {
      errorMessage.value = 'Please wait a moment before sending another one.';
      return;
    }

    errorMessage.value = null;
    status.value = FeedbackStatus.sending;
    try {
      await _submitFeedbackUsecase(
        FeedbackReport(
          type: selectedType.value,
          message: message,
          questionId: question?.id,
          questionText: question?.text,
          options: question?.options.map((o) => o.text).join(' | '),
        ),
      );
      _lastSentAt = DateTime.now();
      status.value = FeedbackStatus.sent;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      status.value = FeedbackStatus.failed;
    }
  }
}
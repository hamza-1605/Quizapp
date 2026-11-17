import 'package:quiz_app/features/feedback/domain/entities/feedback_report.dart';
import 'package:quiz_app/features/feedback/domain/repositories/feedback_repository.dart';

class SubmitFeedbackUsecase {
  SubmitFeedbackUsecase(this._repository);
  final FeedbackRepository _repository;

  Future<void> call(FeedbackReport report) => _repository.submit(report);
}
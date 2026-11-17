import 'package:quiz_app/features/feedback/domain/entities/feedback_report.dart';

abstract interface class FeedbackRepository {
  Future<void> submit(FeedbackReport report);
}
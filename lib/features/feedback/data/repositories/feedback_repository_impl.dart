import 'package:flutter/foundation.dart';
import 'package:quiz_app/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:quiz_app/features/feedback/domain/entities/feedback_report.dart';
import 'package:quiz_app/features/feedback/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl(this._remoteDataSource);

  final FeedbackRemoteDataSource _remoteDataSource;

  @override
  Future<void> submit(FeedbackReport report) {
    return _remoteDataSource.send({
      'type': report.type.apiValue,
      'message': report.message,
      'questionId': report.questionId,
      'questionText': report.questionText,
      'options': report.options,
      'platform': defaultTargetPlatform.name,
    });
  }
}
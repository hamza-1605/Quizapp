import 'package:quiz_app/features/categories/data/models/category_model.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';

class SyncContentModel {
  const SyncContentModel({
    required this.version,
    required this.categories,
    required this.questions,
  });

  final int version;
  final List<CategoryModel> categories;
  final List<QuestionModel> questions;

  
  factory SyncContentModel.fromJson(Map<String, dynamic> json) {
    return SyncContentModel(
      version: json['version'] as int,
      categories: (json['categories'] as List<dynamic>)
                  .map( (cat) => CategoryModel.fromJson(cat as Map<String, dynamic>) )
                  .toList(),
      questions: (json['questions'] as List<dynamic>)
                  .map( (ques) => QuestionModel.fromJson(ques as Map<String, dynamic>) )
                  .toList(),
    );
  }
}
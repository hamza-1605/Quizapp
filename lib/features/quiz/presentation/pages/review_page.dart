import 'package:flutter/material.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/review_question_card.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.result});

  final RoundResult result;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Review answers')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: result.questions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final question = result.questions[index];
            return ReviewQuestionCard(
              number: index + 1,
              question: question,
              chosenOptionId: result.answers[question.id],
              isCorrect: result.isCorrect(question),
            );
          },
        ),
      ),
    );
  }
}
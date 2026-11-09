/// What the quiz page needs to start a round.
class QuizArguments {
  const QuizArguments({
    required this.categoryIds,
    required this.questionCount,
    required this.title,
  });

  final List<int> categoryIds;
  final int questionCount;
  final String title;
}
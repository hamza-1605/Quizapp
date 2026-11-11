/// What the quiz page needs to start a round.
class QuizArguments {
  const QuizArguments({
    required this.categoryIds,
    required this.questionCount,
    required this.title,
    this.secondsPerQuestion,
  });

  final List<int> categoryIds;
  final int questionCount;
  final String title;

  /// Null means the round has no timer.
  final int? secondsPerQuestion;

  bool get isTimed => secondsPerQuestion != null;

  /// The countdown for the whole round, or null without a timer.
  Duration? get totalTime => secondsPerQuestion == null
      ? null
      : Duration(seconds: secondsPerQuestion! * questionCount);
}
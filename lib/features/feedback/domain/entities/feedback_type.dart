enum FeedbackType {
  typo('typo', 'Typo or wrong text'),
  wrongAnswer('wrong_answer', 'Wrong answer'),
  suggestion('suggestion', 'Suggestion'),
  bug('bug', 'App problem'),
  other('other', 'Something else');

  const FeedbackType(this.apiValue, this.label);

  /// The value the Google Sheet script expects.
  final String apiValue;
  final String label;

  /// Choices when reporting a specific question.
  static const forQuestion = [typo, wrongAnswer, other];

  /// Choices for general feedback from Settings.
  static const general = [suggestion, bug, typo, other];
}
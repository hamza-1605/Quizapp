// What the round setup page needs to know about the round being prepared.
class RoundSetupArguments {
  const RoundSetupArguments({required this.categoryIds, required this.title});

  final List<int> categoryIds;
  final String title;
}
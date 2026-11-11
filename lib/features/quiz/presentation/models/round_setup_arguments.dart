import 'package:quiz_app/features/categories/domain/entities/category.dart';

// What the round setup page needs to know about the round being prepared.
class RoundSetupArguments {
  const RoundSetupArguments({
    required this.categoryIds,
    required this.title,
    this.selectableCategories = const [],
  });

  // The categories of the round. Empty for a custom round, where the player chooses them on the setup page.
  final List<int> categoryIds;
  final String title;

  // For a custom round: the categories the player can choose from.
  final List<Category> selectableCategories;

  bool get isCustom => selectableCategories.isNotEmpty;
}
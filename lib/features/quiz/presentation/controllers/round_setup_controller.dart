import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/usecases/get_question_counts_usecase.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';
import 'package:quiz_app/features/quiz/presentation/models/round_setup_arguments.dart';

class RoundSetupController extends GetxController {
  RoundSetupController(this._getQuestionCountsUsecase, this.arguments);

  static const countOptions = [10, 20, 30];
  static const minCustomCategories = 2;
  static const paceOptions = [6, 10, 12, 15]; // seconds per question

  final GetQuestionCountsUsecase _getQuestionCountsUsecase;
  final RoundSetupArguments arguments;

  final isLoading = true.obs;
  final counts = <int, int>{}.obs; // category id -> number of questions
  final selectedCategoryIds = <int>{}.obs; // custom rounds only
  final selectedCount = 10.obs;
  final isTimerOn = false.obs;    // timer options
  final secondsPerQuestion = 12.obs;

  bool get isCustom => arguments.isCustom;

  /// The categories the round will be built from.
  List<int> get activeCategoryIds =>
      isCustom ? selectedCategoryIds.toList() : arguments.categoryIds;

  int get availableCount =>
      activeCategoryIds.fold(0, (sum, id) => sum + (counts[id] ?? 0));

  bool get hasEnoughCategories =>
      !isCustom || selectedCategoryIds.length >= minCustomCategories;

  bool get canStart =>
      !isLoading.value &&
      hasEnoughCategories &&
      isAvailable(selectedCount.value);

  List<int> get _selectableIds => arguments.selectableCategories
      .map((category) => category.id)
      .where((id) => (counts[id] ?? 0) > 0)
      .toList();

  bool get areAllSelected =>
      _selectableIds.isNotEmpty &&
      _selectableIds.every(selectedCategoryIds.contains);

  bool isAvailable(int count) => count <= availableCount;

  int categoryQuestionCount(int categoryId) => counts[categoryId] ?? 0;

  // timer functions
  int get totalSeconds => secondsPerQuestion.value * selectedCount.value;

  void setTimerOn(bool value) => isTimerOn.value = value;

  void selectPace(int seconds) => secondsPerQuestion.value = seconds;


  @override
  void onInit() {
    super.onInit();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    try {
      final ids = isCustom
          ? arguments.selectableCategories.map((c) => c.id).toList()
          : arguments.categoryIds;
      counts.assignAll(await _getQuestionCountsUsecase(ids));
      _keepCountValid();
    } finally {
      isLoading.value = false;
    }
  }

  void selectCount(int count) {
    if (isAvailable(count)) selectedCount.value = count;
  }

  void toggleCategory(int categoryId) {
    if (!selectedCategoryIds.remove(categoryId)) {
      selectedCategoryIds.add(categoryId);
    }
    _keepCountValid();
  }

  void toggleSelectAll() {
    if (areAllSelected) {
      selectedCategoryIds.clear();
    } else {
      selectedCategoryIds.addAll(_selectableIds);
    }
    _keepCountValid();
  }

  /// If fewer questions are available now, move to the largest count that
  /// still fits, so the selected chip is never a greyed-out one.
  void _keepCountValid() {
    if (isAvailable(selectedCount.value)) return;
    selectedCount.value = countOptions.lastWhere(
      isAvailable,
      orElse: () => countOptions.first,
    );
  }

  void start() {
    if (!canStart) return;
    Get.toNamed(
      AppRoutes.quiz,
      arguments: QuizArguments(
        categoryIds: activeCategoryIds,
        questionCount: selectedCount.value,
        title: arguments.title,
        secondsPerQuestion: isTimerOn.value ? secondsPerQuestion.value : null,
      ),
    );
  }
}
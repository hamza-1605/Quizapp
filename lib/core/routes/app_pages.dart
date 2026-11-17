import 'package:get/get.dart';
import 'package:quiz_app/features/categories/presentation/bindings/home_binding.dart';
import 'package:quiz_app/features/categories/presentation/pages/categories_page.dart';
import 'package:quiz_app/features/categories/presentation/pages/home_page.dart';
import 'package:quiz_app/features/categories/presentation/pages/play_mode_page.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/presentation/bindings/quiz_binding.dart';
import 'package:quiz_app/features/quiz/presentation/bindings/results_binding.dart';
import 'package:quiz_app/features/quiz/presentation/bindings/round_setup_binding.dart';
import 'package:quiz_app/features/quiz/presentation/pages/quiz_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/results_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/review_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/round_setup_page.dart';
import 'package:quiz_app/features/settings/presentation/pages/settings_page.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(name: AppRoutes.categories, page: () => const CategoriesPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),

    GetPage(name: AppRoutes.play, page: () => const PlayModePage()),

    GetPage(
      name: AppRoutes.roundSetup,
      page: () => const RoundSetupPage(),
      binding: RoundSetupBinding(),
    ),

    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizPage(),
      binding: QuizBinding(),
    ),

    GetPage(
      name: AppRoutes.results,
      page: () => const ResultsPage(),
      binding: ResultsBinding(),
    ),

    GetPage(
      name: AppRoutes.review,
      page: () => ReviewPage(result: Get.arguments as RoundResult)
    ),

  ];
}
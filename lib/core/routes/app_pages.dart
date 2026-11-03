import 'package:get/get.dart';
import 'package:quiz_app/features/categories/presentation/pages/home_page.dart';
import 'package:quiz_app/core/routes/app_routes.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    
    GetPage(
      name: AppRoutes.home, 
      page: () => const HomePage()
    ),

  ];
}
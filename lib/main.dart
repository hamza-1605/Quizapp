import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_pages.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/core/theme/app_theme.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/round_mode_tile.dart';

/// After "Play": single category, Random mix or Custom quiz.
class PlayModePage extends GetView<HomeController> {
  const PlayModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height - kToolbarHeight -
                        MediaQuery.paddingOf(context).vertical - 80,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Your Game',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gold,
                  ),
                ),

                const SizedBox(height: 60),

                RoundModeTile(
                  icon: Icons.category_outlined,
                  title: 'Single category',
                  subtitle: 'Master one topic',
                  onTap: () => Get.toNamed(AppRoutes.categories),
                ),

                const SizedBox(height: 20),

                RoundModeTile(
                  icon: Icons.shuffle,
                  title: 'Random mix',
                  subtitle: 'Questions from all categories',
                  onTap: controller.openRandomRound,
                ),

                const SizedBox(height: 20),

                RoundModeTile(
                  icon: Icons.tune,
                  title: 'Custom quiz',
                  subtitle: 'Pick your own categories',
                  onTap: controller.openCustomRound,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
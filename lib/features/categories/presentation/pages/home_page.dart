import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/core/widgets/game_button.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/sync/presentation/widgets/first_sync_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Future<void> _confirmExit(BuildContext context) async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit Quirozity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (exit == true) await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      body: SafeArea(
                child: Obx(() {
          final Widget content;
          if (controller.isLoading.value) {
            // The very first read of the database: a blank navy frame, which
            // continues the splash screen instead of flashing a spinner.
            content = const SizedBox.shrink(key: ValueKey('loading'));
          } 
          else if (controller.showSetup) {
            content = FirstSyncView(
              key: const ValueKey('setup'),
              onSkipImages: controller.skipImageWait,
            );
          } else {
            content = _Hub(
              key: const ValueKey('hub'),
              onExit: () => _confirmExit(context),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder: (current, previous) => Stack(
              fit: StackFit.expand,
              children: [...previous, ?current],
            ),
            child: content,
          );
        }),
      ),
    );
  }
}


class _Hub extends StatelessWidget {
  const _Hub({ super.key, required this.onExit});

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/branding/logo.png', height: 190),
                    const SizedBox(height: 8),
                    Text(
                      'Quirozity',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quiz your Curiosity.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GameButton(
                      label: 'Play',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.play),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      label: 'Settings',
                      icon: Icons.settings_outlined,
                      style: GameButtonStyle.secondary,
                      onPressed: () => Get.toNamed(AppRoutes.settings),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      label: 'Exit',
                      icon: Icons.exit_to_app,
                      style: GameButtonStyle.secondary,
                      onPressed: onExit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
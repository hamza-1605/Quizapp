import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/core/widgets/game_button.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';
import 'package:quiz_app/features/sync/presentation/widgets/sync_status_bar.dart';

class SettingsPage extends GetView<SyncController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SectionTitle('Content'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  const SyncStatusBar(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Obx(
                      () => GameButton(
                        label: 'Check for updates',
                        icon: Icons.refresh,
                        style: GameButtonStyle.secondary,
                        onPressed: controller.isBusy ? null : controller.sync,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _SectionTitle('About'),
            Text('Quirozity', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Quiz your Curiosity.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
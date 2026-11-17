import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';
import 'package:quiz_app/features/sync/presentation/widgets/sync_status_bar.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sync = Get.find<SyncController>();

    return AppScaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const _SectionTitle('Sound'),
            _Panel(
              child: Obx(
                () => _SettingRow(
                  title: 'Sound effects',
                  subtitle: 'The sounds themselves arrive in a later update.',
                  value: controller.isSoundOn.value,
                  onChanged: controller.setSound,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const _SectionTitle('Content'),
            _Panel(
              child: Column(
                children: [
                  const SyncStatusBar(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Obx(
                      () => OutlinedButton.icon(
                        onPressed: sync.isBusy ? null : sync.sync,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Check for updates'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            
            const SizedBox(height: 36),
            const _SectionTitle('About'),
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

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
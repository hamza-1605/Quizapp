import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';

/// Shown instead of the category list while the device has no content yet.
class FirstSyncView extends GetView<SyncController> {
  const FirstSyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = controller.lastResult.value;

      if (controller.isSyncing.value || result == null) {
        return _Message(
          showProgress: true,
          title: 'Getting your questions ready',
          body: controller.isServerSlow.value
              ? 'The server is waking up. This can take up to a minute.'
              : 'Downloading the questions for the first time. \nThis is a one time process.',
        );
      }

      if (result is SyncFailed) {
        return _Message(
          icon: Icons.cloud_off_outlined,
          title: 'Connect to the internet',
          body: 'The app needs to download the questions once. \nAfter that, it works without internet.',
          detail: result.message,
          actionLabel: 'Try again',
          onAction: controller.sync,
        );
      }

      return _Message(
        icon: Icons.inbox_outlined,
        title: 'No quizzes yet',
        body: 'There are no questions available right now. '
            'Please check again later.',
        actionLabel: 'Check again',
        onAction: controller.sync,
      );
    });
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    this.icon,
    this.showProgress = false,
    this.detail,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final IconData? icon;
  final bool showProgress;
  final String? detail;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showProgress)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              body,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: 24),
              Text(
                detail!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
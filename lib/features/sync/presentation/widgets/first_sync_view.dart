import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';

/// The first-launch screen. While content or images are being fetched it is
/// one continuous "working" view; it only changes for errors.
class FirstSyncView extends GetView<SyncController> {
  const FirstSyncView({super.key, this.onSkipImages});

  /// Lets the player continue while the images are still downloading.
  final VoidCallback? onSkipImages;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = controller.lastResult.value;

      // Syncing, downloading images, or content just arrived and the list is
      // about to appear: all of these look the same to the player.
      final isWorking = controller.isSyncing.value ||
          controller.isDownloadingImages.value ||
          result == null ||
          (result is SyncUpdated && result.categories > 0);

      if (isWorking) return _WorkingView(onSkipImages: onSkipImages);

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
        body: 'There are no questions available right now. \nPlease check again later.',
        actionLabel: 'Check again',
        onAction: controller.sync,
      );
    });
  }
}

class _WorkingView extends GetView<SyncController> {
  const _WorkingView({this.onSkipImages});

  final VoidCallback? onSkipImages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final total = controller.imagesTotal.value;
      final done = controller.imagesDone.value;
      final hasProgress = controller.isDownloadingImages.value && total > 0;

      final title = hasProgress ? 'Downloading some assets' : 'Getting your questions ready';

      final body = hasProgress
          ? '$done of $total. This is a one time process.'
          : (controller.isServerSlow.value
              ? 'The server is waking up. This can take up to a minute.'
              : 'Downloading the questions for the first time. \nThis only happens once.');

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 240,
                child: hasProgress
                  ? TweenAnimationBuilder<double>(
                      tween: Tween(end: done / total),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  : LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // The space is always reserved, so the layout never jumps when the Skip button appears.
              SizedBox(
                height: 48,
                child: hasProgress && onSkipImages != null
                  ? TextButton(
                      onPressed: onSkipImages,
                      child: const Text('Skip'),
                    )
                  : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.detail,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
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
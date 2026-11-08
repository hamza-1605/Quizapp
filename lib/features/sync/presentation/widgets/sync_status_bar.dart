import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';

class SyncStatusBar extends GetView<SyncController> {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = _statusLine();
      final lastChecked = _lastCheckedLine(context);
      final mutedStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (controller.isBusy) ...[
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status.isNotEmpty) Text(status, style: mutedStyle),
                  if (lastChecked != null) Text(lastChecked, style: mutedStyle),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _statusLine() {
    if (controller.isSyncing.value) {
      return controller.isServerSlow.value
          ? 'Server is waking up, this can take a minute...'
          : 'Checking for updates...';
    }
    if (controller.isDownloadingImages.value &&
        controller.imagesTotal.value > 0) {
      return 'Downloading images: ${controller.imagesDone.value} of ${controller.imagesTotal.value}';
    }
    return switch (controller.lastResult.value) {
      SyncUpToDate() => 'Up to date',
      SyncUpdated(:final questionsAdded) when questionsAdded > 0 =>
        'Updated: $questionsAdded new '
            '${questionsAdded == 1 ? 'question' : 'questions'}',
      SyncUpdated() => 'Content updated',
      SyncFailed(:final message) => 'Update failed: $message',
      null => '',
    };
  }

  String? _lastCheckedLine(BuildContext context) {
    final time = controller.lastCheckedAt.value;
    if (time == null) return null;
    final localizations = MaterialLocalizations.of(context);
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;
    final when = isToday
        ? localizations.formatTimeOfDay(TimeOfDay.fromDateTime(time))
        : localizations.formatShortDate(time);
    return 'Last checked: $when';
  }
}
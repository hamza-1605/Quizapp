import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/game_button.dart';
import 'package:quiz_app/features/feedback/domain/usecases/submit_feedback_usecase.dart';
import 'package:quiz_app/features/feedback/presentation/controllers/feedback_controller.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';

/// Opens the feedback form. Pass [question] to report a specific question.
Future<void> showFeedbackSheet({Question? question}) {
  return showModalBottomSheet<void>(
    context: Get.overlayContext!,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.navy,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => FeedbackSheet(question: question),
  );
}

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key, this.question});

  final Question? question;

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  late final FeedbackController _controller;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = FeedbackController(
      Get.find<SubmitFeedbackUsecase>(),
      question: widget.question,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.question;

    return Padding(
      // The one place that lifts the sheet above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Obx(() {
            if (_controller.status.value == FeedbackStatus.sent) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 56,
                    color: AppColors.correctLight,
                  ),
                  const SizedBox(height: 16),
                  Text('Thank you!', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Your message helps make the app better.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GameButton(
                    label: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            }

            final sending = _controller.status.value == FeedbackStatus.sending;
            final error = _controller.errorMessage.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question == null ? 'Send feedback' : 'Report a problem',
                  style: theme.textTheme.titleLarge,
                ),
                if (question != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.panel,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      question.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final type in _controller.types)
                      ChoiceChip(
                        label: Text(type.label),
                        selected: _controller.selectedType.value == type,
                        onSelected:
                            sending ? null : (_) => _controller.selectType(type),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _textController,
                  enabled: !sending,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: FeedbackController.maxLength,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: question == null
                        ? 'Tell us what is on your mind...'
                        : 'What is wrong with this question?',
                    filled: true,
                    fillColor: AppColors.panel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (error != null)
                  Text(
                    error,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.wrongLight,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Reports are anonymous. Please do not include personal '
                  'information.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                GameButton(
                  label: sending ? 'Sending...' : 'Send',
                  icon: Icons.send_rounded,
                  onPressed: sending ? null : () => _controller.submit(_textController.text),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
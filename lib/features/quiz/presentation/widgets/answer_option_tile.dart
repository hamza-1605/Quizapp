import 'package:flutter/material.dart';

enum AnswerOptionState { idle, selected, correct, wrong }

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.text,
    required this.state,
    this.onTap,
  });

  final String text;
  final AnswerOptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, accent, icon) = switch (state) {
      AnswerOptionState.idle => (
          scheme.surface,
          scheme.outline,
          Icons.radio_button_unchecked,
        ),
      AnswerOptionState.selected => (
          scheme.primaryContainer,
          scheme.primary,
          Icons.radio_button_checked,
        ),
      AnswerOptionState.correct => (
          Colors.green.shade50,
          Colors.green.shade700,
          Icons.check_circle,
        ),
      AnswerOptionState.wrong => (
          Colors.red.shade50,
          Colors.red.shade700,
          Icons.cancel,
        ),
    };

    return Card(
      elevation: 0,
      color: background,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: state == AnswerOptionState.idle
              ? scheme.outlineVariant
              : accent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      ),
    );
  }
}
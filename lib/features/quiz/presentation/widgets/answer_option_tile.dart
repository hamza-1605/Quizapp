import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/angle_pill_border.dart';

enum AnswerOptionState { idle, selected, correct, wrong }

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    this.onTap,
  });

  // The letter shown at the left: A, B, C, D.
  final String label;
  final String text;
  final AnswerOptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color fill, Color border, Color textColor, Color labelColor, IconData? icon)
                                                                     = switch (state) {
      AnswerOptionState.idle => (
          AppColors.panel,
          AppColors.outline,
          Colors.white,
          AppColors.gold,
          null,
        ),
      AnswerOptionState.selected => (
          AppColors.gold,
          AppColors.gold,
          AppColors.navyDeep,
          AppColors.navyDeep,
          null,
        ),
      AnswerOptionState.correct => (
          AppColors.correct,
          AppColors.correctLight,
          Colors.white,
          Colors.white,
          Icons.check_circle,
        ),
      AnswerOptionState.wrong => (
          AppColors.wrong,
          AppColors.wrongLight,
          Colors.white,
          Colors.white,
          Icons.cancel,
        ),
    };

    final shape = AnglePillBorder(side: BorderSide(color: border, width: 2));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: fill,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: Row(
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: textColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
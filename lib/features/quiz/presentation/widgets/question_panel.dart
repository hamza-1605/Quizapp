import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';

// The question text in a gold-bordered panel with pointed ends.
class QuestionPanel extends StatelessWidget {
  const QuestionPanel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: AppColors.navyDeep,
        shape: BeveledRectangleBorder(
          side: BorderSide(color: AppColors.gold, width: 1),
          borderRadius: BorderRadius.circular(10)
        )
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
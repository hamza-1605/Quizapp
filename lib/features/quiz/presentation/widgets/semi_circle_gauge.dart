import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';

/// A half-circle progress bar with the percentage written inside it.
class SemiCircleGauge extends StatelessWidget {
  const SemiCircleGauge({super.key, required this.percentage, this.size = 240});

  final int percentage;

  /// The width of the gauge; its height is about half of that.
  final double size;

  static const _strokeWidth = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$percentage percent',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: percentage / 100),
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return SizedBox(
            width: size,
            height: size / 2 + _strokeWidth / 2,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GaugePainter(
                      progress: value,
                      strokeWidth: _strokeWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${(value * 100).round()}%',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.progress, required this.strokeWidth});

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // The full circle this half belongs to, inset by half the stroke.
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.width - strokeWidth,
    );

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.outline.withValues(alpha: 0.25);
    canvas.drawArc(rect, math.pi, math.pi, false, track);

    if (progress <= 0) return;

    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFE88A), AppColors.gold, Color(0xFFD9A600)],
      ).createShader(rect);
    canvas.drawArc(rect, math.pi, math.pi * progress, false, fill);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress || old.strokeWidth != strokeWidth;
}
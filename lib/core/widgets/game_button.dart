import 'package:flutter/material.dart';
import 'package:quiz_app/core/sound/sound_service.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/angle_pill_border.dart';

enum GameButtonStyle { primary, secondary }

class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fontSize = 17,
    this.style = GameButtonStyle.primary,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final IconData? icon;
  final double fontSize;
  final GameButtonStyle style;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.style == GameButtonStyle.primary;
    final enabled = widget.onPressed != null;
    final foreground = isPrimary ? AppColors.navyDeep : AppColors.gold;
    final icon = widget.icon;

    // The outline is drawn by the Material, the fill by the Ink inside it.
    final outlinedShape = AnglePillBorder(
      side: BorderSide(
        color: isPrimary ? const Color.fromARGB(255, 138, 106, 0) : AppColors.gold,
        width: 2,
      ),
      tip: 24,
    );

    return AnimatedScale(
      scale: _pressed && enabled ? 0.97 : 1,
      duration: const Duration(milliseconds: 90),
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Material(
          color: Colors.transparent,
          elevation: isPrimary && enabled ? 8 : 0,
          shadowColor: AppColors.gold,
          shape: outlinedShape,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            height: 58,
            decoration: ShapeDecoration(
              shape: const AnglePillBorder(tip: 24),
              color: isPrimary ? null : AppColors.panel,
              gradient: isPrimary
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFE88A),
                        AppColors.gold,
                        Color(0xFFD9A600),
                      ],
                    )
                  : null,
            ),
            child: InkWell(
              onTap: widget.onPressed == null
                  ? null
                  : () {
                      playClick();
                      widget.onPressed!();
                    },
              onHighlightChanged: (value) => setState(() => _pressed = value),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: foreground),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label.toUpperCase(),
                      style: TextStyle(
                        color: foreground,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/angle_pill_tile.dart';

/// A list entry that starts a special kind of round (Random, Custom).
class RoundModeTile extends StatelessWidget {
  const RoundModeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnglePillTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.navyDeep,
        child: Icon(icon),
      ),
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      borderColor: AppColors.gold,
      titleColor: AppColors.gold,
    );
  }
}
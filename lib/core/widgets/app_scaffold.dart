import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';

/// A Scaffold on the app's navy background with a soft glow in the centre.
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, this.appBar, required this.body});

  final PreferredSizeWidget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.2),
          radius: 1.1,
          colors: [AppColors.navyGlow, AppColors.navy, AppColors.navyDeep],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Scaffold(appBar: appBar, body: body),
    );
  }
}
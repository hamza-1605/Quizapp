import 'package:flutter/material.dart';

abstract class AppColors {
  /// Main colour.
  static const navy = Color(0xFF001050);

  /// Secondary colour.
  static const gold = Color(0xFFFECF0E);

  // Shades derived from the navy, for the glow and for panels.
  static const navyGlow = Color(0xFF0A2578);
  static const navyDeep = Color(0xFF000829);
  static const panel = Color(0xFF0A1C6E);
  static const outline = Color(0xFF8FA3E8);
  static const textMuted = Color(0xFFB8C2F0);

  // Answer feedback.
  static const correct = Color(0xFF1E9E4A);
  static const wrong = Color(0xFFC62828);
  static const correctLight = Color(0xFF6FE39A);
  static const wrongLight = Color(0xFFFF8A8A);
}
import 'package:flutter/material.dart';

abstract class AppTheme {
  
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 5, 50)),
  );

}
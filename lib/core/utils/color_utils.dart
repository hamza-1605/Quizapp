import 'package:flutter/material.dart';

/// Converts "#RRGGBB" into a Color. Returns null if the value is missing
/// or not a valid hex colour.
Color? colorFromHex(String? hex) {
  if (hex == null) return null;
  
  final cleaned = hex.replaceFirst('#', '');
  if (cleaned.length != 6) return null;
  
  final value = int.tryParse(cleaned, radix: 16);
  return value == null ? null : Color(0xFF000000 | value);
}
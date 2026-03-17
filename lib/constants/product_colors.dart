import 'package:flutter/material.dart';

/// Color scheme cho cac loai san pham.
class ProductColors {
  static const Map<String, Color> colorMap = {
    'Do tuoi': Color(0xFFE53935),
    'Do': Color(0xFFE53935),
    'Vang': Color(0xFFFDD835),
    'Trang': Color(0xFF9E9E9E),
    'Hong': Color(0xFFEC407A),
    'Tim dam': Color(0xFF7B1FA2),
    'Tim': Color(0xFF7B1FA2),
    'Cam': Color(0xFFFB8C00),
    'Xanh la': Color(0xFF43A047),
    'Tim nhat': Color(0xFFAB47BC),
    'Da sac': Color(0xFFE91E63),
  };

  static const Map<String, Color> accentMap = {
    'Do tuoi': Color(0xFFB71C1C),
    'Do': Color(0xFFB71C1C),
    'Vang': Color(0xFFF57F17),
    'Trang': Color(0xFFE0E0E0),
    'Hong': Color(0xFFC2185B),
    'Tim dam': Color(0xFF4A148C),
    'Tim': Color(0xFF4A148C),
    'Cam': Color(0xFFE65100),
    'Xanh la': Color(0xFF1B5E20),
    'Tim nhat': Color(0xFF6A1B9A),
  };

  static Color getColor(String colorName) {
    return colorMap[colorName] ?? const Color(0xFFE91E63);
  }

  static Color getAccentColor(String colorName) {
    return accentMap[colorName] ?? const Color(0xFFC2185B);
  }
}

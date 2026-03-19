import 'package:flutter/material.dart';

/// Color scheme cho các loại hoa khác nhau
class FlowerColors {
  static const Map<String, Color> colorMap = {
    'Đỏ tươi': Color(0xFFE53935),
    'Đỏ': Color(0xFFE53935),
    'Vàng': Color(0xFFFDD835),
    'Trắng': Color(0xFF9E9E9E),
    'Hồng': Color(0xFFEC407A),
    'Tím đậm': Color(0xFF7B1FA2),
    'Tím': Color(0xFF7B1FA2),
    'Cam': Color(0xFFFB8C00),
    'Xanh lá': Color(0xFF43A047),
    'Tím nhạt': Color(0xFFAB47BC),
    'Đa sắc': Color(0xFFE91E63),
  };

  static const Map<String, Color> accentMap = {
    'Đỏ tươi': Color(0xFFB71C1C),
    'Vàng': Color(0xFFF57F17),
    'Trắng': Color(0xFFE0E0E0),
    'Hồng': Color(0xFFC2185B),
    'Tím đậm': Color(0xFF4A148C),
    'Cam': Color(0xFFE65100),
    'Xanh lá': Color(0xFF1B5E20),
    'Tím nhạt': Color(0xFF6A1B9A),
  };

  static Color getColor(String colorName) {
    return colorMap[colorName] ?? const Color(0xFFE91E63);
  }

  static Color getAccentColor(String colorName) {
    return accentMap[colorName] ?? const Color(0xFFC2185B);
  }
}

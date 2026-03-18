import 'package:flutter/material.dart';

/// Bang mau su dung trong app.
class ProductColors {
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
    'Đỏ': Color(0xFFB71C1C),
    'Vàng': Color(0xFFF57F17),
    'Trắng': Color(0xFFE0E0E0),
    'Hồng': Color(0xFFC2185B),
    'Tím đậm': Color(0xFF4A148C),
    'Tím': Color(0xFF4A148C),
    'Cam': Color(0xFFE65100),
    'Xanh lá': Color(0xFF1B5E20),
    'Tím nhạt': Color(0xFF6A1B9A),
  };

  static Color getColor(String colorName) {
    final normalized = _normalizeColorName(colorName);
    return colorMap[normalized] ?? const Color(0xFFE91E63);
  }

  static Color getAccentColor(String colorName) {
    final normalized = _normalizeColorName(colorName);
    return accentMap[normalized] ?? const Color(0xFFC2185B);
  }

  static String _normalizeColorName(String colorName) {
    switch (colorName.trim().toLowerCase()) {
      case 'do tuoi':
      case 'đỏ tươi':
        return 'Đỏ tươi';
      case 'do':
      case 'đỏ':
        return 'Đỏ';
      case 'vang':
      case 'vàng':
        return 'Vàng';
      case 'trang':
      case 'trắng':
        return 'Trắng';
      case 'hong':
      case 'hồng':
        return 'Hồng';
      case 'tim dam':
      case 'tím đậm':
        return 'Tím đậm';
      case 'tim':
      case 'tím':
        return 'Tím';
      case 'cam':
        return 'Cam';
      case 'xanh la':
      case 'xanh lá':
        return 'Xanh lá';
      case 'tim nhat':
      case 'tím nhạt':
        return 'Tím nhạt';
      case 'da sac':
      case 'đa sắc':
        return 'Đa sắc';
      default:
        return colorName;
    }
  }
}

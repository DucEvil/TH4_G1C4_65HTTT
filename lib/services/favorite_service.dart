import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  static const String _storageKey = 'favorite_product_ids';

  final ValueNotifier<Set<int>> favoriteIds = ValueNotifier(<int>{});
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_storageKey) ?? <String>[];
    favoriteIds.value = ids.map(int.tryParse).whereType<int>().toSet();
    _initialized = true;
  }

  bool isFavorite(int productId) => favoriteIds.value.contains(productId);

  int get totalFavorites => favoriteIds.value.length;

  Future<bool> toggleFavorite(int productId) async {
    final next = Set<int>.from(favoriteIds.value);
    final isNowFavorite = !next.contains(productId);
    if (isNowFavorite) {
      next.add(productId);
    } else {
      next.remove(productId);
    }
    favoriteIds.value = next;
    await _save();
    return isNowFavorite;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      favoriteIds.value.map((e) => e.toString()).toList(),
    );
  }
}




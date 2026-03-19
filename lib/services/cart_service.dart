import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';

enum CheckoutMode { selectedCartItems, directBuyNow }

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  static const String _cartStorageKey = 'th4_cart_items_v1';

  bool _isRestoring = false;
  List<CartItem> _checkoutItems = <CartItem>[];
  CheckoutMode? _checkoutMode;

  final ValueNotifier<List<CartItem>> items = ValueNotifier(<CartItem>[]);

  List<CartItem> get checkoutItems => List.unmodifiable(_checkoutItems);

  bool get hasCheckoutDraft => _checkoutItems.isNotEmpty;

  void _setItems(List<CartItem> nextItems) {
    items.value = nextItems;
    notifyListeners();
  }

  Future<void> init() async {
    await _restoreCart();
  }

  int get totalItems => items.value.fold(0, (sum, item) => sum + item.quantity);

  int get totalDistinctItems => items.value.length;

  double get totalPrice =>
      items.value.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isAllSelected =>
      items.value.isNotEmpty && items.value.every((item) => item.isSelected);

  List<CartItem> get selectedItems =>
      items.value.where((item) => item.isSelected).toList();

  double get selectedTotalPrice =>
      selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  Map<String, dynamic> _itemToJson(CartItem item) {
    return {
      'product': item.product.toJson(),
      'size': item.size,
      'color': item.color,
      'quantity': item.quantity,
      'isSelected': item.isSelected,
    };
  }

  CartItem _itemFromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>? ?? const {};
    return CartItem(
      product: Product.fromJson(productJson),
      size: json['size'] as String? ?? 'M',
      color: json['color'] as String? ?? 'Đen',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      isSelected: json['isSelected'] as bool? ?? true,
    );
  }

  Future<void> _persistCart() async {
    if (_isRestoring) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = items.value.map(_itemToJson).toList();
      await prefs.setString(_cartStorageKey, jsonEncode(payload));
    } catch (_) {
      // Ignore persistence errors and keep in-memory cart usable.
    }
  }

  Future<void> _restoreCart() async {
    _isRestoring = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cartStorageKey);
      if (raw == null || raw.isEmpty) {
        _setItems(<CartItem>[]);
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        await prefs.remove(_cartStorageKey);
        _setItems(<CartItem>[]);
        return;
      }

      final restored = <CartItem>[];
      for (final element in decoded) {
        if (element is Map<String, dynamic>) {
          restored.add(_itemFromJson(element));
          continue;
        }
        if (element is Map) {
          restored.add(_itemFromJson(Map<String, dynamic>.from(element)));
        }
      }

      _setItems(restored);
    } catch (_) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_cartStorageKey);
      } catch (_) {
        // Ignore cleanup errors.
      }
      _setItems(<CartItem>[]);
    } finally {
      _isRestoring = false;
    }
  }

  bool prepareCheckoutFromSelected() {
    final selected = selectedItems;
    if (selected.isEmpty) return false;
    _checkoutItems = List<CartItem>.from(selected);
    _checkoutMode = CheckoutMode.selectedCartItems;
    notifyListeners();
    return true;
  }

  void prepareCheckoutDirect(
    Product product, {
    required int quantity,
    required String size,
    required String color,
  }) {
    _checkoutItems = [
      CartItem(
        product: product,
        quantity: quantity,
        size: size,
        color: color,
        isSelected: true,
      ),
    ];
    _checkoutMode = CheckoutMode.directBuyNow;
    notifyListeners();
  }

  void clearCheckoutDraft() {
    _checkoutItems = <CartItem>[];
    _checkoutMode = null;
    notifyListeners();
  }

  void completeCheckoutAfterSuccess() {
    if (_checkoutMode == CheckoutMode.selectedCartItems) {
      final list = List<CartItem>.from(items.value);
      list.removeWhere((item) => item.isSelected);
      _setItems(list);
      _persistCart();
    }

    _checkoutItems = <CartItem>[];
    _checkoutMode = null;
    notifyListeners();
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    String size = 'M',
    String? color,
  }) {
    if (quantity <= 0 || product.quantity <= 0) return;
    final itemColor = color ?? product.color;
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere(
      (cartItem) =>
          cartItem.product.id == product.id &&
          cartItem.size == size &&
          cartItem.color == itemColor,
    );
    if (index >= 0) {
      final nextQuantity = math.min(
        list[index].quantity + quantity,
        product.quantity,
      );
      list[index].quantity = nextQuantity;
      list[index].isSelected = true;
    } else {
      final initialQuantity = math.min(quantity, product.quantity);
      list.add(
        CartItem(
          product: product,
          quantity: initialQuantity,
          size: size,
          color: itemColor,
          isSelected: true,
        ),
      );
    }
    _setItems(list);
    _persistCart();
  }

  void addToCartWithQuantity(
    Product product,
    int quantity, {
    String size = 'M',
    String? color,
  }) {
    addToCart(product, quantity: quantity, size: size, color: color);
  }

  void removeFromCart(int productId) {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => item.product.id == productId);
    _setItems(list);
    _persistCart();
  }

  void removeFromCartByKey(String cartKey) {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => item.cartKey == cartKey);
    _setItems(list);
    _persistCart();
  }

  void updateQuantity(String cartKey, int quantity) {
    if (quantity <= 0) {
      removeFromCartByKey(cartKey);
      return;
    }
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.cartKey == cartKey);
    if (index >= 0) {
      list[index].quantity = math.min(quantity, list[index].product.quantity);
      _setItems(list);
      _persistCart();
    }
  }

  void toggleSelection(String cartKey, bool isSelected) {
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.cartKey == cartKey);
    if (index >= 0) {
      list[index].isSelected = isSelected;
      _setItems(list);
      _persistCart();
    }
  }

  void toggleSelectAll(bool selected) {
    final list = List<CartItem>.from(items.value);
    for (final item in list) {
      item.isSelected = selected;
    }
    _setItems(list);
    _persistCart();
  }

  void removeSelectedItems() {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => item.isSelected);
    _setItems(list);
    _persistCart();
  }

  void clearCart() {
    _setItems([]);
    clearCheckoutDraft();
    _persistCart();
  }
}

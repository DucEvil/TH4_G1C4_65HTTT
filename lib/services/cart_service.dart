import 'package:flutter/foundation.dart';
import '../models/flower_model.dart';
import '../models/cart_item.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final ValueNotifier<List<CartItem>> items = ValueNotifier([]);

  int get totalItems => items.value.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.value.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(Flower flower) {
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.flower.id == flower.id);
    if (index >= 0) {
      list[index].quantity++;
    } else {
      list.add(CartItem(flower: flower));
    }
    items.value = list;
  }

  void removeFromCart(int flowerId) {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => item.flower.id == flowerId);
    items.value = list;
  }

  void updateQuantity(int flowerId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(flowerId);
      return;
    }
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.flower.id == flowerId);
    if (index >= 0) {
      list[index].quantity = quantity;
      items.value = list;
    }
  }

  void clearCart() {
    items.value = [];
  }

  void removeItemsByFlowerIds(List<int> flowerIds) {
    final setIds = flowerIds.toSet();
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => setIds.contains(item.flower.id));
    items.value = list;
  }
}

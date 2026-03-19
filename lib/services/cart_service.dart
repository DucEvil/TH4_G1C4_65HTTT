import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final ValueNotifier<List<CartItem>> items = ValueNotifier([]);

  int get totalItems => items.value.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.value.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(Product product) {
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      list[index].quantity++;
    } else {
      list.add(CartItem(product: product));
    }
    items.value = list;
  }

  void removeFromCart(int productId) {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((item) => item.product.id == productId);
    items.value = list;
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      list[index].quantity = quantity;
      items.value = list;
    }
  }

  void clearCart() {
    items.value = [];
  }
}




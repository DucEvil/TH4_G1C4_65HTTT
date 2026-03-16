import 'flower_model.dart';

class CartItem {
  final Flower flower;
  int quantity;

  CartItem({required this.flower, this.quantity = 1});

  double get totalPrice => flower.price * quantity;
}

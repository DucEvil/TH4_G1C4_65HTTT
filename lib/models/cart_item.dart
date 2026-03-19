import 'product_model.dart';

class CartItem {
  final Product product;
  final String size;
  final String color;
  bool isSelected;
  int quantity;

  CartItem({
    required Product product,
    this.quantity = 1,
    String? size,
    String? color,
    this.isSelected = true,
  }) : product = product,
       size = size ?? 'M',
       color = color ?? product.color;

  String get cartKey => '${product.id}_${size}_$color';

  double get totalPrice => product.price * quantity;
}

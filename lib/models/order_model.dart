enum OrderStatus { pending, shipping, delivered, cancelled }

class OrderItem {
  final int flowerId;
  final String flowerName;
  final String flowerImage;
  final double unitPrice;
  final int quantity;

  const OrderItem({
    required this.flowerId,
    required this.flowerName,
    required this.flowerImage,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;
}

class OrderModel {
  final String orderCode;
  final DateTime createdAt;
  final String shippingAddress;
  final String customerName;
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;

  const OrderModel({
    required this.orderCode,
    required this.createdAt,
    required this.shippingAddress,
    required this.customerName,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.items,
    required this.totalAmount,
    required this.status,
  });
}

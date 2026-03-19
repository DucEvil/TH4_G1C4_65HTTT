enum OrderStatus { pending, shipping, delivered, cancelled }

OrderStatus orderStatusFromName(String? name) {
  return OrderStatus.values.firstWhere(
    (value) => value.name == name,
    orElse: () => OrderStatus.pending,
  );
}

class OrderItem {
  final int productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      productName: json['productName'] as String? ?? '',
      productImage: json['productImage'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'unitPrice': unitPrice,
    'quantity': quantity,
  };

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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderCode: json['orderCode'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      shippingAddress: json['shippingAddress'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                OrderItem.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: orderStatusFromName(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'orderCode': orderCode,
    'createdAt': createdAt.toIso8601String(),
    'shippingAddress': shippingAddress,
    'customerName': customerName,
    'phoneNumber': phoneNumber,
    'paymentMethod': paymentMethod,
    'items': items.map((item) => item.toJson()).toList(),
    'totalAmount': totalAmount,
    'status': status.name,
  };
}

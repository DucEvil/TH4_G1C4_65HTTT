import 'package:flutter/foundation.dart';

import '../models/order_model.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  final ValueNotifier<List<OrderModel>> orders = ValueNotifier([]);

  void addOrder(OrderModel order) {
    final list = List<OrderModel>.from(orders.value);
    list.insert(0, order);
    orders.value = list;
  }

  List<OrderModel> getByStatus(OrderStatus status) {
    return orders.value.where((order) => order.status == status).toList();
  }
}

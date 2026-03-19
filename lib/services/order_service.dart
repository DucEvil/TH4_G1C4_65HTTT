import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  static const String _ordersStorageKey = 'th4_orders_v1';
  bool _isRestoring = false;

  final ValueNotifier<List<OrderModel>> orders = ValueNotifier([]);

  Future<void> init() async {
    await _restoreOrders();
  }

  Future<void> _persistOrders() async {
    if (_isRestoring) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = orders.value.map((item) => item.toJson()).toList();
      await prefs.setString(_ordersStorageKey, jsonEncode(payload));
    } catch (_) {
      // Ignore persistence errors and keep in-memory orders usable.
    }
  }

  Future<void> _restoreOrders() async {
    _isRestoring = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_ordersStorageKey);
      if (raw == null || raw.isEmpty) {
        orders.value = [];
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        await prefs.remove(_ordersStorageKey);
        orders.value = [];
        return;
      }

      final restored = <OrderModel>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          restored.add(OrderModel.fromJson(item));
          continue;
        }
        if (item is Map) {
          restored.add(OrderModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      orders.value = restored;
    } catch (_) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_ordersStorageKey);
      } catch (_) {
        // Ignore cleanup errors.
      }
      orders.value = [];
    } finally {
      _isRestoring = false;
    }
  }

  void addOrder(OrderModel order) {
    final list = List<OrderModel>.from(orders.value);
    list.insert(0, order);
    orders.value = list;
    _persistOrders();
  }

  List<OrderModel> getByStatus(OrderStatus status) {
    return orders.value.where((order) => order.status == status).toList();
  }
}

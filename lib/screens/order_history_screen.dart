import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const _primaryPink = Color(0xFFE91E63);
  static final _priceFormat = NumberFormat('#,###', 'vi_VN');
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  String _formatPrice(double value) => '${_priceFormat.format(value.toInt())}đ';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              bottom: 8,
            ),
            color: _primaryPink,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    'Đơn mua',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: 'Chờ xác nhận'),
                    Tab(text: 'Đang giao'),
                    Tab(text: 'Đã giao'),
                    Tab(text: 'Đã hủy'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<OrderModel>>(
              valueListenable: OrderService.instance.orders,
              builder: (_, __, ___) {
                return TabBarView(
                  children: [
                    _buildOrderList(OrderStatus.pending),
                    _buildOrderList(OrderStatus.shipping),
                    _buildOrderList(OrderStatus.delivered),
                    _buildOrderList(OrderStatus.cancelled),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(OrderStatus status) {
    final orders = OrderService.instance.getByStatus(status);
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'Chưa có đơn hàng nào',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final order = orders[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mã đơn: ${order.orderCode}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    _dateFormat.format(order.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Người nhận: ${order.customerName} - ${order.phoneNumber}'),
              const SizedBox(height: 4),
              Text('Địa chỉ: ${order.shippingAddress}'),
              const SizedBox(height: 4),
              Text('Thanh toán: ${order.paymentMethod}'),
              const Divider(height: 18),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${item.productName} x${item.quantity} - ${_formatPrice(item.totalPrice)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Divider(height: 18),
              Row(
                children: [
                  const Text('Tổng đơn:'),
                  const Spacer(),
                  Text(
                    _formatPrice(order.totalAmount),
                    style: const TextStyle(
                      color: _primaryPink,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

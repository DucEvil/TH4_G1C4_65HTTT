import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onOrderPlaced;

  const CartScreen({super.key, this.onOrderPlaced});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _primaryPink = Color(0xFFE91E63);
  static final _priceFormat = NumberFormat('#,###', 'vi_VN');

  final Set<int> _selectedFlowerIds = {};

  @override
  void initState() {
    super.initState();
    CartService.instance.items.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    CartService.instance.items.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    final currentIds = CartService.instance.items.value
        .map((item) => item.flower.id)
        .toSet();
    _selectedFlowerIds.removeWhere((id) => !currentIds.contains(id));
  }

  String _formatPrice(double price) {
    return '${_priceFormat.format(price.toInt())}đ';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartService.instance.items,
      builder: (context, cartItems, _) {
        final selectedItems = cartItems
            .where((item) => _selectedFlowerIds.contains(item.flower.id))
            .toList();
        final selectedTotal = selectedItems.fold(
          0.0,
          (sum, item) => sum + item.totalPrice,
        );
        final isAllSelected =
            cartItems.isNotEmpty && selectedItems.length == cartItems.length;

        if (cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Giỏ hàng trống',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hãy thêm hoa vào giỏ hàng nhé!',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          );
        }

        final cart = CartService.instance;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 10,
                right: 16,
                bottom: 12,
              ),
              color: _primaryPink,
              child: Row(
                children: [
                  Checkbox(
                    value: isAllSelected,
                    onChanged: (_) {
                      setState(() {
                        if (isAllSelected) {
                          _selectedFlowerIds.clear();
                        } else {
                          _selectedFlowerIds
                            ..clear()
                            ..addAll(cartItems.map((item) => item.flower.id));
                        }
                      });
                    },
                    side: const BorderSide(color: Colors.white70),
                    checkColor: _primaryPink,
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.transparent;
                    }),
                  ),
                  const Icon(Icons.shopping_cart, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Giỏ hàng (${cart.totalItems})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showClearConfirm(context),
                    child: const Text(
                      'Xóa tất cả',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return _buildCartItem(
                    context,
                    item,
                    isSelected: _selectedFlowerIds.contains(item.flower.id),
                    onSelectChanged: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedFlowerIds.add(item.flower.id);
                        } else {
                          _selectedFlowerIds.remove(item.flower.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      Text(
                        _formatPrice(selectedTotal),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _primaryPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () async {
                          if (selectedItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Vui lòng tick sản phẩm để thanh toán',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }

                          final result = await Navigator.push<CheckoutResult>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                selectedItems: selectedItems
                                    .map(
                                      (item) => CartItem(
                                        flower: item.flower,
                                        quantity: item.quantity,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );

                          if (!context.mounted || result == null) {
                            return;
                          }

                          OrderService.instance.addOrder(result.order);
                          CartService.instance.removeItemsByFlowerIds(
                            result.purchasedFlowerIds,
                          );
                          setState(() {
                            _selectedFlowerIds.removeAll(result.purchasedFlowerIds);
                          });
                          widget.onOrderPlaced?.call();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Thanh toán',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item, {
    required bool isSelected,
    required ValueChanged<bool> onSelectChanged,
  }) {
    final flower = item.flower;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) => onSelectChanged(value ?? false),
            activeColor: _primaryPink,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: flower.image.isNotEmpty
                  ? Image.network(
                      flower.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.pink.shade50,
                        child: const Icon(
                          Icons.local_florist,
                          color: _primaryPink,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.pink.shade50,
                      child: const Icon(
                        Icons.local_florist,
                        color: _primaryPink,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flower.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatPrice(flower.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryPink,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _quantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        CartService.instance.updateQuantity(
                          flower.id,
                          item.quantity - 1,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _quantityButton(
                      icon: Icons.add,
                      onTap: () {
                        CartService.instance.updateQuantity(
                          flower.id,
                          item.quantity + 1,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
            onPressed: () {
              CartService.instance.removeFromCart(flower.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa ${flower.name} khỏi giỏ hàng'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content: const Text('Bạn có chắc muốn xóa tất cả sản phẩm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              CartService.instance.clearCart();
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: _primaryPink),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
  }
}

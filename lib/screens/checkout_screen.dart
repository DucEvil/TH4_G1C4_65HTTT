import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';

class CheckoutResult {
  final String orderCode;
  final List<int> purchasedProductIds;
  final OrderModel order;

  const CheckoutResult({
    required this.orderCode,
    required this.purchasedProductIds,
    required this.order,
  });
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _primaryPink = Color(0xFFE91E63);
  static final _priceFormat = NumberFormat('#,###', 'vi_VN');

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cod;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatPrice(double value) => '${_priceFormat.format(value.toInt())}đ';

  String _paymentMethodLabel(PaymentMethod method) {
    return method == PaymentMethod.cod ? 'COD' : 'MoMo';
  }

  Future<void> _submitPayment() async {
    final cart = context.read<CartService>();
    final checkoutItems = cart.checkoutItems;
    final subtotal = checkoutItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    if (checkoutItems.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có sản phẩm để thanh toán'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final request = CheckoutRequest(
      customerName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      shippingAddress: _addressController.text.trim(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text,
      paymentMethod: _paymentMethod,
      subtotal: subtotal,
    );

    final result = await PaymentService.instance.processPayment(request);

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final order = OrderModel(
      orderCode: result.orderCode,
      createdAt: DateTime.now(),
      shippingAddress: _addressController.text.trim(),
      customerName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      paymentMethod: _paymentMethodLabel(_paymentMethod),
      items: checkoutItems
          .map(
            (item) => OrderItem(
              productId: item.product.id,
              productName: item.product.name,
              productImage: item.product.image,
              unitPrice: item.product.price,
              quantity: item.quantity,
            ),
          )
          .toList(),
      totalAmount: subtotal,
      status: OrderStatus.pending,
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đặt hàng thành công'),
        content: Text('Mã đơn hàng: ${result.orderCode}'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: FilledButton.styleFrom(backgroundColor: _primaryPink),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    OrderService.instance.addOrder(order);
    cart.completeCheckoutAfterSuccess();

    Navigator.pop(
      context,
      CheckoutResult(
        orderCode: result.orderCode,
        purchasedProductIds: checkoutItems
            .map((item) => item.product.id)
            .toList(),
        order: order,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();
    final checkoutItems = cart.checkoutItems;
    final subtotal = checkoutItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: checkoutItems.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 72,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Chưa có sản phẩm để thanh toán',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin nhận hàng',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      icon: Icons.person_outline,
                      validatorMessage: 'Vui lòng nhập họ tên',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validatorMessage: 'Vui lòng nhập số điện thoại',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Địa chỉ nhận hàng',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validatorMessage: 'Vui lòng nhập địa chỉ nhận hàng',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _noteController,
                      label: 'Ghi chú (không bắt buộc)',
                      icon: Icons.edit_note,
                      maxLines: 2,
                      validatorMessage: '',
                      isOptional: true,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<PaymentMethod>(
                      value: PaymentMethod.cod,
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _paymentMethod = value);
                      },
                      title: const Text('COD (nhận hàng rồi thanh toán)'),
                      secondary: const Icon(Icons.local_shipping_outlined),
                      activeColor: _primaryPink,
                    ),
                    RadioListTile<PaymentMethod>(
                      value: PaymentMethod.momo,
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _paymentMethod = value);
                      },
                      title: const Text('Chuyển khoản MoMo'),
                      secondary: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      activeColor: _primaryPink,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Sản phẩm đã chọn'),
                              const Spacer(),
                              Text('${checkoutItems.length} món'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Tổng thanh toán',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                _formatPrice(subtotal),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submitPayment,
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryPink,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Đặt hàng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: isOptional
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) {
                return validatorMessage;
              }
              if (keyboardType == TextInputType.phone &&
                  value.trim().length < 9) {
                return 'Số điện thoại chưa hợp lệ';
              }
              return null;
            },
    );
  }
}

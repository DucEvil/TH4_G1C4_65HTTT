import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

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

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double get _subtotal => widget.cartItems.fold(
    0.0,
    (sum, item) => sum + item.totalPrice,
  );

  double get _shippingFee => 0;

  double get _discount => _subtotal >= 1000000 ? _subtotal * 0.1 : 0;

  double get _total => _subtotal + _shippingFee - _discount;

  String _formatPrice(double value) {
    return '${_priceFormat.format(value.toInt())}đ';
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final request = CheckoutRequest(
      customerName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      shippingAddress: _addressController.text.trim(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text,
      paymentMethod: PaymentMethod.cod,
      subtotal: _subtotal,
      shippingFee: _shippingFee,
      discount: _discount,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    CartService.instance.clearCart();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Thanh toán thành công'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result.message),
              const SizedBox(height: 8),
              Text(
                'Mã đơn hàng: ${result.orderCode}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(backgroundColor: _primaryPink),
              child: const Text('Đã hiểu'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Xác nhận thanh toán'),
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Thông tin nhận hàng'),
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
                    _buildSectionTitle('Phương thức thanh toán'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.local_shipping_outlined, color: _primaryPink),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thanh toán khi nhận hàng (COD)',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2),
                                Text('Đơn hàng chỉ hỗ trợ COD'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Chi tiết thanh toán'),
                    const SizedBox(height: 8),
                    _buildSummaryCard(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
              if (keyboardType == TextInputType.phone && value.trim().length < 9) {
                return 'Số điện thoại chưa hợp lệ';
              }
              return null;
            },
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _summaryRow('Tạm tính', _formatPrice(_subtotal)),
          _summaryRow('Phí vận chuyển', _formatPrice(_shippingFee)),
          _summaryRow(
            'Giảm giá',
            '-${_formatPrice(_discount)}',
            valueColor: Colors.green.shade700,
          ),
          const Divider(height: 22),
          _summaryRow(
            'Tổng thanh toán',
            _formatPrice(_total),
            isTotal: true,
            valueColor: _primaryPink,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: _isSubmitting ? null : _submitPayment,
            style: FilledButton.styleFrom(
              backgroundColor: _primaryPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                : Text(
                    'Xác nhận thanh toán ${_formatPrice(_total)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

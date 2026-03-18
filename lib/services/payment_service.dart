import 'dart:math';

enum PaymentMethod { cod, bankTransfer, eWallet }

class CheckoutRequest {
  final String customerName;
  final String phoneNumber;
  final String shippingAddress;
  final String? note;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;

  const CheckoutRequest({
    required this.customerName,
    required this.phoneNumber,
    required this.shippingAddress,
    this.note,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
  });

  double get totalAmount => subtotal + shippingFee - discount;
}

class PaymentResult {
  final bool isSuccess;
  final String message;
  final String orderCode;

  const PaymentResult({
    required this.isSuccess,
    required this.message,
    required this.orderCode,
  });
}

class PaymentService {
  PaymentService._();
  static final PaymentService instance = PaymentService._();

  Future<PaymentResult> processPayment(CheckoutRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (request.customerName.trim().isEmpty ||
        request.phoneNumber.trim().isEmpty ||
        request.shippingAddress.trim().isEmpty) {
      return const PaymentResult(
        isSuccess: false,
        message: 'Vui lòng nhập đầy đủ thông tin nhận hàng.',
        orderCode: '',
      );
    }

    if (request.totalAmount <= 0) {
      return const PaymentResult(
        isSuccess: false,
        message: 'Tổng thanh toán không hợp lệ.',
        orderCode: '',
      );
    }

    if (request.paymentMethod != PaymentMethod.cod) {
      return const PaymentResult(
        isSuccess: false,
        message: 'Hệ thống hiện chỉ hỗ trợ thanh toán COD.',
        orderCode: '',
      );
    }

    final orderCode = _generateOrderCode();

    return PaymentResult(
      isSuccess: true,
      message: 'Thanh toán thành công. Đơn hàng của bạn đang được xử lý.',
      orderCode: orderCode,
    );
  }

  String _generateOrderCode() {
    final now = DateTime.now();
    final random = Random().nextInt(900) + 100;
    return 'DH${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}$random';
  }
}

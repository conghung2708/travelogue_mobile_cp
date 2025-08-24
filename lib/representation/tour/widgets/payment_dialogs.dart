// lib/features/tour/presentation/widgets/payment_dialogs.dart
import 'package:flutter/material.dart';

class PaymentDialogs {
  static Future<void> showError(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }

  static Future<void> showExpired(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hết thời gian'),
        content: const Text('Thời gian thanh toán đã hết. Vui lòng quay lại.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showLeaveConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn rời khỏi trang thanh toán?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rời khỏi'),
          ),
        ],
      ),
    );
  }
}

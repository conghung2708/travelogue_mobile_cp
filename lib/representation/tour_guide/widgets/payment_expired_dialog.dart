import 'package:flutter/material.dart';

Future<void> showPaymentExpiredDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Hết thời gian"),
      content: const Text("Thời gian thanh toán đã hết. Vui lòng quay lại."),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Text("Quay lại"),
        ),
      ],
    ),
  );
}

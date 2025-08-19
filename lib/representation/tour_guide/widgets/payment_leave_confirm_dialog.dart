import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

Future<bool> showLeaveConfirmDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
}) async {
  final result = await showDialog<bool>(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primaryColor,
          ),
          child: const Text('Rời khỏi', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (result == true) onConfirm();
  return false;
}

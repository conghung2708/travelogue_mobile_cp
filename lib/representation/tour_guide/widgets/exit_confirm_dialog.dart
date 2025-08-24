import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class ExitConfirmDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Huỷ đặt hướng dẫn viên?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            "Bạn có chắc chắn muốn quay lại và huỷ đặt hướng dẫn viên này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đồng ý", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

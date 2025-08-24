import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class ConfirmTotalBar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final num guideDailyPrice;
  final NumberFormat currencyFormat;
  final ValueListenable<bool> acceptedListenable;
  final VoidCallback onConfirm;

  const ConfirmTotalBar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.guideDailyPrice,
    required this.currencyFormat,
    required this.acceptedListenable,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final totalDays = endDate.difference(startDate).inDays + 1;
    final totalPrice = totalDays * (guideDailyPrice.toDouble());

    return ValueListenableBuilder<bool>(
      valueListenable: acceptedListenable,
      builder: (_, accepted, __) => Row(
        children: [
          Expanded(
            child: Text(
              "Tổng $totalDays ngày: ${currencyFormat.format(totalPrice)}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: accepted ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.4.h),
              backgroundColor: ColorPalette.primaryColor,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              elevation: 5,
            ),
            child: Text(
              "Xác nhận",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5.sp,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

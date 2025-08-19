// lib/features/tour/presentation/widgets/payment_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class PaymentHeader extends StatelessWidget {
  final DateTime? startTime;
  const PaymentHeader({super.key, this.startTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Thông tin thanh toán',
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 0.5.h),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'vi_VN').format(startTime ?? DateTime.now()),
                  style: TextStyle(fontSize: 15.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(width: 25.sp),
        ],
      ),
    );
  }
}

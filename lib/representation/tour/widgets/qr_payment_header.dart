import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/representation/tour/widgets/countdown_chip.dart';

class QrPaymentHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Duration remaining;

  const QrPaymentHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white30, width: 1.2),
            ),
            child: Icon(Icons.qr_code_rounded,
                size: 32.sp, color: Colors.white),
          ),

          SizedBox(height: 1.5.h),

          // Tiêu đề
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: 0.8.h),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5.sp,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 2.h),

          // CountdownChip
          CountdownChip(remaining: remaining),
        ],
      ),
    );
  }
}

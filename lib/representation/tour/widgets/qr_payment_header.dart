
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'countdown_chip.dart';

class QrPaymentHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Duration remaining;
  final Future<void> Function()? onBackPressed;

  const QrPaymentHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.remaining,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () async => await onBackPressed?.call(),
              ),
              const Spacer(),
            ],
          ),
          Icon(Icons.web_rounded, size: 32.sp, color: Colors.white),
          SizedBox(height: 1.h),
          Text(title,
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 0.6.h),
          Text(subtitle,
              style: TextStyle(fontSize: 15.sp, color: Colors.white70)),
          SizedBox(height: 1.h),
          CountdownChip(remaining: remaining),
        ],
      ),
    );
  }
}

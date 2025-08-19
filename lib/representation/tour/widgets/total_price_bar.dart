import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TotalPriceBar extends StatelessWidget {
  final String totalPriceText;
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;

  const TotalPriceBar({
    super.key,
    required this.totalPriceText,
    required this.buttonText,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.attach_money_rounded, color: Colors.white),
              SizedBox(width: 2.w),
              Text(
                totalPriceText,
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.8.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(buttonText, style: const TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

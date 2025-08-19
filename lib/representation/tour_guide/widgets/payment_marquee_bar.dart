
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

class PaymentMarqueeBar extends StatelessWidget {
  final String text;
  const PaymentMarqueeBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Marquee(
          text: text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.blueAccent,
          ),
          velocity: 30,
        ),
      ),
    );
  }
}

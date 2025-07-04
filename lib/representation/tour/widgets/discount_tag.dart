import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DiscountTag extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const DiscountTag({
    super.key,
    this.text = 'GIẢM GIÁ!',
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

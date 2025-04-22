import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RatingButtonWidget extends StatelessWidget {
  final double rating;
  final VoidCallback onTap;

  const RatingButtonWidget({
    super.key,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 3.w),
              Icon(Icons.edit_note_rounded,
                  color: Colors.blueAccent, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}

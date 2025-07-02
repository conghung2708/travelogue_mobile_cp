import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TourScheduleHeader extends StatelessWidget {
  final VoidCallback onBack;

  const TourScheduleHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1.5.w),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18.sp, color: Colors.black),
          ),
        ),
        const Spacer(),
        Text(
          'Chọn ngày khởi hành',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        SizedBox(width: 10.w),
      ],
    );
  }
}

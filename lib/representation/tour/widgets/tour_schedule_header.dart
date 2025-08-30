import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TourScheduleHeader extends StatelessWidget {
  final VoidCallback onBack;

  const TourScheduleHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1.8.w),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: Colors.black,
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Text(
              'Chọn ngày khởi hành',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: .2,
              ),
            ),
          ),
        ),


        SizedBox(width: 5.5.w),
      ],
    );
  }
}

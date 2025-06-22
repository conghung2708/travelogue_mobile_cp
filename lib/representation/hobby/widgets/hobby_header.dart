import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HobbyHeader extends StatelessWidget {
  const HobbyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sở thích của bạn là?",
            style: TextStyle(
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontFamily: "Pattaya",
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            "Hãy chọn những gì bạn yêu thích để cá nhân hóa trải nghiệm của bạn.",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.blue[300],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

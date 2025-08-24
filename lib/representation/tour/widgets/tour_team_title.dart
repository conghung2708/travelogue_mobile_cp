import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TourTeamTitle extends StatelessWidget {
  const TourTeamTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nhập thông tin người tham gia",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 1.h),
        Text("Giúp chúng tôi chuẩn bị tốt hơn cho nhóm của bạn.",
            style: TextStyle(fontSize: 12.5.sp, color: Colors.white70)),
      ],
    );
  }
}

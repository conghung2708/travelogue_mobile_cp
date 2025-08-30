import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class MotivationBanner extends StatelessWidget {
  const MotivationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 20.h,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            image: const DecorationImage(
              image: AssetImage(AssetHelper.img_nui_ba_den_1),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
        ),
        Container(
          height: 20.h,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.55), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          left: 5.w,
          bottom: 3.h,
          right: 5.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "“Mỗi cuộc hành trình là một trang ký ức”",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 2)
                  ],
                ),
              ),
              Text(
                "Hãy chọn chuyến du lịch phù hợp với bạn!",
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

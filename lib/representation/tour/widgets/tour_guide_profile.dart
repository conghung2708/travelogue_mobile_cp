import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_guide_model.dart';

class TourGuideProfile extends StatelessWidget {
  final TourGuideModel guide;

  const TourGuideProfile({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final avatar = guide.avatarUrl?.isNotEmpty == true
        ? NetworkImage(guide.avatarUrl!)
        : const AssetImage(AssetHelper.img_logo_travelogue) as ImageProvider;

    final rating = guide.rating ?? 0.0;

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
            side: BorderSide(color: Colors.lightBlue.shade100, width: 1),
          ),
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28.sp,
                  backgroundImage: avatar,
                ),
                SizedBox(height: 2.h),
                Text(
                  guide.userName ?? 'Hướng dẫn viên',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  guide.sexText ?? '---',
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 1.h),
                if (guide.introduction?.isNotEmpty == true)
                  Text(
                    guide.introduction!,
                    style: TextStyle(fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
                if (guide.introduction?.isNotEmpty == true) SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16.sp),
                    SizedBox(width: 1.w),
                    Text(
                      '$rating điểm đánh giá',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    if (guide.price != null) ...[
                      SizedBox(width: 3.w),
                      Icon(Icons.attach_money, color: Colors.green, size: 15.sp),
                      Text(
                        '${guide.price} VNĐ/ngày',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),

        if (rating > 4.5)
          Positioned(
            top: 10,
            right: 18,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, size: 11.sp, color: Colors.white),
                  SizedBox(width: 1.w),
                  Text(
                    'Đã xác thực',
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

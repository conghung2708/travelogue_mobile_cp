import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourGuideProfileCard extends StatelessWidget {
  final TourGuideModel guide;

  const TourGuideProfileCard({super.key, required this.guide});
  bool get isVerified =>
      (guide.averageRating ?? 0) >= 4.5 ||
      (guide.userName?.toLowerCase() == 'travelogue');

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: EdgeInsets.all(2.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isVerified
                        ? Border.all(color: Colors.green, width: 2.5)
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 28.sp,
                    backgroundImage: guide.avatarUrl != null
                        ? NetworkImage(guide.avatarUrl!)
                        : const AssetImage("assets/images/default_avatar.png")
                            as ImageProvider,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  guide.userName ?? 'Không rõ tên',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                if (guide.sexText != null)
                  Text(guide.sexText!, style: TextStyle(fontSize: 14.sp)),
                if (guide.address != null)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Text(
                      guide.address!,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (guide.introduction != null)
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      guide.introduction!,
                      style: TextStyle(fontSize: 13.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16.sp),
                    SizedBox(width: 1.w),
                    Text(
                      '${guide.averageRating?.toStringAsFixed(1) ?? "0.0"} '
                      '(${guide.totalReviews ?? 0} đánh giá)',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isVerified)
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
                  Text('Đã xác thực',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

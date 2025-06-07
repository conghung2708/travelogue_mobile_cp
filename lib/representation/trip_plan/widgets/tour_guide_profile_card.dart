import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

class TourGuideProfileCard extends StatelessWidget {
  final TourGuideTestModel guide;

  const TourGuideProfileCard({super.key, required this.guide});

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
                CircleAvatar(
                  radius: 28.sp,
                  backgroundImage: AssetImage(guide.avatarUrl),
                ),
                SizedBox(height: 2.h),
                Text(
                  guide.name,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                Text('${guide.age} tuổi - ${_genderText(guide.gender)}',
                    style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 1.h),
                Text(
                  guide.bio,
                  style: TextStyle(fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),

             
                Wrap(
                  spacing: 6,
                  alignment: WrapAlignment.center,
                  children: guide.tags.map((tag) {
                    final icon = _tagToIcon(tag);
                    return Chip(
                      avatar: Icon(icon, size: 14.sp, color: Colors.blue),
                      label:
                          Text(tag, style: TextStyle(fontSize: 12.sp)),
                      backgroundColor: Colors.lightBlue.shade50,
                    );
                  }).toList(),
                ),

                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16.sp),
                    SizedBox(width: 1.w),
                    Text('${guide.rating} (${guide.reviewsCount} đánh giá)',
                        style: TextStyle(fontSize: 13.sp)),
                    SizedBox(width: 2.w),
                    if (guide.isAvailable)
                      Text('Sẵn sàng',
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),

  
        if (guide.rating > 4.5)
          Positioned(
            top: 10,
            right: 18,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, size: 11.sp, color: Colors.white),
                  SizedBox(width: 1.w),
                  Text('Verified',
                      style:
                          TextStyle(fontSize: 10.sp, color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _genderText(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      default:
        return 'Khác';
    }
  }

  IconData _tagToIcon(String tag) {
    final lower = tag.toLowerCase();
    if (lower.contains('nhiệt') || lower.contains('năng')) return Icons.wb_sunny;
    if (lower.contains('vui')) return Icons.emoji_emotions;
    if (lower.contains('lịch sự') || lower.contains('lịch thiệp')) return Icons.handshake;
    if (lower.contains('kinh nghiệm')) return Icons.school;
    if (lower.contains('thân thiện')) return Icons.people_alt;
    return Icons.label; 
  }
}

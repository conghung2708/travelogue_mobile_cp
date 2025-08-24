// lib/features/tour/presentation/widgets/tour_mood_card.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TourMoodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String backgroundAsset;

  const TourMoodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.backgroundAsset,
  });

  factory TourMoodCard.solo({required VoidCallback onTap}) => TourMoodCard(
        title: "Tôi muốn tự do trải nghiệm",
        subtitle: "Tự do khám phá theo nhịp sống riêng của bạn.",
        description:
            "Nếu bạn muốn tận hưởng không gian một mình, không phụ thuộc lịch trình người khác – đây là lựa chọn lý tưởng.",
        icon: Icons.person_outline,
        color: Colors.deepPurple,
        onTap: onTap,
        backgroundAsset: AssetHelper.img_dien_son_01,
      );

  factory TourMoodCard.group({required VoidCallback onTap}) => TourMoodCard(
        title: "Tôi muốn đồng hành cùng người khác",
        subtitle: "Gắn kết, chia sẻ và tạo nên kỷ niệm cùng nhau.",
        description:
            "Nếu bạn yêu thích kết nối, chia sẻ khoảnh khắc và khám phá cùng bạn đồng hành – lựa chọn này là dành cho bạn.",
        icon: Icons.groups_3_rounded,
        color: Colors.teal,
        onTap: onTap,
        backgroundAsset: AssetHelper.img_bo_ke_01,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: EdgeInsets.only(bottom: 3.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            opacity: 0.04,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              padding: EdgeInsets.all(3.2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 24.sp, color: color),
            ),
            SizedBox(width: 4.w),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.8.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

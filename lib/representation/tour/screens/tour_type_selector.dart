import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/tour_schedule_helper.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_test_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_schedule_calender_screen.dart';
import 'package:travelogue_mobile/representation/widgets/animatied_entrance.dart';

class TourTypeSelector extends StatelessWidget {
  static const String routeName = '/tour-type-selector';

  final TourTestModel tour;

  const TourTypeSelector({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 100.h,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  AssetHelper.img_tour_type_selector,
                  fit: BoxFit.cover,
                  height: 100.h,
                  width: double.infinity,
                ),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(1.5.w),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 22, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Bạn đang tìm kiếm điều gì cho chuyến đi này?",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Hãy chọn hành trình phù hợp với tâm trạng của bạn.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5.h),

                  /// Card 1 – Đi lẻ
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 200),
                    child: _buildMoodCard(
                      context,
                      title: "Tôi muốn tự do trải nghiệm",
                      subtitle: "Tự do khám phá theo nhịp sống riêng của bạn.",
                      description:
                          "Nếu bạn muốn tận hưởng không gian một mình, không phụ thuộc lịch trình người khác – đây là lựa chọn lý tưởng.",
                      icon: Icons.person_outline,
                      color: Colors.deepPurple,
                      onTap: () {
                        final versions = mockTourPlanVersions
                            .where((v) => v.tourId == tour.id && v.isActive && !v.isDeleted)
                            .toList();

                        versions.sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
                        final latestVersion = versions.isNotEmpty ? versions.first : null;

                        final scheduleWithPriceList = combineScheduleWithPrice(
                          schedules: mockTourSchedules,
                          versions: latestVersion != null ? [latestVersion] : [],
                        );

                        Navigator.pushNamed(
                          context,
                          TourScheduleCalendarScreen.routeName,
                          arguments: TourCalendarArgs(
                            tour: tour,
                            schedules: scheduleWithPriceList,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  /// Card 2 – Đi theo đoàn
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 600),
                    child: _buildMoodCard(
                      context,
                      title: "Tôi muốn đồng hành cùng người khác",
                      subtitle: "Gắn kết, chia sẻ và tạo nên kỷ niệm cùng nhau.",
                      description:
                          "Nếu bạn yêu thích kết nối, chia sẻ khoảnh khắc và khám phá cùng bạn đồng hành – lựa chọn này là dành cho bạn.",
                      icon: Icons.groups_3_rounded,
                      color: Colors.teal,
                      onTap: () => Navigator.pop(context, "Đi theo đoàn"),
                    ),
                  ),

                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Text(
                        '✨ Travelogue – nơi mỗi hành trình trở thành một chương ký ức của riêng bạn.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
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
            image: AssetImage(
              icon == Icons.person_outline
                  ? AssetHelper.img_dien_son_01
                  : AssetHelper.img_bo_ke_01,
            ),
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            opacity: 0.04,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

// lib/features/tour/presentation/screens/tour_type_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_schedule_calender_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_mood_card.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_selector_background.dart';
import 'package:travelogue_mobile/representation/widgets/animatied_entrance.dart';


class TourTypeSelector extends StatelessWidget {
  static const String routeName = '/tour-type-selector';

  final TourModel tour;
  const TourTypeSelector({super.key, required this.tour});


  static Route<dynamic> routeFromSettings(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    final parsedTour = TourModel.fromJson(args['tour']);
    return MaterialPageRoute(builder: (_) => TourTypeSelector(tour: parsedTour));
  }

  void _goToCalendar(BuildContext context, {required bool isGroupTour}) {
    final schedules = tour.schedules;
    if (schedules == null || schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tour này chưa có lịch trình.')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      TourScheduleCalendarScreen.routeName,
      arguments: TourCalendarArgs(
        tour: tour,
        schedules: schedules,
        isGroupTour: isGroupTour,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const TourSelectorBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back
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

                  // Title
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
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),

                  SizedBox(height: 5.h),

                
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 200),
                    child: TourMoodCard.solo(
                      onTap: () => _goToCalendar(context, isGroupTour: false),
                    ),
                  ),

                  SizedBox(height: 3.h),

                
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 600),
                    child: TourMoodCard.group(
                      onTap: () => _goToCalendar(context, isGroupTour: true),
                    ),
                  ),

                  const Spacer(),

                  // Footer
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
}

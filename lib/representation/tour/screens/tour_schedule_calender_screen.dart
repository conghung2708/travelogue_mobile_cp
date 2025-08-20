// lib/features/tour/presentation/screens/tour_schedule_calendar_screen.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/schedule_confirm_dialog.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_calendar_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_schedule_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_calendar_selector.dart';


class TourScheduleCalendarScreen extends StatefulWidget {
  static const String routeName = '/tour-schedule-calendar';
  const TourScheduleCalendarScreen({super.key});

  @override
  State<TourScheduleCalendarScreen> createState() =>
      _TourScheduleCalendarScreenState();
}

class _TourScheduleCalendarScreenState
    extends State<TourScheduleCalendarScreen> {
  late TourModel tour;
  late List<TourScheduleModel> schedules;
  late bool isGroupTour;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  final formatter = NumberFormat('#,###');
  DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
  bool _isPastOrToday(DateTime day) => !_d(day).isAfter(_d(DateTime.now()));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as TourCalendarArgs;
    tour = args.tour;
    schedules = args.schedules;
    isGroupTour = args.isGroupTour;
  }

  TourScheduleModel? getScheduleForDay(DateTime day) {
    if (_isPastOrToday(day)) return null;
    return schedules.firstWhereOrNull((s) {
      final dep = s.startTime;
      return dep != null && dep.year == day.year && dep.month == day.month && dep.day == day.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const TourCalendarBackground(image: AssetHelper.img_tour_type_selector, overlayOpacity: 0.6),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  TourScheduleHeader(onBack: () => Navigator.pop(context)),
                  SizedBox(height: 2.h),
                  TourCalendarSelector(
                    focusedDay: focusedDay,
                    selectedDay: selectedDay,
                    getScheduleForDay: getScheduleForDay,
                    onDaySelected: (selected, focused) {
                      if (_isPastOrToday(selected)) return;

                      final matched = getScheduleForDay(selected);
                      if (matched != null) {
                        final media = (tour.medias.isNotEmpty &&
                                tour.medias.first.mediaUrl?.isNotEmpty == true)
                            ? tour.medias.first.mediaUrl!
                            : AssetHelper.img_tay_ninh_login;

                        ScheduleConfirmDialog.show(
                          context,
                          tour: tour,
                          schedule: matched,
                          isGroupTour: isGroupTour,
                          media: media,
                          formatter: formatter,
                        );
                      }

                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '🗓️ Chọn đúng thời điểm – mở ra chuyến đi đáng nhớ!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Full code sau khi chỉnh sửa để show Dialog cho cả tour đoàn và đi lẻ
// File: tour_schedule_calendar_screen.dart

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_team_selector_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/calendar_day_cell.dart';
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
  late TourTestModel tour;
  late List<TourScheduleWithPrice> schedules;
  late bool isGroupTour;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  late List<TourScheduleWithPrice> tourSchedules;
  final formatter = NumberFormat('#,###');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as TourCalendarArgs;
    tour = args.tour;
    schedules = args.schedules;
    isGroupTour = args.isGroupTour;

    final versions = mockTourPlanVersions
        .where((v) => v.tourId == tour.id && v.isActive && !v.isDeleted)
        .toList();

    versions.sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
    final latestVersionId = versions.isNotEmpty ? versions.first.id : null;

    tourSchedules = schedules.where((s) {
      return s.tourId == tour.id && s.versionId == latestVersionId;
    }).toList();
  }

TourScheduleWithPrice? getScheduleForDay(DateTime day) {
  return tourSchedules.firstWhereOrNull(
    (s) => isSameDay(s.departureDate, day),
  );
}

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetHelper.img_tour_type_selector),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
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
                    onDaySelected: (selected, focused) async {
                      final matched = getScheduleForDay(selected);
                      if (matched != null) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.4),
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 24),
                              backgroundColor: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2.w),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: Gradients
                                                .defaultGradientBackground,
                                          ),
                                          child: Icon(Icons.event_available,
                                              size: 28.sp,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          "Xác nhận ngày khởi hành",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.primaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 2.h),
                                        _buildDialogRow(
                                            Icons.calendar_today,
                                            'Ngày đi:',
                                            DateFormat('dd/MM/yyyy')
                                                .format(selected)),
                                        SizedBox(height: 1.h),
                                        _buildDialogRow(
                                            Icons.monetization_on,
                                            'Giá:',
                                            '${formatter.format(matched.price)}đ'),
                                        SizedBox(height: 1.h),
                                        _buildDialogRow(
                                            Icons.people_outline,
                                            'Còn lại:',
                                            '${matched.availableSlot} chỗ'),
                                        SizedBox(height: 3.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style:
                                                    OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.grey.shade700,
                                                  side: BorderSide(
                                                      color: Colors
                                                          .grey.shade400),
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: const Text("Huỷ"),
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  final matchedMedia =
                                                      mockTourMedia.firstWhere(
                                                    (m) =>
                                                        m.tourId == tour.id,
                                                    orElse: () =>
                                                        TourMediaTestModel(
                                                            id: 'none'),
                                                  );

                                                  if (isGroupTour) {
                                                    final result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            TourTeamSelectorScreen(
                                                          tour: tour,
                                                          schedule: matched,
                                                          media: matchedMedia,
                                                        ),
                                                      ),
                                                    );

                                                    if (result is Map<String,
                                                            dynamic> &&
                                                        result['confirmed'] ==
                                                            true) {
                                                      Navigator.pushNamed(
                                                        context,
                                                        TourPaymentConfirmationScreen
                                                            .routeName,
                                                        arguments: {
                                                          'tour': tour,
                                                          'schedule': matched,
                                                          'media': matchedMedia,
                                                          'adults':
                                                              result['adults'],
                                                          'children': result[
                                                              'children'],
                                                        },
                                                      );
                                                    }
                                                  } else {
                                                    Navigator.pushNamed(
                                                      context,
                                                      TourPaymentConfirmationScreen
                                                          .routeName,
                                                      arguments: {
                                                        'tour': tour,
                                                        'schedule': matched,
                                                        'media': matchedMedia,
                                                      },
                                                    );
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.5.h),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    gradient: Gradients
                                                        .defaultGradientBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: const Text(
                                                    "Chọn ngày này",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
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

  Widget _buildDialogRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorPalette.primaryColor, size: 20.sp),
        SizedBox(width: 2.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 15.sp,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

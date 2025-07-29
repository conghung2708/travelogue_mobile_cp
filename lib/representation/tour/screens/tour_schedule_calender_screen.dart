import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_team_selector_screen.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as TourCalendarArgs;
    tour = args.tour;
    schedules = args.schedules;
    isGroupTour = args.isGroupTour;

    // Debug
    for (var s in schedules) {
      print('[📆 Schedule] ${s.departureDate}');
    }
  }

  TourScheduleModel? getScheduleForDay(DateTime day) {
    print('[DEBUG] getScheduleForDay: looking for $day');

    return schedules.firstWhereOrNull((s) {
      final dep = s.departureDate;
      if (dep == null) return false;
      final match = isSameDay(dep, day);
      print(
          '  📅 ${dep.toIso8601String()} vs ${day.toIso8601String()} => match: $match');
      return match;
    });
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
                        final departure = matched.departureDate!;
                        final availableSlot = (matched.maxParticipant ?? 0) -
                            (matched.currentBooked ?? 0);

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
                                              size: 28.sp, color: Colors.white),
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
                                              .format(departure),
                                        ),
                                        SizedBox(height: 1.h),
                                        _buildDialogRow(
                                          Icons.monetization_on,
                                          'Giá:',
                                          '${formatter.format(matched.adultPrice?.round() ?? 0)}đ',
                                        ),
                                        SizedBox(height: 1.h),
                                        _buildDialogRow(
                                          Icons.people_outline,
                                          'Còn lại:',
                                          '$availableSlot chỗ',
                                        ),
                                        SizedBox(height: 3.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.grey.shade700,
                                                  side: BorderSide(
                                                      color:
                                                          Colors.grey.shade400),
                                                  shape: RoundedRectangleBorder(
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
                                                  final matchedMediaUrl = (tour
                                                              .mediaList
                                                              .isNotEmpty &&
                                                          tour.mediaList.first
                                                                  .mediaUrl !=
                                                              null &&
                                                          tour
                                                              .mediaList
                                                              .first
                                                              .mediaUrl!
                                                              .isNotEmpty)
                                                      ? tour.mediaList.first
                                                          .mediaUrl!
                                                      : AssetHelper
                                                          .img_tay_ninh_login;

                                                  if (isGroupTour) {
                                                    final result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            TourTeamSelectorScreen(
                                                          tour: tour,
                                                          schedule: matched,
                                                          media:
                                                              matchedMediaUrl,
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
                                                          'media':
                                                              matchedMediaUrl,
                                                          'departureDate':
                                                              matched
                                                                  .departureDate,
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
                                                        'media':
                                                            matchedMediaUrl,
                                                        'departureDate': matched
                                                            .departureDate,
                                                        'adults': 1,
                                                        'children': 0,
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

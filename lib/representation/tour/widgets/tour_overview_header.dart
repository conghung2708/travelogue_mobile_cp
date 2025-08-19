// lib/features/tour/presentation/widgets/tour_overview_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_info_icon_row.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_schedule_calender_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_confirmed_action_card.dart';

class TourOverviewHeader extends StatelessWidget {
  final TourModel tour;
  final bool? readOnly;
  final DateTime? startTime;
  final bool? isBooked;

  const TourOverviewHeader({
    super.key,
    required this.tour,
    this.readOnly,
    this.startTime,
    this.isBooked,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDays = tour.totalDays ?? 1;
    final String tourDuration =
        '${totalDays}N${(totalDays - 1).clamp(1, totalDays)}D';

    final String tourDate = startTime != null
        ? DateFormat('dd/MM/yyyy').format(startTime!)
        : 'Chưa chọn ngày';

    final double tourPrice = tour.finalPrice ?? 0;
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tour.name ?? '',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: "Pattaya",
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TripInfoIconRow(
              icon: Icons.explore,
              value: tour.tourTypeText ?? '---',
              label: 'Loại hình',
            ),
            TripInfoIconRow(
              icon: Icons.calendar_month,
              value: tourDate,
              label: 'Khởi hành',
            ),
            TripInfoIconRow(
              icon: Icons.access_time,
              value: tourDuration,
              label: 'Thời gian',
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          height: 5.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: const TripMarqueeInfo(),
        ),
        SizedBox(height: 2.h),
        TourConfirmedActionCard(
          startTime: startTime,
          isBooked: isBooked,
          tour: tour,
          currencyFormat: currencyFormatter,
          price: tourPrice,
          readOnly: readOnly,
          onConfirmed: () async {
            final schedules = tour.schedules;
            if (schedules == null || schedules.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tour này chưa có lịch trình.')),
              );
              return;
            }
            await Navigator.pushNamed(
              context,
              TourScheduleCalendarScreen.routeName,
              arguments: TourCalendarArgs(
                tour: tour,
                schedules: schedules,
                isGroupTour: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

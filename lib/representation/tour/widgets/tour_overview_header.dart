// lib/representation/tour/widgets/tour_overview_header.dart
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

  // BE trả text: "Xe máy", "Xe hơi", "Xe bus", "Tàu/Thuyền", "Máy bay", ...
  String _transportLabel(String? raw) {
    final s = (raw ?? '').trim();
    return s.isEmpty ? 'Xe máy' : s; // mặc định: xe máy
  }

  IconData _transportIcon(String? raw) {
    final s = (raw ?? '').toLowerCase().trim();
    if (s.contains('máy bay')) return Icons.flight_takeoff_rounded;
    if (s.contains('bus')) return Icons.directions_bus_filled_rounded;
    if (s.contains('tàu') || s.contains('thuyền')) {
      return Icons.directions_boat_filled_rounded;
    }
    if (s.contains('hơi') || s.contains('ô tô') || s.contains('oto')) {
      return Icons.directions_car_rounded;
    }
    if (s.contains('máy')) return Icons.two_wheeler_rounded; // xe máy
    return Icons.route_rounded;
  }

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

    final String transportText = _transportLabel(tour.transportType);
    final IconData transportIcon = _transportIcon(tour.transportType);

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

        SizedBox(height: 1.5.h),

        // Chip phương tiện (string từ BE)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(transportIcon, size: 18.sp, color: Colors.blueGrey),
              SizedBox(width: 2.w),
              Text(
                'Phương tiện: $transportText',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[700],
                ),
              ),
            ],
          ),
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
            // schedules giờ là non-null (default [])
            final schedules = tour.schedules;
            if (schedules.isEmpty) {
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

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final TourScheduleModel? schedule;
  final bool isToday;
  final bool isSelected;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.schedule,
    this.isToday = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Debug log
    print('⏱️ Rendering CalendarDayCell: ${day.toIso8601String()}');
    print('📦 schedule: ${schedule?.toJson()}');

    final max = schedule?.maxParticipant ?? 0;
    final booked = schedule?.currentBooked ?? 0;
    final price = schedule?.adultPrice ?? 0;

    final availableSlot = max - booked;
    final hasAvailable = availableSlot > 0;

    final priceText = price >= 1000
        ? '${(price / 1000).round()}K'
        : '${price.round()}đ';

    final isLowSlot = hasAvailable && availableSlot <= 5;

    print('➡️ day: ${day.day} | slot: $availableSlot | price: $priceText');

    return Container(
      margin: EdgeInsets.all(0.7.w),
      height: 7.5.h,
      width: 12.w,
      decoration: BoxDecoration(
        color: isSelected
            ? null
            : isToday
                ? Colors.blue.withOpacity(0.25)
                : Colors.white,
        gradient: isSelected ? Gradients.defaultGradientBackground : null,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: isSelected
              ? Colors.blue.shade800
              : isToday
                  ? Colors.blue.shade300
                  : Colors.grey.shade300,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (hasAvailable)
            Flexible(
              child: Text(
                priceText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? Colors.white : Colors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (isLowSlot)
            const Icon(
              Icons.notification_important_rounded,
              size: 14,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}

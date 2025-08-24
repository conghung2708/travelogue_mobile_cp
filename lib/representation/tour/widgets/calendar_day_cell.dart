import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

// Helper: rút gọn phần giờ để so sánh theo ngày
DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

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
    final bool isDisabled = !_d(day).isAfter(_d(DateTime.now()));

    final max = schedule?.maxParticipant ?? 0;
    final booked = schedule?.currentBooked ?? 0;
    final double price = schedule?.adultPrice ?? 0;

    final availableSlot = max - booked;
    final hasAvailable = availableSlot > 0;

    final String priceText = price >= 1000
        ? '${NumberFormat('#,###').format(price)}đ'
        : '${price.round()}đ';

    final bool isLowSlot = hasAvailable && availableSlot <= 5;

    final borderColor = isSelected
        ? Colors.blue.shade800
        : isToday
            ? Colors.blue.shade300
            : (isDisabled ? Colors.grey.shade300 : Colors.grey.shade300);

    return Opacity(
      opacity: isDisabled ? 0.45 : 1.0,
      child: Container(
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
          border: Border.all(color: borderColor),
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
            if (!isDisabled && hasAvailable)
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
            if (!isDisabled && isLowSlot)
              const Icon(
                Icons.notification_important_rounded,
                size: 14,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}

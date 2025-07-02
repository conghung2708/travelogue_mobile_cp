import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/representation/tour/widgets/calendar_day_cell.dart';

class TourCalendarSelector extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final TourScheduleWithPrice? Function(DateTime day) getScheduleForDay;

  const TourCalendarSelector({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.getScheduleForDay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TableCalendar(
        locale: 'vi_VN',
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) =>
            selectedDay != null &&
            day.year == selectedDay!.year &&
            day.month == selectedDay!.month &&
            day.day == selectedDay!.day,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Tháng'},
        onFormatChanged: (_) {},
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: Colors.white),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
          weekendStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        calendarStyle: CalendarStyle(
          tablePadding: EdgeInsets.only(top: 2.h),
        ),
        onDaySelected: onDaySelected,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final matched = getScheduleForDay(day);
            return CalendarDayCell(day: day, schedule: matched);
          },
          todayBuilder: (context, day, _) {
            final matched = getScheduleForDay(day);
            return CalendarDayCell(day: day, schedule: matched, isToday: true);
          },
          selectedBuilder: (context, day, _) {
            final matched = getScheduleForDay(day);
            return CalendarDayCell(
                day: day, schedule: matched, isSelected: true);
          },
        ),
      ),
    );
  }
}

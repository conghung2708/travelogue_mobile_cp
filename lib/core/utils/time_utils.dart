import 'package:flutter/material.dart';

class TimeUtils {
  static DateTime combine(DateTime day, TimeOfDay t) =>
      DateTime(day.year, day.month, day.day, t.hour, t.minute);

  static bool withinDay(DateTime dt, DateTime day, int minHour, int maxHour) {
    final start = DateTime(day.year, day.month, day.day, minHour, 0);
    final end   = DateTime(day.year, day.month, day.day, maxHour, 0);
    return !dt.isBefore(start) && !dt.isAfter(end);
  }

  static String fmtTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

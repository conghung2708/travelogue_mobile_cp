// lib/representation/tour_guide/widgets/guide_top_bar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class GuideTopBar extends StatelessWidget {
  final VoidCallback onOpenFilter;
  final VoidCallback onPickDateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final Color color;
  final VoidCallback? onClearDate;

  const GuideTopBar({
    super.key,
    required this.onOpenFilter,
    required this.onPickDateRange,
    required this.startDate,
    required this.endDate,
    required this.color,
    this.onClearDate,
  });

  @override
  Widget build(BuildContext context) {
    final hasRange = startDate != null && endDate != null;
    final label = _rangeLabel(startDate, endDate);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPickDateRange,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range, color: color, size: 16.sp),
                    SizedBox(width: 2.w),
                    Semantics(
                      button: true,
                      label: hasRange ? 'Khoảng ngày $label' : 'Chọn ngày',
                      child: Text(
                        hasRange ? label : 'Chọn ngày',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasRange) ...[
                      SizedBox(width: 1.w),
            
                      Tooltip(
                        message: 'Xoá ngày',
                        child: IconButton(
                          constraints:
                              const BoxConstraints(minWidth: 40, minHeight: 40),
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.close_rounded,
                              size: 16.sp, color: color),
                          onPressed: onClearDate, 
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          Tooltip(
            message: 'Bộ lọc',
            child: InkWell(
              onTap: onOpenFilter,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, color: color, size: 18.sp),
                    SizedBox(width: 1.w),
                    Text(
                      'Bộ lọc',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _rangeLabel(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '';
    final sameYear = start.year == end.year;
    final sameMonth = start.month == end.month && sameYear;

    final dfShort = DateFormat('dd/MM');
    final dfShortY = DateFormat('dd/MM/yyyy');

    final left = sameYear ? dfShort.format(start) : dfShortY.format(start);
    final right = sameYear && sameMonth
        ? dfShort.format(end)
        : (sameYear ? dfShort.format(end) : dfShortY.format(end));



    return '$left → $right';
  }
}

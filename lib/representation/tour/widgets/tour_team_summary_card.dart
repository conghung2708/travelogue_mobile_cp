import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourTeamSummaryCard extends StatelessWidget {
  final TourModel tour;
  final TourScheduleModel schedule;
  final String mediaUrl;
  final NumberFormat formatter;

  const TourTeamSummaryCard({
    super.key,
    required this.tour,
    required this.schedule,
    required this.mediaUrl,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.95), Colors.white70]),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 25.w,
              height: 11.h,
              child: mediaUrl.startsWith('http')
                  ? Image.network(mediaUrl, fit: BoxFit.cover)
                  : Image.asset(mediaUrl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🌍 Việt Nam',
                    style: TextStyle(
                        fontSize: 13.sp, color: Colors.grey.shade600)),
                SizedBox(height: 0.5.h),
                Text(tour.name ?? '',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(height: 0.5.h),
                Text(
                    '📅 ${DateFormat('dd/MM/yyyy').format(schedule.startTime!)}',
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.shade800)),
                SizedBox(height: 0.5.h),
                Text('💰 Giá tour: ${formatter.format(schedule.adultPrice)}đ',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class GuideInfoCard extends StatelessWidget {
  final TourGuideModel guide;
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;
  final VoidCallback? onEditDates;
  final DateFormat dateFormatter;
  final NumberFormat currencyFormat;

  const GuideInfoCard({
    super.key,
    required this.guide,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
    this.onEditDates,
    required this.dateFormatter,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final priceStr = guide.price != null
        ? "${currencyFormat.format(guide.price)}/ngày"
        : "Không rõ";

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            guide.userName ?? "Hướng dẫn viên",
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.orange, size: 16.sp),
              SizedBox(width: 2.w),
              Text(
                priceStr,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBDEFB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '📅 Ngày đặt:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (onEditDates != null)
                      GestureDetector(
                        onTap: onEditDates,
                        child: Icon(
                          Icons.edit_calendar_outlined,
                          color: Colors.blue,
                          size: 18.sp,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Text(
                  '${dateFormatter.format(startDate)} → ${dateFormatter.format(endDate)}',
                  style: TextStyle(fontSize: 13.5.sp),
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(Icons.group, color: Colors.indigo, size: 16.sp),
                    SizedBox(width: 2.w),
                    Text(
                      'Người lớn: $adults, Trẻ em: $children',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

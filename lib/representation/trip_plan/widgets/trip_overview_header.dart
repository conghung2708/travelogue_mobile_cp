import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_info_icon_row.dart';

class TripOverviewHeader extends StatelessWidget {
  final TripPlanDetailModel trip;

  const TripOverviewHeader({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final String tripDate = DateFormat('dd-MM-yyyy').format(trip.startDate);
    final String tripDuration = '${trip.totalDays}N${trip.totalDays - 1}D';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.name,
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
              icon: Icons.flag,
              value: trip.statusText,
              label: 'Trạng thái',
            ),
            TripInfoIconRow(
              icon: Icons.calendar_month,
              value: tripDate,
              label: 'Khởi hành',
            ),
            TripInfoIconRow(
              icon: Icons.access_time,
              value: tripDuration,
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.green.shade700,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cảm ơn bạn!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Travelogue trân trọng sự đồng hành của bạn. Chúc chuyến đi thật đáng nhớ!',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Colors.green.shade900.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

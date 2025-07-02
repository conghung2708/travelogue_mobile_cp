import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/enums/tour_guide_status_enum.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_info_icon_row.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_confirmed_action_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_pending_action_card.dart';

class TripOverviewHeader extends StatelessWidget {
  final BaseTrip trip;
  final List<DateTime> days;
  final NumberFormat currencyFormat;
  final TourGuideStatus? guideStatus;
  final void Function(BaseTrip updatedTrip)? onUpdated;

  const TripOverviewHeader({
    super.key,
    required this.trip,
    required this.days,
    required this.currencyFormat,
    this.guideStatus,
      this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final double tripPrice = trip.price ?? 6390000;
    final String tripDate = DateFormat('dd-MM-yyyy').format(trip.startDate);
    final String tripDuration = '${days.length}N${days.length - 1}D';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tiêu đề tour
        Text(
          trip.name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: "Pattaya",
          ),
        ),
        SizedBox(height: 1.h),

        /// Dòng icon info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            trip.rating == null
                ? TripInfoIconRow(
                    icon: Icons.star,
                    value: '${trip.rating} sao',
                    label: 'Chất lượng',
                  )
                : const TripInfoIconRow(
                    icon: Icons.explore,
                    value: 'Tự thiết kế',
                    label: 'Hành trình',
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

        /// Marquee Info
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

        /// Tùy theo trạng thái hướng dẫn viên
     if (guideStatus == TourGuideStatus.available)
  if ((trip is TripPlan) && (trip as TripPlan).statusEnum == TripStatus.booked)
    _buildThankYouCard()
  else
    TripConfirmedActionCard(
      trip: trip,
      days: days,
      currencyFormat: currencyFormat,
      onUpdated: onUpdated,
    ),
        if (guideStatus == TourGuideStatus.pending)
          TripPendingActionCard(
            currencyFormat: currencyFormat,
            price: tripPrice,
          ),

        SizedBox(height: 2.h),
      ],
    );
  }
}


Widget _buildThankYouCard() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(3.w),
      border: Border.all(color: Colors.green.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 18.sp),
            SizedBox(width: 2.w),
            Text(
              "Tour đã được đặt thành công!",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Text(
          "🎉 Travelogue xin cảm ơn bạn đã tin tưởng sử dụng dịch vụ.\n💙 Chúc bạn có một chuyến đi thật tuyệt vời!",
          style: TextStyle(fontSize: 13.sp, color: Colors.blueGrey[700]),
        ),
      ],
    ),
  );
}

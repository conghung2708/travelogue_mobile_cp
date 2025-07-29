import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_type_selector.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_info_icon_row.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_confirmed_action_card.dart';

class TourOverviewHeader extends StatelessWidget {
  final TourModel tour;
  final bool? readOnly;
  final DateTime? departureDate;
  final bool? isBooked;

  const TourOverviewHeader({
    super.key,
    required this.tour,
    this.readOnly,
    this.departureDate,
    this.isBooked,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDays = tour.totalDays ?? 1;
    final String tourDuration =
        '${totalDays}N${(totalDays - 1).clamp(1, totalDays)}D';

    final String tourDate = departureDate != null
        ? DateFormat('dd/MM/yyyy').format(departureDate!)
        : 'Chưa chọn ngày';

    final double tourPrice = tour.finalPrice ?? 0;
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

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
          departureDate: departureDate,
          isBooked: isBooked,
          tour: tour,
          currencyFormat: currencyFormatter,
          price: tourPrice,
          readOnly: readOnly,
          onConfirmed: () async {
            final parsedTour = TourModel.fromJson(tour.toJson());

            print('[TourOverviewHeader] parsedTour id: ${parsedTour.tourId}');
            print(
                '[TourOverviewHeader] schedules == null? ${parsedTour.schedules == null}');
            print(
                '[TourOverviewHeader] schedules.length: ${parsedTour.schedules?.length}');
            await Navigator.pushNamed(
              context,
              TourTypeSelector.routeName,
              arguments: {
                'tour': tour.toJson(),
              },
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_type_test_model.dart';

import 'package:travelogue_mobile/representation/tour/screens/tour_type_selector.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_info_icon_row.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_confirmed_action_card.dart';

class TourOverviewHeader extends StatelessWidget {
  final TourTestModel tour;
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
    TourPlanVersionTestModel? version;
    try {
      version = mockTourPlanVersions.firstWhere(
        (v) => v.id == tour.currentVersionId,
      );
    } catch (_) {
      version = null;
    }

    TourTypeTestModel? tourType;
    try {
      tourType = mockTourTypes.firstWhere(
        (t) => t.id == tour.tourTypeId,
      );
    } catch (_) {
      tourType = null;
    }

    final double tourPrice = version?.price ?? 0;
    final int totalDays = tour.totalDays;
    final String tourDuration = '${totalDays}N${totalDays - 1}D';

    final String tourDate = departureDate != null
        ? DateFormat('dd/MM/yyyy').format(departureDate!)
        : 'Chưa chọn ngày';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tour.name,
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
              value: tourType?.name ?? '---',
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
        if (version != null)
          TourConfirmedActionCard(
            departureDate: departureDate,
            isBooked: isBooked,
            tour: tour,
            currencyFormat: NumberFormat.currency(locale: 'vi_VN', symbol: '₫'),
            price: tourPrice,
            onConfirmed: () async {
              final result = await Navigator.pushNamed(
                context,
                TourTypeSelector.routeName,
                arguments: tour,
              );
            },
            readOnly: readOnly,
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_marquee_info.dart';

class TripOverviewHeader extends StatelessWidget {
  final BaseTrip trip;
  final List<DateTime> days;
  final NumberFormat currencyFormat;

  const TripOverviewHeader({
    super.key,
    required this.trip,
    required this.days,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
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
            trip.rating == null
                ? _buildIconInfo(Icons.star, '${trip.rating} sao', 'Chất lượng')
                : _buildIconInfo(Icons.explore, 'Tự thiết kế', 'Hành trình'),
            _buildIconInfo(Icons.calendar_month,
                DateFormat('dd-MM-yyyy').format(trip.startDate), 'Khởi hành'),
            _buildIconInfo(Icons.access_time,
                '${days.length}N${days.length - 1}D', 'Thời gian'),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: Size(double.infinity, 6.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
          ),
          onPressed: () {},
          child: Text(
            'ĐẶT TOUR NGAY  ${currencyFormat.format(trip.price ?? 6390000)}',
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildIconInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 5.w),
            SizedBox(width: 1.w),
            Text(value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
          ],
        ),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
      ],
    );
  }
}

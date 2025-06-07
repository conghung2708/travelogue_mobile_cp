import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';

class TripPlanCard extends StatelessWidget {
  final TripPlan trip;
  final double height;

  const TripPlanCard({super.key, required this.trip, required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          TripDetailScreen.routeName,
          arguments: trip,
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
          ),
          builder: (_) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 ${trip.name}',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 1.h),
                Text(trip.description),
                SizedBox(height: 1.h),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.info),
                  label: Text('Xem chi tiết'),
                )
              ],
            ),
          ),
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          image: DecorationImage(
            image: NetworkImage(trip.coverImage),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 1.h,
              left: 1.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  trip.status.isNotEmpty ? trip.status : 'Chưa xác định',
                  style: TextStyle(color: Colors.white, fontSize: 11.5.sp),
                ),
              ),
            ),
            Positioned(
              top: 1.h,
              right: 1.h,
              child: Row(
                children: [
                  Icon(Icons.landscape, color: Colors.white, size: 4.w),
                  Icon(Icons.restaurant, color: Colors.white, size: 4.w),
                  Icon(Icons.palette, color: Colors.white, size: 4.w),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(4.w),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "${DateFormat('dd/MM/yyyy').format(trip.startDate)} - ${DateFormat('dd/MM/yyyy').format(trip.endDate)}",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

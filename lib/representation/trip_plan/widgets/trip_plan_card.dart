import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/trip_detail_args.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/trip_status.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_trip_day_screen.dart';

class TripPlanCard extends StatelessWidget {
  final TripPlan trip;
  final double height;
  final void Function(TripPlan updatedTrip)? onUpdated;

  const TripPlanCard({
    super.key,
    required this.trip,
    required this.height,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final TripStatus status = trip.statusEnum;
    print('📣 Trip "${trip.name}" có trạng thái: ${status.name}');
    final Color statusColor = _getStatusColor(status);
    final String statusLabel = status.label;

    return GestureDetector(
      onTap: () async {
        if (trip.tourGuide == null || trip.statusEnum == TripStatus.noGuide) {
          final versionId = trip.versionId;

          // Nếu chưa có versionId thì không thể khôi phục dữ liệu
          if (versionId == null) {
            final result = await Navigator.pushNamed(
              context,
              SelectTripDayScreen.routeName,
              arguments: {
                'trip': trip,
                'days': List.generate(
                  trip.endDate.difference(trip.startDate).inDays + 1,
                  (i) => trip.startDate.add(Duration(days: i)),
                ),
              },
            );
            if (result is TripPlan) {
              onUpdated?.call(result);
            }
            return;
          }

          final selectedPerDay = <DateTime, List<dynamic>>{};

          final locations = tripLocations
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();
          final cuisines = tripCuisines
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();
          final crafts = tripCraftVillages
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();
          for (final item in [...locations, ...cuisines, ...crafts]) {
            DateTime? day;

            if (item is TripPlanLocation) {
              day = DateTime(item.startTime.year, item.startTime.month,
                  item.startTime.day);
            } else if (item is TripPlanCuisine) {
              day = DateTime(item.startTime.year, item.startTime.month,
                  item.startTime.day);
            } else if (item is TripPlanCraftVillage) {
              day = DateTime(item.startTime.year, item.startTime.month,
                  item.startTime.day);
            }

            if (day != null) {
              selectedPerDay.putIfAbsent(day, () => []).add(item);
            }
          }

          final result = await Navigator.pushNamed(
            context,
            SelectTripDayScreen.routeName,
            arguments: {
              'trip': trip,
              'days': List.generate(
                trip.endDate.difference(trip.startDate).inDays + 1,
                (i) => trip.startDate.add(Duration(days: i)),
              ),
              'selectedPerDay': selectedPerDay,
            },
          );

          if (result is TripPlan) {
            onUpdated?.call(result);
          }
        } else {
          final versionId = trip.versionId;

          final locations = tripLocations
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();
          final cuisines = tripCuisines
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();
          final villages = tripCraftVillages
              .where((e) => e.tripPlanVersionId == versionId)
              .toList();

          final days = List.generate(
            trip.endDate.difference(trip.startDate).inDays + 1,
            (i) => trip.startDate.add(Duration(days: i)),
          );

          Navigator.pushNamed(
            context,
            TripDetailScreen.routeName,
            arguments: TripDetailArgs(
              trip: trip,
              guide: trip.tourGuide,
              locations: locations,
              cuisines: cuisines,
              villages: villages,
              days: days,
            ),
          );
        }
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
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      TripDetailScreen.routeName,
                      arguments: trip,
                    );
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('Xem chi tiết'),
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
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
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

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.planning:
        return Colors.blueAccent.withOpacity(0.85);
      case TripStatus.noGuide:
        return Colors.grey.withOpacity(0.85);
      case TripStatus.finalized:
        return Colors.orange.withOpacity(0.85);
    }
  }
}

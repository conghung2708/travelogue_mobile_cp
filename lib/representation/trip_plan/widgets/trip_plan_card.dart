import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/trip_detail_args.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
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
    final Color statusColor = _getStatusColor(status);
    final String statusLabel = status.label;

    return GestureDetector(
      onTap: () async {
        if (trip.tourGuide == null || trip.statusEnum == TripStatus.noGuide) {
          final versionId = trip.versionId;

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
          navigateToTripDetail(context, trip);
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
                    navigateToTripDetail(context, trip);
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
            // Label trạng thái
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

            // Góc phải trên: icon xoá hoặc 3 icon địa điểm
            Positioned(
              top: 1.h,
              right: 1.h,
              child: trip.statusEnum == TripStatus.noGuide
                  ? GestureDetector(
                      onTap: () => _confirmDeleteTrip(context, trip),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.9),
                        ),
                        child: const Icon(Icons.close,
                            size: 20, color: Colors.white),
                      ),
                    )
                  : Row(
                      children: [
                        Icon(Icons.landscape, color: Colors.white, size: 4.w),
                        Icon(Icons.restaurant, color: Colors.white, size: 4.w),
                        Icon(Icons.palette, color: Colors.white, size: 4.w),
                      ],
                    ),
            ),

            // Phần thông tin tên + ngày ở đáy
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
        return Colors.orange.withOpacity(0.85);
      case TripStatus.finalized:
        return Colors.grey.withOpacity(0.85);
      case TripStatus.booked:
        return Colors.green.withOpacity(0.85);
      default:
        return Colors.black26;
    }
  }

  void navigateToTripDetail(BuildContext context, TripPlan trip) {
    final versionId = trip.versionId;
    if (versionId == null || versionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⛔ Trip chưa có dữ liệu versionId')),
      );
      return;
    }

    final locations =
        tripLocations.where((e) => e.tripPlanVersionId == versionId).toList();

    final cuisines =
        tripCuisines.where((e) => e.tripPlanVersionId == versionId).toList();

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
        locations: locations,
        cuisines: cuisines,
        villages: villages,
        days: days,
        guide: trip.tourGuide,
      ),
    );
  }

  void _confirmDeleteTrip(BuildContext context, TripPlan trip) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dialog",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return const SizedBox();
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Icon(Icons.delete_forever_rounded,
                          color: Colors.redAccent, size: 32.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Bạn chắc chắn chứ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: "Roboto",
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      'Xoá hành trình "${trip.name}" sẽ không thể hoàn tác.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                        fontFamily: "Roboto",
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Huỷ',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.black87)),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              onUpdated?.call(trip.copyWith(
                                status: TripStatus.deleted.index,
                              ));
                            },
                            child: Text('Xoá',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

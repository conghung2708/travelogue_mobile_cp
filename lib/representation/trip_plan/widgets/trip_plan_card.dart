import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_model.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_trip_day_screen.dart';

class TripPlanCard extends StatelessWidget {
  final TripPlanModel trip;
  final double height;
  final void Function(TripPlanModel updatedTrip)? onUpdated;

  const TripPlanCard({
    super.key,
    required this.trip,
    required this.height,
    this.onUpdated,
  });

  ImageProvider _safeImageProvider(String? raw) {
    const fallback = AssetHelper.img_default;
    if (raw == null) return const AssetImage(fallback);
    final url = raw.trim().replaceAll('"', '').toLowerCase();

    if (url.isEmpty || url == 'string') {
      return const AssetImage(fallback);
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(raw);
    }
    return AssetImage(raw);
  }

  @override
  Widget build(BuildContext context) {
    final TripStatus status = trip.statusEnum;
    final Color statusColor = _getStatusColor(status);
    final String statusLabel = _getStatusLabel(status);
    final imageProvider = _safeImageProvider(trip.imageUrl);

    return GestureDetector(
      onTap: () {
        final isDraftOrSketch = trip.statusEnum == TripStatus.draft ||
            trip.statusEnum == TripStatus.sketch;
        if (isDraftOrSketch) {
          Navigator.pushNamed(
            context,
            SelectTripDayScreen.routeName,
            arguments: {'tripId': trip.id},
          );
        } else {
          Navigator.pushNamed(
            context,
            TripDetailScreen.routeName,
            arguments: trip.id,
          );
        }
      },
      onLongPress: () {
        _showBottomSheet(context, trip);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          image: DecorationImage(
            image: imageProvider,
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
      case TripStatus.draft:
        return Colors.blueAccent.withOpacity(0.85);
      case TripStatus.sketch:
        return Colors.orange.withOpacity(0.85);
      case TripStatus.booked:
        return Colors.green.withOpacity(0.85);
      default:
        return Colors.black26;
    }
  }

  String _getStatusLabel(TripStatus status) {
    switch (status) {
      case TripStatus.draft:
        return "Bản nháp";
      case TripStatus.sketch:
        return "Phác thảo";
      case TripStatus.booked:
        return "Đã đặt";
      default:
        return "Không xác định";
    }
  }

  void _showBottomSheet(BuildContext context, TripPlanModel trip) {
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
            Text(
              '🎯 ${trip.name}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Text(trip.description),
            SizedBox(height: 1.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                final isDraftOrSketch = trip.statusEnum == TripStatus.draft ||
                    trip.statusEnum == TripStatus.sketch;
                if (isDraftOrSketch) {
                  Navigator.pushNamed(
                    context,
                    SelectTripDayScreen.routeName,
                    arguments: {'tripId': trip.id},
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    TripDetailScreen.routeName,
                    arguments: trip.id,
                  );
                }
              },
              icon: const Icon(Icons.info),
              label: const Text('Xem chi tiết'),
            ),
          ],
        ),
      ),
    );
  }
}

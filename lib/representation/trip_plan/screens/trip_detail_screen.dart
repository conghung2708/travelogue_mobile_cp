import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/args/trip_detail_args.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/tour_detail_content.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  static const routeName = '/trip_detail';

  List<DateTime> _getTripDays(DateTime start, DateTime end) => List.generate(
        end.difference(start).inDays + 1,
        (i) => start.add(Duration(days: i)),
      );

  @override
  Widget build(BuildContext context) {
    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;
    late final BaseTrip trip;
    TourGuideTestModel? guide;
    List<TripPlanLocation> locations = [];
    List<TripPlanCuisine> cuisines = [];
    List<TripPlanCraftVillage> villages = [];
    List<DateTime> days = [];

    if (rawArgs is TripDetailArgs) {
      trip = rawArgs.trip;
      guide = rawArgs.guide;
      locations = rawArgs.locations ?? [];
      cuisines = rawArgs.cuisines ?? [];
      villages = rawArgs.villages ?? [];
      days = rawArgs.days ??
          _getTripDays(trip.startDate, trip.endDate);
    } else if (rawArgs is BaseTrip) {
      trip = rawArgs;
      final versionId = trip.versionId ?? '';
      locations = tripLocations
          .where((e) => e.tripPlanVersionId == versionId)
          .toList();
      cuisines = tripCuisines
          .where((e) => e.tripPlanVersionId == versionId)
          .toList();
      villages = tripCraftVillages
          .where((e) => e.tripPlanVersionId == versionId)
          .toList();
      days = _getTripDays(trip.startDate, trip.endDate);
    } else {
      return const Scaffold(
        body: Center(child: Text("❌ Dữ liệu không hợp lệ")),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  trip.coverImage,
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 2.h,
                  left: 4.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: TourDetailContent(
                  guide: guide,
                  trip: trip,
                  days: days,
                  currencyFormat: currencyFormat,
                  locations: locations,
                  cuisines: cuisines,
                  villages: villages,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          final bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Xác nhận'),
              content: const Text('Bạn có muốn gọi điện cho 0336626193 không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Gọi'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            final Uri phoneUri = Uri(scheme: 'tel', path: '0336626193');

            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
              );
            }
          }
        },
        child: const Icon(Icons.phone),
      ),
    );
  }
}

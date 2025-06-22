import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/create_trip_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/banner_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/create_trip_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/header_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_plan_card.dart';

class MyTripPlansScreen extends StatefulWidget {
  static const routeName = '/my-plan-trip';

  const MyTripPlansScreen({super.key});

  @override
  State<MyTripPlansScreen> createState() => _MyTripPlansScreenState();
}

class _MyTripPlansScreenState extends State<MyTripPlansScreen> {
  List<TripPlan> myTrips = List.from(tripPlans);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            const HeaderWidget(),
            SizedBox(height: 1.5.h),
            const BannerWidget(),
            SizedBox(height: 2.h),
            Expanded(child: _buildMasonryTripPlansList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryTripPlansList() {
    final totalItems = myTrips.length + 1;

    print('🔍 DEBUG: Tổng số tripPlans = ${myTrips.length}');
    for (var i = 0; i < myTrips.length; i++) {
      final t = myTrips[i];
      print('📌 Trip #$i: ${t.name}, ID: ${t.id}, CoverImage: ${t.coverImage}');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 4.w,
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == myTrips.length) {
            return CreateTripCard(
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  CreateTripScreen.routeName,
                );

                if (result != null && result is TripPlan) {
                  final exists = myTrips.any((t) => t.id == result.id);
                  if (!exists) {
                    setState(() {
                      myTrips.add(result);
                    });
                  }
                }
              },
            );
          }

          final trip = myTrips[index];
          final cardHeight = (index % 3 == 0) ? 24.h : 30.h;

          print(
              '🧩 Card index $index | Trip: ${trip.name} | Image: ${trip.coverImage}');
          return TripPlanCard(
            trip: trip,
            height: cardHeight,
            onUpdated: (updatedTrip) {
              setState(() {
                final index = myTrips.indexWhere((t) => t.id == updatedTrip.id);
                if (index != -1) {
                  myTrips[index] = updatedTrip;
                  print(
                      '🛠 Trip "${updatedTrip.name}" đã được cập nhật trong danh sách với trạng thái: ${updatedTrip.statusEnum.name}');
                }
              });
            },
          );
        },
      ),
    );
  }
}

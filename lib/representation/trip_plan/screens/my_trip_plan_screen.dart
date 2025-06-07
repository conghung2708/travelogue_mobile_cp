import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/banner_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/create_trip_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/header_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_plan_card.dart';

class MyTripPlansScreen extends StatelessWidget {
  static const routeName = '/my-plan-trip';

  const MyTripPlansScreen({super.key});

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
            Expanded(child: _buildMasonryTripPlansList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryTripPlansList(BuildContext context) {
    final totalItems = tripPlans.length + 1;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 4.w,
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == tripPlans.length) {
        return CreateTripCard(
  onTap: () {
    // TODO: Điều hướng tới màn tạo hành trình
  },
);

          }
final trip = tripPlans[index];
final cardHeight = (index % 3 == 0) ? 24.h : 30.h;

return TripPlanCard(
  trip: trip,
  height: cardHeight,
);

        },
      ),
    );
  }
}

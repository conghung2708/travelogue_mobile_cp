import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:travelogue_mobile/model/enums/trip_status.dart';
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
  TripStatus? selectedStatus;

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
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100, width: 1),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                      ),
                      child: Icon(Icons.tune, size: 18.sp, color: Colors.blue),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TripStatus?>(
                          value: selectedStatus,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey.shade600),
                          hint: Text(
                            'Lọc theo trạng thái hành trình',
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.grey.shade600),
                          ),
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black87),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(
                                'Tất cả',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            ...TripStatus.values.map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status.label),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(child: _buildMasonryTripPlansList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryTripPlansList() {
    final filteredTrips = myTrips
        .where((t) => t.statusEnum != TripStatus.deleted)
        .where((t) => selectedStatus == null || t.statusEnum == selectedStatus)
        .toList();

    final totalItems = filteredTrips.length + 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 4.w,
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == filteredTrips.length) {
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

          final trip = filteredTrips[index];
          final cardHeight = (index % 3 == 0) ? 24.h : 30.h;

          return TripPlanCard(
            trip: trip,
            height: cardHeight,
            onUpdated: (updatedTrip) {
              setState(() {
                final index = myTrips.indexWhere((t) => t.id == updatedTrip.id);
                if (index != -1) {
                  myTrips[index] = updatedTrip;
                }
              });
            },
          );
        },
      ),
    );
  }
}

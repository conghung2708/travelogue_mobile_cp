import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_model.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
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
  TripStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
  }


  void _goToTourScreen() {
    AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 2));
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      
      onWillPop: () async {
        _goToTourScreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 2.h),

             
              HeaderWidget(
                onBack: _goToTourScreen,
                // showCreateButton: true,
                // onCreateTrip: () async {
                //   final result = await Navigator.pushNamed(context, CreateTripScreen.routeName);
                //   if (result != null && result is TripPlanModel) {
                //     AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                //   }
                // },
              ),

              SizedBox(height: 1.5.h),
              const BannerWidget(),
              SizedBox(height: 1.5.h),
              _buildFilterDropdown(),
              SizedBox(height: 2.h),
              Expanded(child: _buildMasonryTripPlansList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100, width: 1),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade50),
              child: Icon(Icons.tune, size: 18.sp, color: Colors.blue),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TripStatus?>(
                  value: selectedStatus,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
                  hint: Text(
                    'Lọc theo trạng thái hành trình',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  items: [
                    DropdownMenuItem(value: null, child: Text('Tất cả', style: TextStyle(fontSize: 14.sp))),
                    ...TripStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedStatus = value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildMasonryTripPlansList() {
  return BlocBuilder<TripPlanBloc, TripPlanState>(
    bloc: AppBloc.tripPlanBloc,
    builder: (context, state) {
      // Loading giữ nguyên
      if (state is TripPlanLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      // Lỗi: hiện thông điệp + nút thử lại + CreateTripCard
      if (state is TripPlanError) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ListView(
            children: [
              SizedBox(height: 10.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 36, color: Colors.grey),
                  SizedBox(height: 1.h),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
                  SizedBox(height: 1.h),
                  TextButton.icon(
                    onPressed: () => AppBloc.tripPlanBloc.add(const GetTripPlansEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              CreateTripCard(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, CreateTripScreen.routeName);
                  if (result != null && result is TripPlanModel) {
                    AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                  }
                },
              ),
            ],
          ),
        );
      }

      if (state is GetTripPlansSuccess) {
        final filteredTrips = state.tripPlans
            .where((t) => selectedStatus == null || t.statusEnum == selectedStatus)
            .toList();
        if (filteredTrips.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ListView(
              children: [
                SizedBox(height: 8.h),
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.airplanemode_inactive, size: 36, color: Colors.grey),
                      SizedBox(height: 1.h),
                      Text(
                        'Bạn chưa có hành trình nào',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                CreateTripCard(
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, CreateTripScreen.routeName);
                    if (result != null && result is TripPlanModel) {
                      AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                    }
                  },
                ),
              ],
            ),
          );
        }

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
                    final result = await Navigator.pushNamed(context, CreateTripScreen.routeName);
                    if (result != null && result is TripPlanModel) {
                      AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                    }
                  },
                );
              }

              final trip = filteredTrips[index];
              final cardHeight = (index % 3 == 0) ? 24.h : 30.h;

              return TripPlanCard(
                trip: trip,
                height: cardHeight,
                onUpdated: (_) => AppBloc.tripPlanBloc.add(const GetTripPlansEvent()),
              );
            },
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView(
          children: [
            SizedBox(height: 8.h),
            CreateTripCard(
              onTap: () async {
                final result = await Navigator.pushNamed(context, CreateTripScreen.routeName);
                if (result != null && result is TripPlanModel) {
                  AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

}

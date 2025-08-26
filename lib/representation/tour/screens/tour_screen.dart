// lib/features/tour/presentation/screens/tour_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_mansory_grid.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_search_field.dart';
import 'package:travelogue_mobile/representation/tour/widgets/trip_plan_banner.dart';


class TourScreen extends StatefulWidget {
  const TourScreen({super.key});
  static const String routeName = '/tour';

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(const GetAllToursEvent());
  }

  void _onSearchChanged(String keyword) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TourHeader(),
              SizedBox(height: 2.5.h),

              TourSearchField(onChanged: _onSearchChanged),
              SizedBox(height: 3.h),

              const TitleWithCustoneUnderline(text: "Chuyến đi ", text2: "cá nhân"),
              SizedBox(height: 2.h),
              const TripPlanBanner(),
              SizedBox(height: 3.h),

              const TitleWithCustoneUnderline(text: "Tour tại ", text2: "Tây Ninh"),
              SizedBox(height: 2.h),

              Expanded(
                child: BlocBuilder<TourBloc, TourState>(
                  builder: (context, state) {
                    if (state is TourLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetToursSuccess) {
                      return TourMasonryGrid(tours: state.tours);
                    } else if (state is TourError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_event.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/confirm_booking_dialog.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/tour_guide_card.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/filter_guide_sheet.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_booking_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/core/helpers/auth_helper.dart';

import '../widgets/guide_greeting_header.dart';
import '../widgets/motivation_banner.dart';
import '../widgets/filter_button_row.dart';
import '../widgets/people_count_dialog.dart';

class TourGuideScreen extends StatefulWidget {
  const TourGuideScreen({super.key});
  static const String routeName = '/tour-guides';

  @override
  State<TourGuideScreen> createState() => _TourGuideScreenState();
}

class _TourGuideScreenState extends State<TourGuideScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (_) => FilterGuideSheet(
        onApplyFilter: (TourGuideFilterModel filter) {
          context.read<TourGuideBloc>().add(FilterTourGuideEvent(filter));
        },
      ),
    );
  }

  Future<void> _pickPeopleAndDateThenContinue(TourGuideModel guide) async {
    final people = await PeopleCountDialog.show(context);
    if (people == null) return;

    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      locale: const Locale('vi', 'VN'),
    );
    if (picked == null) return;

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      GuideBookingConfirmationScreen.routeName,
      arguments: {
        'guide': guide,
        'startDate': picked.start,
        'endDate': picked.end,
        'adults': people['adults'],
        'children': people['children'],
       'tripPlanId': '',
      },
    );
  }

  void _confirmBooking(TourGuideModel guide) async {
    if (!isLoggedIn()) {
      Navigator.pushNamed(
        context,
        LoginScreen.routeName,
        arguments: {'redirectRoute': TourGuideScreen.routeName},
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmBookingDialog(guide: guide),
    );
    if (ok == true) {
      _pickPeopleAndDateThenContinue(guide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 2.h,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GuideGreetingHeader(),
              SizedBox(height: 3.h),
              const MotivationBanner(),
              SizedBox(height: 2.h),
              const TitleWithCustoneUnderline(
                  text: "Các hướng dẫn ", text2: "viên"),
              SizedBox(height: 2.h),
              FilterButtonRow(
                onTap: _openFilterSheet,
                color: ColorPalette.primaryColor,
              ),
              Expanded(
                child: BlocBuilder<TourGuideBloc, TourGuideState>(
                  builder: (context, state) {
                    if (state is TourGuideLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TourGuideLoaded) {
                      final guides = state.guides;
                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 4.w,
                        itemCount: guides.length,
                        itemBuilder: (_, i) => Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: TourGuideCard(
                            guide: guides[i],
                            onBookNow: () => _confirmBooking(guides[i]),
                          ),
                        ),
                      );
                    }
                    if (state is TourGuideError) {
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

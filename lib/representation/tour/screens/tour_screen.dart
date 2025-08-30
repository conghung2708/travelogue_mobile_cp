// lib/features/tour/presentation/screens/tour_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_mansory_grid.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_search_delegate.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_search_field.dart';
import 'package:travelogue_mobile/representation/tour/widgets/trip_plan_banner.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/motivation_banner.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});
  static const String routeName = '/tour';

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  Future<void> _openSearch(List<TourModel> tours) async {
    final picked = await showSearch<TourModel?>(
      context: context,
      delegate: TourSearchDelegate(tours),
    );
    if (picked != null) {
      final cover =
          (picked.medias.isNotEmpty ? (picked.medias.first.mediaUrl ?? '') : '')
              .trim();
      final heroImage =
          cover.isNotEmpty ? cover : AssetHelper.img_tay_ninh_login;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TourDetailScreen(
            tour: picked,
            image: heroImage,
            isBooked: false,
            showGuideTab: false,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(const GetAllToursEvent());
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
              BlocBuilder<TourBloc, TourState>(
                buildWhen: (p, c) => c is GetToursSuccess || c is TourLoading,
                builder: (context, state) {
                  final enabled =
                      state is GetToursSuccess && state.tours.isNotEmpty;
                  return GestureDetector(
                    onTap: enabled ? () => _openSearch(state.tours) : null,
                    child: AbsorbPointer(
                      child: TourSearchField(onChanged: (_) {}),
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              const MotivationBanner(),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                  text: "Tour tại ", text2: "Tây Ninh"),
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

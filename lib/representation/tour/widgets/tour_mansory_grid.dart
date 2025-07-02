import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

import 'package:travelogue_mobile/representation/tour/widgets/tour_card.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';

class TourMasonryGrid extends StatelessWidget {
  final List<TourTestModel> tours;
  final List<TourMediaTestModel> medias;
  final List<TourPlanVersionTestModel> versions;
  final List<TourGuideTestModel> guides;

  const TourMasonryGrid({
    super.key,
    required this.tours,
    required this.medias,
    required this.versions,
    required this.guides,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2.h,
      crossAxisSpacing: 4.w,
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        final height = (20 + random.nextInt(10)).h;

        // Lấy media theo tourId
        final selectedMedia = medias
            .where((m) => m.tourId == tour.id)
            .toList()
            .firstOrNull;

        // Lấy version hiện tại theo currentVersionId
        final currentVersionId = tour.currentVersionId;
        final version = versions
            .where((v) => v.id == currentVersionId)
            .toList()
            .firstOrNull;

        // Lấy hướng dẫn viên từ version.tourGuideId
        final guide = version != null
            ? guides
                .where((g) => g.id == version.tourGuideId)
                .toList()
                .firstOrNull
            : null;

        return SizedBox(
          height: height,
          child: TourCard(
            tour: tour,
            media: selectedMedia,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailScreen(
                    tour: tour,
                    media: selectedMedia,
                    guide: guide,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

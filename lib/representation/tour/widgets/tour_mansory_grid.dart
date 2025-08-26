import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_card.dart';

class TourMasonryGrid extends StatelessWidget {
  final List<TourModel> tours;

  const TourMasonryGrid({
    super.key,
    required this.tours,
  });


String _coverImage(TourModel tour) {
  if (tour.medias.isNotEmpty) {
    final url = tour.medias.first.mediaUrl;
    print("👉 Tour ${tour.name} dùng ảnh: $url");
    if (url != null && url.isNotEmpty) return url;
  }
  print("👉 Tour ${tour.name} fallback ảnh default");
  return AssetHelper.img_default;
}
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
        final image = _coverImage(tour); 
        final height = (20 + random.nextInt(10)).h;

        return SizedBox(
          height: height,
          child: TourCard(
            tour: tour,
            image: image,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailScreen(
                    tour: tour,
                    image: image,
                    showGuideTab: false,
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

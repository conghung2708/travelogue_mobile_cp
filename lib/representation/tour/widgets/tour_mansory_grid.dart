import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_card.dart';

class TourMasonryGrid extends StatelessWidget {
  final List<TourModel> tours;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const TourMasonryGrid({
    super.key,
    required this.tours,
    this.shrinkWrap = false,
    this.physics,
  });

  String _coverImage(TourModel tour) {
    if (tour.medias.isNotEmpty) {
      final url = tour.medias.first.mediaUrl;
      if (url != null && url.isNotEmpty) return url;
    }
    return AssetHelper.img_default;
  }

  @override
  Widget build(BuildContext context) {
    const ratios = [1.15];

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2.h,
      crossAxisSpacing: 4.w,
      itemCount: tours.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) {
        final tour = tours[index];
        final image = _coverImage(tour);
        final ratio = ratios[index % ratios.length];

        return TourCard(
          tour: tour,
          image: image,
          headerAspectRatio: ratio, 
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
        );
      },
    );
  }
}

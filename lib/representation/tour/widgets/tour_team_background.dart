import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TourTeamBackground extends StatelessWidget {
  const TourTeamBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetHelper.img_tour_type_selector,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 100.h,
        ),
        Container(color: Colors.black.withOpacity(0.5)),
      ],
    );
  }
}

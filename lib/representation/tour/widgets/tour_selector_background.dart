import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TourSelectorBackground extends StatelessWidget {
  const TourSelectorBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            AssetHelper.img_tour_type_selector,
            fit: BoxFit.cover,
            height: 100.h,
            width: double.infinity,
          ),
          Container(
            height: 100.h,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class HobbyImageCard extends StatelessWidget {
  const HobbyImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: Colors.blueAccent.withOpacity(0.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            AssetHelper.img_hobby,
            height: 32.h,
            width: 85.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

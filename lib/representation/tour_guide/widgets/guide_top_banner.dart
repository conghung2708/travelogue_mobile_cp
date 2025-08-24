import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class GuideTopBanner extends StatelessWidget {
  final TourGuideModel guide;
  final Future<void> Function()? onBackPressed;
  const GuideTopBanner({super.key, required this.guide, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final bg = (guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty)
        ? NetworkImage(guide.avatarUrl!)
        : const AssetImage(AssetHelper.avatar) as ImageProvider;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            image: DecorationImage(image: bg, fit: BoxFit.cover),
          ),
        ),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.35), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          left: 3.w,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4)
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87),
              onPressed: () async => await onBackPressed?.call(),
            ),
          ),
        ),
        Positioned(
          bottom: -6.h,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 6.h,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 5.5.h,
                backgroundImage: bg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

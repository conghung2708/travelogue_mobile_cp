import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';

class TourCard extends StatelessWidget {
  final TourTestModel tour;
  final TourMediaTestModel? media;
  final VoidCallback? onTap;

  const TourCard({
    super.key,
    required this.tour,
    this.media,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = media?.mediaUrl ?? AssetHelper.img_tay_ninh_login;
    final isAsset = !imageUrl.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.w),
        child: Stack(
          children: [
            Positioned.fill(
              child: isAsset
                  ? Image.asset(imageUrl, fit: BoxFit.cover)
                  : Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 3.w,
              bottom: 3.h,
              right: 3.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.name,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          offset: Offset(0.5, 1),
                          blurRadius: 2,
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 0.8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on,
                            color: Colors.white, size: 4.w),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            const Shadow(
                              offset: Offset(0.5, 1),
                              blurRadius: 1,
                              color: Colors.black87,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

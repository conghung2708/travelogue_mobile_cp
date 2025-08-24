import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/discount_tag.dart';

class TourCard extends StatelessWidget {
  final TourModel tour;
  final String image;
  final TourGuideModel? guide;
  final VoidCallback? onTap;
  final bool isDiscount;

  const TourCard({
    super.key,
    required this.tour,
    required this.image,
    this.guide,
    this.onTap,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final isAsset = image.startsWith('assets/');

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.w),
        child: Stack(
          children: [
            Positioned.fill(
              child: isAsset
                  ? Image.asset(image, fit: BoxFit.cover)
                  : Image.network(image, fit: BoxFit.cover),
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
            if (isDiscount)
              Positioned(
                top: 2.w,
                left: 2.w,
                child: const DiscountTag(),
              ),
            Positioned(
              left: 3.w,
              bottom: 3.h,
              right: 3.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.name ?? 'Tour không tên',
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          offset: Offset(0.5, 1),
                          blurRadius: 2,
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 0.5.h),

                  if (guide?.userName != null)
                    Text(
                      'Hướng dẫn: ${guide!.userName}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 1),
                            blurRadius: 1,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),

                  SizedBox(height: 0.8.h),

                  // CTA
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
                          shadows: const [
                            Shadow(
                              offset: Offset(0.5, 1),
                              blurRadius: 1,
                              color: Colors.black87,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

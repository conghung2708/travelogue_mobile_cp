import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/workshop/workshop_list_model.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';

class MasonryItem extends StatelessWidget {
  final WorkshopListModel workshop;
  const MasonryItem({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    final imageUrl = workshop.imageList!.first;
    final priceText =
        workshop.averageRating != null ? "${workshop.averageRating}★" : "N/A";
    // final dateStr = "--/--/----"; 
    final Widget imageWidget = imageUrl.startsWith('http')
        ? Image.network(
            imageUrl,
            width: double.infinity,
            height: 26.w,
            fit: BoxFit.cover,
          )
        : Image.asset(
            imageUrl,
            width: double.infinity,
            height: 26.w,
            fit: BoxFit.cover,
          );

    return GestureDetector(
   onTap: () => Navigator.pushNamed(
  context,
  WorkshopDetailScreen.routeName,
  arguments: workshop.id, 
),

      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.w),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                imageWidget,
                // Positioned(
                //   top: 1.h,
                //   left: 2.w,
                //   child: _chip(
                //     text: dateStr,
                //     bg: Colors.black54,
                //   ),
                // ),
                Positioned(
                  top: 1.h,
                  right: 2.w,
                  child: _chip(
                    text: priceText,
                    gradient: Gradients.defaultGradientBackground,
                  ),
                ),
             
                if (workshop.totalReviews != null)
                  Positioned(
                    bottom: 1.h,
                    right: 2.w,
                    child: _chip(
                      text: "${workshop.totalReviews} đánh giá",
                      bg: Colors.black54,
                    ),
                  ),
              ]),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workshop.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.6.h),
                    Text(workshop.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.3,
                            color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required String text,
    Gradient? gradient,
    Color? bg,
    Color fg = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? bg : null,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

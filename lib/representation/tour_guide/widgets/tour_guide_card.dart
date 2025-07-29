import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/enums/tour_guide_status_enum.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class TourGuideCard extends StatelessWidget {
  final TourGuideTestModel guide;
  const TourGuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.w),
              topRight: Radius.circular(4.w),
            ),
            child: Image.asset(
              guide.avatarUrl,
              height: 18.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 11.sp, color: Colors.amber),
                    SizedBox(width: 1.w),
                    Text(
                      "${guide.rating} • ${guide.reviewsCount} đánh giá",
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${currencyFormat.format(guide.price)} / ngày",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 0.5.h,
                  children: guide.tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 1.5.h),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPalette.primaryColor.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Thêm logic điều hướng
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        "Đặt Ngay",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

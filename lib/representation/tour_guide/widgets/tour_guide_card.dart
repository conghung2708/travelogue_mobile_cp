import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourGuideCard extends StatelessWidget {
  final TourGuideModel guide;

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
            child: guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty
                ? Image.network(
                    guide.avatarUrl!,
                    height: 18.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    AssetHelper.img_default,
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
                  guide.userName ?? "Không rõ tên",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                if (guide.sexText != null || guide.sex != null)
                  Row(
                    children: [
                      Icon(
                        guide.sex == 1 ? Icons.female : Icons.male,
                        size: 13.sp,
                        color: guide.sex == 1 ? Colors.pinkAccent : Colors.blue,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        guide.sexText ??
                            (guide.sex == 1 ? "Nữ" : "Nam"),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 0.5.h),
                if (guide.rating != null)
                  Row(
                    children: [
                      Icon(Icons.star, size: 11.sp, color: Colors.amber),
                      SizedBox(width: 1.w),
                      Text(
                        "${guide.rating!.toStringAsFixed(1)} điểm đánh giá",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 0.5.h),
                if (guide.price != null)
                  Text(
                    "${currencyFormat.format(guide.price)} / ngày",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                SizedBox(height: 0.8.h),
                if (guide.introduction != null &&
                    guide.introduction!.isNotEmpty)
                  Text(
                    guide.introduction!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
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
          ),
        ],
      ),
    );
  }
}

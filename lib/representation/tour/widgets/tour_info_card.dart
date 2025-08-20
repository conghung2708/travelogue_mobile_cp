import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/discount_tag.dart';

class TourInfoCard extends StatelessWidget {
  final TourModel tour;
  final String? mediaUrl;
  final DateTime? startTime;

  const TourInfoCard({
    super.key,
    required this.tour,
    this.mediaUrl,
    this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 24.w,
                  height: 10.h,
                  child: mediaUrl != null && mediaUrl!.startsWith('http')
                      ? Image.network(mediaUrl!, fit: BoxFit.cover)
                      : Image.asset(mediaUrl ?? AssetHelper.img_tay_ninh_login,
                          fit: BoxFit.cover),
                ),
              ),
              if (tour.isDiscount == true)
                const Positioned(top: 0, left: 0, child: DiscountTag()),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🇻🇳 Tây Ninh, Việt Nam',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.shade600)),
                SizedBox(height: 0.5.h),
                Text(tour.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailScreen(
                          tour: tour,
                          image: mediaUrl ?? AssetHelper.img_tay_ninh_login,
                          readOnly: true,
                          startTime: startTime,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text('Xem chi tiết',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                      SizedBox(width: 1.w),
                      Icon(Icons.arrow_forward_ios,
                          size: 14.sp, color: Colors.green),
                    ],
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

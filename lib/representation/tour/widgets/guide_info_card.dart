// lib/features/tour/presentation/widgets/guide_info_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/chip_pill.dart';
import 'package:travelogue_mobile/representation/tour/widgets/star_row.dart';


class GuideInfoCard extends StatelessWidget {
  final TourGuideModel guide;
  const GuideInfoCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    print('GuideInfoCard.toJson = ${guide.toJsonString()}');
    final name = (guide.userName?.isNotEmpty == true)
        ? guide.userName!
        : (guide.email ?? 'Hướng dẫn viên');
    final rating = (guide.averageRating ?? 0).toDouble().clamp(0, 5);
    final reviews = guide.totalReviews ?? 0;
    final price = guide.price;
    final sex = guide.sexText;

  
      print('GuideInfoCard -> name="$name", sexText="$sex"'
          '${guide is dynamic && (guide as dynamic).sex != null ? ', sex="${(guide as dynamic).sex}"' : ''}');
    


    final avatar = (guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty)
        ? NetworkImage(guide.avatarUrl!)
        : const AssetImage(AssetHelper.img_default) as ImageProvider;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Colors.blue.withOpacity(0.08), Colors.cyan.withOpacity(0.05), Colors.white],
        ),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      padding: EdgeInsets.all(3.5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2.2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF7DD3FC), Color(0xFF60A5FA)]),
                ),
                child: CircleAvatar(
                  radius: 21.sp, backgroundColor: Colors.white,
                  child: CircleAvatar(radius: 19.sp, backgroundImage: avatar),
                ),
              ),
              Positioned(
                bottom: -2, right: -2,
                child: Container(
                  width: 16, height: 16, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Container(margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 3.5.w),

          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(name,
                      style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF3B82F6)),
                ]),
                SizedBox(height: 0.6.h),
                Row(
                  children: [
                    StarRow(rating: rating),
                    SizedBox(width: 1.2.w),
                    Text('${rating.toStringAsFixed(1)} (${NumberFormat('#,###').format(reviews)})',
                        style: TextStyle(fontSize: 11.5.sp, color: Colors.black54)),
                  ],
                ),
                SizedBox(height: 0.7.h),
                Wrap(
                  spacing: 8, runSpacing: 6,
                  children: [
                    // if (price != null)
                    //   ChipPill(
                    //     icon: Icons.payments_rounded,
                    //     label: 'Phí: ${NumberFormat('#,###').format(price.round())}đ',
                    //   ),
                    if (sex?.isNotEmpty == true)
                      ChipPill(icon: Icons.wc_rounded, label: sex!, tone: ChipTone.neutral),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

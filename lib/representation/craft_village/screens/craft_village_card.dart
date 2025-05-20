import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/craft_village_model.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';

class CraftVillageCard extends StatelessWidget {
  final CraftVillageModel craftVillage;

  const CraftVillageCard({
    super.key,
    required this.craftVillage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.sp),
        onTap: () {
          Navigator.of(context).pushNamed(
            CraftVillageDetailScreen.routeName,
            arguments: craftVillage,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.sp)),
              child: Image.asset(
                craftVillage.imageList.first,
                height: 12.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 60,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    craftVillage.name,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(height: 0.8.h),
                  // Text(
                  //   craftVillage.description,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     fontSize: 12.sp,
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 14.sp, color: Colors.blueGrey),
                      SizedBox(width: 1.w),
                      Text(
                        "${craftVillage.imageList.length} ảnh",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.handyman, size: 14.sp, color: Colors.orange),
                      SizedBox(width: 1.w),
                      Text(
                        "Thủ công",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.orange,
                        ),
                      ),
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

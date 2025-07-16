import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_card.dart';

class CraftVillages extends StatelessWidget {
  const CraftVillages({super.key});

  @override
  Widget build(BuildContext context) {
    return craftVillages.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              _buildSectionTitle(
                Icons.holiday_village,
                "Làng nghề truyền thống",
                Colors.blue,
              ),
              Container(
                height: 26.h,
                margin: EdgeInsets.only(top: 1.h),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CraftVillageCard(
                      craftVillage: craftVillages[index],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 3.w),
                  itemCount: craftVillages.length,
                ),
              ),
            ],
          );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 2.w),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

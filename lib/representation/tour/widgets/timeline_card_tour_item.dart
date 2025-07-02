import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_craft_village_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_cuisine_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_location_test_model.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class TimelineCardTourItem extends StatelessWidget {
  final dynamic item;
  final String name;
  final List<String> imageUrls;
  final String? description;

  const TimelineCardTourItem({
    super.key,
    required this.item,
    required this.name,
    required this.imageUrls,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? start = item.startTime;
    final DateTime? end = item.endTime;
    final bool showTime = start != null && end != null;

    final Icon icon = _getIcon(item);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: icon,
            title: Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: showTime
                ? Text(
                    '🕘 ${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}',
                    style: TextStyle(fontSize: 12.sp),
                  )
                : null,
          ),
          if (description != null && description!.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
              child: Text(
                '📝 $description',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
          if (imageUrls.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ImageGridPreview(images: imageUrls),
            ),
          Divider(height: 3.h),
        ],
      ),
    );
  }

  Icon _getIcon(dynamic item) {
    if (item is TourPlanLocationTestModel) {
      return const Icon(Icons.place, color: Colors.deepPurple);
    } else if (item is TourPlanCuisineTestModel) {
      return const Icon(Icons.restaurant, color: Colors.redAccent);
    } else if (item is TourPlanCraftVillageTestModel) {
      return const Icon(Icons.handyman, color: Colors.orange);
    }
    return const Icon(Icons.help_outline, color: Colors.grey);
  }
}

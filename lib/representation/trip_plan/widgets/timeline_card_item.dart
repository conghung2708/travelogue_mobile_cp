import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class TimelineCardItem extends StatelessWidget {
  final dynamic item;

  const TimelineCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String name = '';
    String note = '';
    DateTime start = item.startTime;
    DateTime end = item.endTime;
    List<String> images = [];
    Icon icon = const Icon(Icons.help, color: Colors.grey);

    if (item is TripPlanLocation) {
      name = item.location.name!;
      note = item.note;
      images = (item.location.medias ?? [])
          .map((e) => e.mediaUrl ?? '')
          .cast<String>()
          .toList();
      icon = const Icon(Icons.place, color: Colors.deepPurple);
    } else if (item is TripPlanCuisine) {
      name = item.restaurant.name!;
      note = item.note;
      images = (item.restaurant.medias ?? [])
          .map((e) => e.mediaUrl ?? '')
          .cast<String>()
          .toList();
      icon = const Icon(Icons.restaurant, color: Colors.redAccent);
    } else if (item is TripPlanCraftVillage) {
      name = item.craftVillage.name;
      note = item.note;
      images = item.craftVillage.imageList;
      icon = const Icon(Icons.handyman, color: Colors.orange);
    }

   
    final bool showTime = start.hour != 0 || end.hour != 0;

    return Padding(
      padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: icon,
            title: Text(
              name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: showTime
                ? Text('🕘 ${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}')
                : null,
          ),
          if (note.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
              child: Text(
                '📝 $note',
                style: TextStyle(fontSize: 13.sp, fontStyle: FontStyle.italic),
              ),
            ),
          if (images.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ImageGridPreview(images: images),
            ),
          Divider(height: 3.h),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class TimelineCardTourItem extends StatelessWidget {
  final dynamic item;
  final String name;
  final List<String> imageUrls;
  final String? description;
  final String? duration;
  final String? note;

  const TimelineCardTourItem({
    super.key,
    required this.item,
    required this.name,
    required this.imageUrls,
    this.description,
    this.duration,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? start = item.startTime;
    final DateTime? end = item.endTime;
    final bool showTime = start != null && end != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            minVerticalPadding: 0,
            // leading: _getIcon(item),
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

          Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (duration != null && duration!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.teal),
                      SizedBox(width: 2.w),
                      Text(
                        duration!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (note != null && note!.isNotEmpty) ...[
                  SizedBox(height: 0.6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.sticky_note_2_outlined,
                          size: 16, color: Colors.orange),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          note!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
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
}

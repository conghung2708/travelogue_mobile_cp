import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TimelineCardItem extends StatelessWidget {
  final dynamic item;

  const TimelineCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String name = item.name ?? 'Không có tên';
    String note = item.notes ?? '';
    String imageUrl = item.imageUrl ?? '';
    DateTime start = item.startTime;
    DateTime end = item.endTime;
    final bool showTime = start.hour != 0 || end.hour != 0;

    Icon icon = const Icon(Icons.help, color: Colors.grey);
    switch (item.type?.toLowerCase()) {
      case 'địa điểm lịch sử':
        icon = const Icon(Icons.place, color: Colors.deepPurple);
        break;
      case 'ẩm thực':
        icon = const Icon(Icons.restaurant, color: Colors.redAccent);
        break;
      case 'làng nghề':
        icon = const Icon(Icons.handyman, color: Colors.orange);
        break;
      default:
        icon = const Icon(Icons.explore, color: Colors.blueGrey);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              icon,
              SizedBox(height: 0.8.h),
              if (showTime)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text(
                    '${DateFormat.Hm().format(start)}\n↓\n${DateFormat.Hm().format(end)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          SizedBox(width: 3.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 17.w,
                    height: 17.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 24),
                  )
                : Container(
                    width: 12.w,
                    height: 12.w,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 24),
                  ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                if (note.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Text(
                      '📝 $note',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
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

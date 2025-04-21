import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tay_ninh_location.dart';

class TayNinhTimelineScreen extends StatelessWidget {
  final List<List<TayNinhLocation>> schedule;

  const TayNinhTimelineScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '✨ Gợi ý lịch trình',
          style: TextStyle(fontFamily: "Pattaya"),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: schedule.length,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemBuilder: (context, dayIndex) {
          final day = schedule[dayIndex];

          return Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📅 Ngày ${dayIndex + 1}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                ),
                SizedBox(height: 2.h),
                ...day.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.all(1.5.w),
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconForTime(item.time),
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                          if (i != day.length - 1)
                            Container(
                              width: 2,
                              height: 7.h,
                              color: Colors.teal.shade200,
                            ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      Expanded(child: _buildCard(item)),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(TayNinhLocation loc) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loc.time} (${loc.duration}) – ${loc.title}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(height: 1.h),
            Text('→ ${loc.desc}', style: TextStyle(fontSize: 13.sp)),
            if (loc.tip.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_outlined,
                      color: Colors.orange, size: 20),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Mẹo: ${loc.tip}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForTime(String time) {
    if (time.contains('Sáng')) {
      return Icons.wb_sunny;
    }
    if (time.contains('Trưa')) {
      return Icons.lunch_dining;
    }
    if (time.contains('Chiều')) {
      return Icons.wb_twilight;
    }
    if (time.contains('Tối')) {
      return Icons.nightlight;
    }
    return Icons.access_time;
  }
}

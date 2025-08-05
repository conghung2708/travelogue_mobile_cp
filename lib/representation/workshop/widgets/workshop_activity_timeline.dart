import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/workshop/day_model.dart';
import 'package:travelogue_mobile/model/workshop/activity_model.dart';

class WorkshopActivityTimeline extends StatefulWidget {
  final List<DayModel> days;
  const WorkshopActivityTimeline(this.days, {super.key});

  @override
  State<WorkshopActivityTimeline> createState() => _TimelineState();
}

class _TimelineState extends State<WorkshopActivityTimeline> {
  final _listKey = GlobalKey<AnimatedListState>();
  late final List<ActivityModel> _acts;

  @override
  void initState() {
    super.initState();
    _acts = widget.days.expand((d) => d.activities).toList();
    _revealSteps();
  }

  void _revealSteps() async {
    for (var i = 0; i < _acts.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_acts.isEmpty) {
      return const Center(child: Text('Chưa có nội dung'));
    }

    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      physics: const ClampingScrollPhysics(),
      initialItemCount: 0,
      itemBuilder: (_, index, animation) {
        final a = _acts[index];
        final time =
            '${a.startTimeFormatted ?? ''} – ${a.endTimeFormatted ?? ''}';
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.2), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOut)),
            child: _buildTimelineTile(index, a, time),
          ),
        );
      },
    );
  }

  Widget _buildTimelineTile(int i, ActivityModel a, String time) {
    final isFirst = i == 0;
    final isLast = i == _acts.length - 1;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.08,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 10.w,
        height: 10.w,
        drawGap: true,
        indicator: _numberBadge(i + 1),
      ),
      beforeLineStyle:
          LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),
      afterLineStyle:
          LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),
      endChild: Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
        child: _ActivityCard(activity: a, time: time),
      ),
    );
  }

  Widget _numberBadge(int n) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPalette.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1.5.w,
              offset: Offset(0, 1.2.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$n',
          style: TextStyle(
              fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
}

class _ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String time;
  const _ActivityCard({required this.activity, required this.time});

  @override
  Widget build(BuildContext context) {
    final imagePath = (activity.imageUrl != null &&
            activity.imageUrl!.isNotEmpty)
        ? activity.imageUrl!
        : AssetHelper.img_default;

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.grey.shade300, width: .3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.5.w,
            offset: Offset(0, .8.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imagePath.startsWith('http')
                ? Image.network(imagePath,
                    width: double.infinity,
                    height: 12.h,
                    fit: BoxFit.cover)
                : Image.asset(imagePath,
                    width: double.infinity,
                    height: 12.h,
                    fit: BoxFit.cover),
          ),
          SizedBox(height: 1.h),

         
          Text(activity.activity ?? '',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: .6.h),

          // Thời gian + duration
          if (time.trim().isNotEmpty || activity.duration != null)
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 15.sp, color: Colors.grey.shade600),
                SizedBox(width: 2.w),
                Text(
                  time,
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
                ),
                if (activity.duration != null) ...[
                  SizedBox(width: 2.w),
                  Text('(${activity.duration} phút)',
                      style: TextStyle(
                          fontSize: 11.sp, color: Colors.grey.shade500)),
                ]
              ],
            ),

          // Mô tả
          if (activity.description != null &&
              activity.description!.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(activity.description!,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
          ],

          // Ghi chú
          if (activity.notes != null && activity.notes!.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💡 ', style: TextStyle(fontSize: 14.sp)),
                Expanded(
                  child: Text(activity.notes!,
                      style: TextStyle(
                          fontSize: 11.sp, color: Colors.blueGrey[700])),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}

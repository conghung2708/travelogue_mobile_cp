// workshop_activity_timeline.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_activity_test_model.dart';

class WorkshopActivityTimeline extends StatefulWidget {
  final List<WorkshopActivityTestModel> activities;
  const WorkshopActivityTimeline(this.activities, {super.key});

  @override
  State<WorkshopActivityTimeline> createState() => _TimelineState();
}

class _TimelineState extends State<WorkshopActivityTimeline> {
  final _listKey = GlobalKey<AnimatedListState>();
  late final List<WorkshopActivityTestModel> _acts = widget.activities;

  @override
  void initState() {
    super.initState();
    _revealSteps();
  }

  // chèn từng tile vào AnimatedList
  void _revealSteps() async {
    for (var i = 0; i < _acts.length; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_acts.isEmpty) return const Center(child: Text('Chưa có nội dung'));

    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      physics: const ClampingScrollPhysics(),
      initialItemCount: 0, 
      itemBuilder: (_, index, animation) {
        final a    = _acts[index];
        final time = '${a.startTime ?? ''} – ${a.endTime ?? ''}'.replaceAll(':00', '');
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: Offset(0, 0.2), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: _buildTimelineTile(index, a, time),
          ),
        );
      },
    );
  }

  Widget _buildTimelineTile(
      int i, WorkshopActivityTestModel a, String time) {
    final isFirst = i == 0;
    final isLast  = i == _acts.length - 1;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.08,
      isFirst: isFirst,
      isLast : isLast,

      indicatorStyle: IndicatorStyle(
        width : 10.w,
        height: 10.w,
        drawGap: true,
        indicator: _numberBadge(i + 1),
      ),
      beforeLineStyle: LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),
      afterLineStyle : LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),

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

/* ---------- CARD NỘI DUNG ---------- */
class _ActivityCard extends StatelessWidget {
  final WorkshopActivityTestModel activity;
  final String time;
  const _ActivityCard({required this.activity, required this.time});

  @override
  Widget build(BuildContext context) => Container(
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
            Text(activity.activity,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: .8.h),
            // Row(
            //   children: [
            //     Icon(Icons.access_time, size: 16.sp, color: Colors.grey.shade600),
            //     SizedBox(width: 2.w),
            //     Text(time,
            //         style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700)),
            //   ],
            // ),
            if (activity.description != null) ...[
              SizedBox(height: 1.h),
              Text(activity.description!,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
            ],
            if (activity.notes != null) ...[
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 ', style: TextStyle(fontSize: 14.sp)),
                  Expanded(
                    child: Text(activity.notes!,
                        style: TextStyle(fontSize: 11.sp, color: Colors.blueGrey)),
                  ),
                ],
              )
            ],
          ],
        ),
      );
}

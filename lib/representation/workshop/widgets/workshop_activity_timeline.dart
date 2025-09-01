import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
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
      await Future.delayed(const Duration(milliseconds: 250));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_acts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Text(
            'Chưa có nội dung hoạt động',
            style: TextStyle(fontSize: 12.5.sp, color: Colors.black45),
          ),
        ),
      );
    }

    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      physics: const ClampingScrollPhysics(),
      initialItemCount: 0,
      itemBuilder: (_, index, animation) {
        final a = _acts[index];

        final hasAnyTime = (a.startTimeFormatted ?? '').trim().isNotEmpty ||
            (a.endTimeFormatted ?? '').trim().isNotEmpty;
        final timeStr = hasAnyTime
            ? '${(a.startTimeFormatted ?? '').trim()} – ${(a.endTimeFormatted ?? '').trim()}'
            : '';

        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .18), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: _buildTimelineTile(index, a, timeStr),
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
        width: 10.5.w,
        height: 10.5.w,
        drawGap: true,
        indicator: _numberBadge(i + 1),
      ),
      beforeLineStyle:
          LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),
      afterLineStyle:
          LineStyle(thickness: 1.w, color: ColorPalette.primaryColor),
      endChild: Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
        child: _ActivityCard(
          activity: a,
          time: time,
        ),
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
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
}

class _ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String time;
  const _ActivityCard({required this.activity, required this.time});

  IconData _pickIcon(String titleLower) {
    if (titleLower.contains('hướng dẫn') || titleLower.contains('giới thiệu')) {
      return Icons.school_rounded;
    }
    if (titleLower.contains('thực hành') || titleLower.contains('workshop')) {
      return Icons.handyman_rounded;
    }
    if (titleLower.contains('trưng bày') || titleLower.contains('triển lãm')) {
      return Icons.emoji_events_rounded;
    }
    if (titleLower.contains('di chuyển') || titleLower.contains('đi bộ')) {
      return Icons.directions_walk_rounded;
    }
    return Icons.auto_awesome_rounded;
  }

  Color _seed(String s) {
    int h = 0;
    for (final c in s.runes) {
      h = (h * 31 + c) & 0xFFFFFFFF;
    }
    final base = (h % 200) + 20;
    return HSLColor.fromAHSL(1, base.toDouble(), 0.55, 0.58).toColor();
  }

  Widget _fallbackHero(BuildContext context, String title) {
    final c = _seed(title);
    final c2 = HSLColor.fromColor(c).withLightness(0.90).toColor();
    final c3 = HSLColor.fromColor(c).withLightness(0.75).toColor();

    final icon = _pickIcon(title.toLowerCase());
    final initials = title.isNotEmpty ? title[0].toUpperCase() : 'W';

    return Container(
      height: 13.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [c2, c3]),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 3.w, bottom: 1.2.h),
              child: Icon(icon, size: 42.sp, color: Colors.black12),
            ),
          ),
          Center(
            child: Container(
              width: 10.h,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: c.withOpacity(.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: c,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {IconData? icon}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: .8.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: Colors.black87),
            SizedBox(width: 1.5.w),
          ],
          Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 11.2.sp,
              height: 1.0,
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final hasImg = (activity.imageUrl ?? '').trim().isNotEmpty;
    final title = (activity.activity ?? '').trim();
    final desc = (activity.description ?? '').trim();
    final notes = (activity.notes ?? '').trim();
    final hasDuration = (activity.durationMinutes ?? 0) > 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.grey.shade200, width: .4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.6.w,
            offset: Offset(0, .9.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // media
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasImg
                ? Image.network(
                    activity.imageUrl!,
                    width: double.infinity,
                    height: 13.h,
                    fit: BoxFit.cover,
                  )
                : _fallbackHero(context, title),
          ),
          SizedBox(height: 1.2.h),

          // header: icon + title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: _seed(title).withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _pickIcon(title.toLowerCase()),
                  size: 16.sp,
                  color: _seed(title),
                ),
              ),
              SizedBox(width: 2.4.w),
              Expanded(
                child: Text(
                  title.isNotEmpty ? title : 'Hoạt động',
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: .8.h),

          if (time.trim().isNotEmpty || hasDuration)
            Wrap(
              spacing: 2.w,
              runSpacing: 1.w,
              children: [
                if (time.trim().isNotEmpty)
                  _chip(time, icon: Icons.access_time_rounded),
                if (hasDuration)
                  _chip('${activity.durationMinutes} phút',
                      icon: Icons.timer_outlined),
              ],
            ),

          if (desc.isNotEmpty) ...[
            SizedBox(height: 1.2.h),
            Text(
              desc,
              style: TextStyle(
                  fontSize: 12.2.sp, color: Colors.black87, height: 1.35),
            ),
          ],

          if (notes.isNotEmpty) ...[
            SizedBox(height: 1.2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2EEFF)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 ', style: TextStyle(fontSize: 14.5.sp)),
                  Expanded(
                    child: Text(
                      notes,
                      style: TextStyle(
                          fontSize: 11.8.sp,
                          color: Colors.blueGrey[700],
                          height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

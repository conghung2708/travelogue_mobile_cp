import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_schedule_card.dart';

class WorkshopScheduleTab extends StatelessWidget {
  final WorkshopDetailModel workshop;
  final String workshopName;
  final List<ScheduleModel> schedules;
  final bool readOnly;

  const WorkshopScheduleTab({
    super.key,
    required this.workshopName,
    required this.schedules,
    required this.workshop,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return const Center(child: Text('Chưa có lịch'));
    }

    schedules.sort((a, b) {
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;
      return a.startTime!.compareTo(b.startTime!);
    });

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: schedules.length,
      separatorBuilder: (_, __) => SizedBox(height: 2.h),
      itemBuilder: (_, i) => WorkshopScheduleCard(
        workshop: this.workshop,
        schedule: schedules[i],
        workshopName: workshopName,
        readOnly: readOnly
      ),
    );
  }
}

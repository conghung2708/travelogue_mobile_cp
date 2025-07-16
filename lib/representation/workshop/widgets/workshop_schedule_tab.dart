import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_schedule_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_schedule_card.dart';

class WorkshopScheduleTab extends StatelessWidget {
  final WorkshopTestModel workshop;                     
  final List<WorkshopScheduleTestModel> schedules;     

  const WorkshopScheduleTab({
    super.key,
    required this.workshop,
    required this.schedules,
  });


  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return const Center(child: Text('Chưa có lịch'));
    }

    schedules.sort((a, b) =>
        DateTime.parse(a.startTime).compareTo(DateTime.parse(b.startTime)));

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: schedules.length,
      separatorBuilder: (_, __) => SizedBox(height: 2.h),
      itemBuilder: (_, i) => WorkshopScheduleCard(
        s: schedules[i],
        w: workshop,
      ),
    );
  }

}
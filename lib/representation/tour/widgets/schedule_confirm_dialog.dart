import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_team_selector_screen.dart';

import 'package:travelogue_mobile/representation/tour/widgets/guide_info_card.dart';

// đổi từ Stateless -> Stateful
class ScheduleConfirmDialog extends StatefulWidget {
  final TourModel tour;
  final TourScheduleModel schedule;
  final bool isGroupTour;
  final String media;
  final NumberFormat formatter;

  const ScheduleConfirmDialog({
    super.key,
    required this.tour,
    required this.schedule,
    required this.isGroupTour,
    required this.media,
    required this.formatter,
  });

  static Future<void> show(
    BuildContext context, {
    required TourModel tour,
    required TourScheduleModel schedule,
    required bool isGroupTour,
    required String media,
    required NumberFormat formatter,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 24),
        backgroundColor: Colors.white,
        child: ScheduleConfirmDialog(
          tour: tour,
          schedule: schedule,
          isGroupTour: isGroupTour,
          media: media,
          formatter: formatter,
        ),
      ),
    );
  }

  @override
  State<ScheduleConfirmDialog> createState() => _ScheduleConfirmDialogState();
}

class _ScheduleConfirmDialogState extends State<ScheduleConfirmDialog> {
  Future<TourGuideModel?>? _futureGuide;

  @override
  void initState() {
    super.initState();
    final embedded = widget.schedule.tourGuide;
    final id = embedded?.id;
    if (id != null && id.isNotEmpty) {
      _futureGuide = TourGuideRepository().getTourGuideById(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.schedule;
    final departure = schedule.startTime!;
    final availableSlot =
        (schedule.maxParticipant ?? 0) - (schedule.currentBooked ?? 0);

    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available, size: 28.sp, color: ColorPalette.primaryColor),
          SizedBox(height: 2.h),
          Text("Xác nhận ngày khởi hành",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: ColorPalette.primaryColor)),
          SizedBox(height: 2.h),
          _Row(icon: Icons.calendar_today, label: 'Ngày đi:', value: DateFormat('dd/MM/yyyy').format(departure)),
          SizedBox(height: 1.h),
          _Row(icon: Icons.monetization_on, label: 'Giá:', value: '${widget.formatter.format(schedule.adultPrice?.round() ?? 0)}đ'),
          SizedBox(height: 1.h),
          _Row(icon: Icons.people_outline, label: 'Còn lại:', value: '$availableSlot chỗ'),
          SizedBox(height: 3.h),


          if (schedule.tourGuide != null) ...[
            const Divider(),
            SizedBox(height: 1.h),
            const _SectionTitle(title: 'Hướng dẫn viên'),
            SizedBox(height: 1.h),

            if (_futureGuide != null)
              FutureBuilder<TourGuideModel?>(
                future: _futureGuide,
                builder: (context, snap) {
                  final guide = snap.data ?? schedule.tourGuide!;
   
                  print('Guide in dialog -> ${guide.toJsonString()}');

                  if (snap.connectionState == ConnectionState.waiting) {
                    return Row(children: const [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Đang tải hướng dẫn viên...')
                    ]);
                  }
                  return GuideInfoCard(guide: guide);
                },
              )
            else
              GuideInfoCard(guide: schedule.tourGuide!),

            SizedBox(height: 2.h),
          ],

  
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Huỷ"),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.isGroupTour) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TourTeamSelectorScreen(
                            tour: widget.tour,
                            schedule: schedule,
                            media: widget.media,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        TourPaymentConfirmationScreen.routeName,
                        arguments: {
                          'tour': widget.tour,
                          'schedule': schedule,
                          'media': widget.media,
                          'startTime': schedule.startTime!,
                          'adults': 1,
                          'children': 0,
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Chọn ngày này",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorPalette.primaryColor, size: 20.sp),
        SizedBox(width: 2.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 15.sp),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                      fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE), shape: BoxShape.circle),
          padding: EdgeInsets.all(1.w),
          child: const Icon(Icons.person_rounded,
              color: Color(0xFF0284C7), size: 18),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.3),
        ),
        SizedBox(width: 1.w),
        Expanded(
            child:
                Divider(color: Colors.grey.shade300, thickness: 1, indent: 8)),
      ],
    );
  }
}

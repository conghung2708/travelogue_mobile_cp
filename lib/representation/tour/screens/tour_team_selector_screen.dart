// lib/features/tour/presentation/screens/tour_team_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/person_counter_row.dart';
import 'package:travelogue_mobile/representation/tour/widgets/total_price_bar.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_back_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_summary_card.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_title.dart';


class TourTeamSelectorScreen extends StatefulWidget {
  static const String routeName = '/tour-team-selector';
  final TourModel tour;
  final TourScheduleModel schedule;
  final String media;

  const TourTeamSelectorScreen({
    super.key,
    required this.tour,
    required this.schedule,
    required this.media,
  });

  @override
  State<TourTeamSelectorScreen> createState() => _TourTeamSelectorScreenState();
}

class _TourTeamSelectorScreenState extends State<TourTeamSelectorScreen> {
  int adultCount = 1;
  int childrenCount = 0;
  final formatter = NumberFormat('#,###');

  int get availableSlot =>
      (widget.schedule.maxParticipant ?? 0) - (widget.schedule.currentBooked ?? 0);
  int get totalPeople => adultCount + childrenCount;
  int get remainingSlot => availableSlot - totalPeople;
  double get totalPrice =>
      (adultCount * (widget.schedule.adultPrice ?? 0)) +
      (childrenCount * (widget.schedule.childrenPrice ?? 0));

  bool canAdd() => totalPeople < availableSlot;

  void _limitSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bạn chỉ có thể chọn tối đa $availableSlot người.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TourPaymentConfirmationScreen(
          tour: widget.tour,
          schedule: widget.schedule,
          startTime: widget.schedule.startTime,
          adults: adultCount,
          children: childrenCount,
          media: widget.media,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const TourTeamBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TourBackButton(),
                  SizedBox(height: 3.h),

                  const TourTeamTitle(),
                  TourTeamSummaryCard(
                    tour: widget.tour,
                    schedule: widget.schedule,
                    mediaUrl: widget.media,
                    formatter: formatter,
                  ),

                  SizedBox(height: 2.h),
                  PersonCounterRow(
                    label: "Người lớn",
                    value: adultCount,
                    isAdult: true,
                    unitPrice: widget.schedule.adultPrice ?? 0,
                    onChanged: (v) => setState(() => adultCount = v),
                    canAdd: canAdd,
                    onLimit: _limitSnack,
                  ),
                  SizedBox(height: 1.5.h),
                  PersonCounterRow(
                    label: "Trẻ em",
                    value: childrenCount,
                    isAdult: false,
                    unitPrice: widget.schedule.childrenPrice ?? 0,
                    onChanged: (v) => setState(() => childrenCount = v),
                    canAdd: canAdd,
                    onLimit: _limitSnack,
                  ),

                  SizedBox(height: 1.5.h),
                  Text(
                    canAdd()
                        ? '👥 Bạn có thể thêm tối đa $remainingSlot người.'
                        : '⚠️ Đã đạt giới hạn số người ($availableSlot)',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: canAdd() ? Colors.white70 : Colors.yellow,
                    ),
                  ),

                  const Spacer(),
                  TotalPriceBar(
                    totalPriceText: "Tổng: ${formatter.format(totalPrice)}đ",
                    buttonText: "Tiếp tục",
                    onPressed: _goNext,
                    color: ColorPalette.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/features/tour/presentation/screens/tour_payment_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/widgets/agreement_checkbox.dart';
import 'package:travelogue_mobile/representation/tour/widgets/confirm_payment_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_summary_card.dart';
import 'package:travelogue_mobile/representation/tour/widgets/policy_markdown_box.dart';
import 'package:travelogue_mobile/representation/tour/widgets/support_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_info_card.dart';
class TourPaymentConfirmationScreen extends StatefulWidget {
  static const routeName = '/tour-payment-confirmation';

  final TourModel tour;
  final TourScheduleModel schedule;
  final String? media;
  final DateTime? startTime;
  final int adults;
  final int children;
  final String? bookingId;

  const TourPaymentConfirmationScreen({
    super.key,
    required this.tour,
    required this.schedule,
    this.media,
    this.startTime,
    this.adults = 1,
    this.children = 0,
    this.bookingId,
  });

  @override
  State<TourPaymentConfirmationScreen> createState() =>
      _TourPaymentConfirmationScreenState();
}

class _TourPaymentConfirmationScreenState extends State<TourPaymentConfirmationScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final double adultTotal = widget.adults * (widget.schedule.adultPrice ?? 0);
    final double childrenTotal = widget.children * (widget.schedule.childrenPrice ?? 0);
    final double totalPrice = adultTotal + childrenTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            PaymentHeader(startTime: widget.startTime),
            TourInfoCard(
              tour: widget.tour,
              mediaUrl: widget.media,
              startTime: widget.startTime,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentSummaryCard(
                      adults: widget.adults,
                      children: widget.children,
                      schedule: widget.schedule,
                      totalPrice: totalPrice,
                      formatter: formatter,
                    ),
                    SizedBox(height: 2.h),
                    const TitleWithCustoneUnderline(
                      text: '📘 Điều khoản & ',
                      text2: 'Trách nhiệm dịch vụ',
                    ),
                    SizedBox(height: 1.h),
                    const PolicyMarkdownBox(),
                    SizedBox(height: 1.5.h),
                    AgreementCheckbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                    ),
                    const SupportButton(),
                    SizedBox(height: 2.h),
                    ConfirmPaymentButton(
                      enabled: _agreed,
                      tour: widget.tour,
                      schedule: widget.schedule,
                      startTime: widget.startTime,
                      adults: widget.adults,
                      children: widget.children,
                      bookingId: widget.bookingId,
                      media: widget.media,
                      
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

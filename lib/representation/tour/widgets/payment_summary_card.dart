// lib/features/tour/presentation/widgets/payment_summary_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class PaymentSummaryCard extends StatelessWidget {
  final int adults;
  final int children;
  final TourScheduleModel schedule;
  final double totalPrice;
  final NumberFormat formatter;

  const PaymentSummaryCard({
    super.key,
    required this.adults,
    required this.children,
    required this.schedule,
    required this.totalPrice,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.receipt_long_rounded, color: Colors.deepOrange),
            SizedBox(width: 2.w),
            Text('Chi tiết thanh toán',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade700)),
          ]),
          SizedBox(height: 1.5.h),
          _priceRow('👨 Người lớn', adults, schedule.adultPrice ?? 0),
          _priceRow('🧒 Trẻ em', children, schedule.childrenPrice ?? 0),
          Divider(height: 2.5.h, color: Colors.grey.shade400),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('💰 Tổng cộng:',
                style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade900)),
            Text('${formatter.format(totalPrice)}đ',
                style:  TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.bold, color: ColorPalette.primaryColor)),
          ]),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int qty, double price) {
    final f = NumberFormat('#,###');
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.4.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('$label x$qty', style: TextStyle(fontSize: 13.5.sp, color: Colors.brown.shade800)),
        Text('${f.format(qty * price)}đ',
            style:  TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
      ]),
    );
  }
}

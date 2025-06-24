import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TripPendingActionCard extends StatelessWidget {
  final NumberFormat currencyFormat;
  final double price;

  const TripPendingActionCard({
    super.key,
    required this.currencyFormat,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final priceText = currencyFormat.format(price);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: Colors.blue.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.temple_buddhist, color: Colors.blueAccent, size: 20.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Yêu cầu đặt tour đang chờ xác nhận...',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '🎯 Giá dự kiến: $priceText',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã gửi lại yêu cầu xác nhận.")),
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              label: Text(
                "Gửi lại yêu cầu",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blueAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.3.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

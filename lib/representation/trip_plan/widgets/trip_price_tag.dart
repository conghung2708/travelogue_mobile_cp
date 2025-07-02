import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TripPriceTag extends StatelessWidget {
  final double price;
  final NumberFormat currencyFormat;

  const TripPriceTag({
    super.key,
    required this.price,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
      child: Row(
        children: [
          Icon(Icons.payments_rounded,
              color: Colors.indigo.shade700, size: 16.sp),
          SizedBox(width: 1.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Giá: ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: currencyFormat.format(price),
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    color: Colors.indigo.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class WorkshopBottomBar extends StatelessWidget {
  final String price;
  const WorkshopBottomBar({super.key, required this.price});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(.12),
                offset: const Offset(0, -2))
          ],
        ),
        child: Row(children: [
          Text(price,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange)),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.2.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w)),
            ),
            onPressed: () {/* TODO booking */},
            child: Text('ĐẶT CHỖ', style: TextStyle(fontSize: 12.5.sp)),
          )
        ]),
      );
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateTripCard extends StatelessWidget {
  final VoidCallback onTap;

  const CreateTripCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.blueAccent,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: Radius.circular(4.w),
      dashPattern: [6, 3],
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 24.h,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, size: 8.w, color: Colors.blue),
              SizedBox(height: 1.h),
              Text('Tạo hành trình mới', style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

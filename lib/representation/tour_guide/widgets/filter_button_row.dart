import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilterButtonRow extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  const FilterButtonRow({super.key, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: color, size: 18.sp),
                SizedBox(width: 1.w),
                Text('Bộ lọc',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: color,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

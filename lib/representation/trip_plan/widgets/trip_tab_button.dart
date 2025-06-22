import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TripTabButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const TripTabButton({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigoAccent : Colors.grey[100],
          borderRadius: BorderRadius.circular(6.w),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 6)]
              : [],
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                color: isSelected ? Colors.white : Colors.black54, size: 14.sp),
            SizedBox(width: 1.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

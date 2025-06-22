import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HobbySaveButton extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onTap;

  const HobbySaveButton({
    super.key,
    required this.selectedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 6.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Color(0xFF81D4FA), Color(0xFF0288D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore_rounded, color: Colors.white),
              SizedBox(width: 2.w),
              Text(
                selectedCount == 0
                    ? "Khám phá theo cách của bạn"
                    : "Lưu ($selectedCount đã chọn)",
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

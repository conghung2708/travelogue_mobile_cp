import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TourSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const TourSearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Tìm kiếm tour...",
          prefixIcon: Icon(Icons.search, size: 6.w),
          suffixIcon: Icon(Icons.filter_list, size: 6.w),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }
}

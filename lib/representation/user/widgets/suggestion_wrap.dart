import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuggestionWrap extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const SuggestionWrap({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Chuẩn bị trước chuyến đi',
      'Văn hoá địa phương',
      'Tiết kiệm chi phí',
      'Khám phá điểm đến',
      'Chào bạn!',
      'Tôi cần tư vấn',
    ];

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: suggestions
            .map((text) => ActionChip(
                  label: Text(text, style: TextStyle(fontSize: 12.5.sp)),
                  backgroundColor: Colors.blue.shade50,
                  onPressed: () => onSuggestionTap(text),
                ))
            .toList(),
      ),
    );
  }
}

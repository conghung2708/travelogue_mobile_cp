import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/month_model.dart';

class MonthWidget extends StatelessWidget {
  final bool isSelected;
  final Month month;
  final ValueChanged<int> onMonthSelected;

  const MonthWidget({
    super.key,
    required this.month,
    required this.isSelected,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onMonthSelected(month.monthId),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 30.sp,
        height: 30.sp,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0x99FFFFFF),
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.sp)),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              month.icon,
              color: isSelected ? ColorPalette.primaryColor : Colors.white,
              size: 20.sp,
            ),
            SizedBox(height: 5.sp),
            Text(
              month.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? ColorPalette.primaryColor
                    : const Color(0xFFFFFFFF),
                decoration: TextDecoration.none,
              ),
            )
          ],
        ),
      ),
    );
  }
}

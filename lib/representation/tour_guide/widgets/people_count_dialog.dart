
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'circle_icon_button.dart';

class PeopleCountDialog {
  static Future<Map<String, int>?> show(BuildContext context) {
    final adults = ValueNotifier<int>(1);
    final children = ValueNotifier<int>(0);

    return showDialog<Map<String, int>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chọn số lượng người',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(height: 3.h),
              _CounterRow(label: 'Người lớn', notifier: adults, minValue: 1),
              SizedBox(height: 2.h),
              _CounterRow(label: 'Trẻ em', notifier: children, minValue: 0),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Huỷ',
                        style: TextStyle(
                            fontSize: 13.5.sp,
                            color: Colors.blueGrey.shade600)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, {
                      'adults': adults.value,
                      'children': children.value,
                    }),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.2.h),
                        alignment: Alignment.center,
                        child: Text(
                          'Xác nhận',
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final ValueNotifier<int> notifier;
  final int minValue;

  const _CounterRow(
      {required this.label, required this.notifier, required this.minValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
        Row(
          children: [
            CircleIconButton(
              icon: Icons.remove,
              onTap: () {
                if (notifier.value > minValue) notifier.value--;
              },
            ),
            SizedBox(width: 3.w),
            ValueListenableBuilder<int>(
              valueListenable: notifier,
              builder: (_, value, __) => Text('$value',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
            ),
            SizedBox(width: 3.w),
            CircleIconButton(icon: Icons.add, onTap: () => notifier.value++),
          ],
        ),
      ],
    );
  }
}

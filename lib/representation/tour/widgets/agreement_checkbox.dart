// lib/features/tour/presentation/widgets/agreement_checkbox.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const AgreementCheckbox({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: Text(
            'Tôi đã đọc và đồng ý với các điều khoản cam kết dịch vụ ở trên.',
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}

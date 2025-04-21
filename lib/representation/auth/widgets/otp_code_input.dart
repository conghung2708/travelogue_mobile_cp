import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class OtpCodeInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback onSubmit;

  const OtpCodeInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onSubmit,
  });

  Widget _buildOtpField(int index) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: ColorPalette.primaryColor, width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(counterText: "", border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('codeStep'),
      children: [
        Text("Nhập mã xác minh",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 1.h),
        Text("Mã gồm 4 chữ số đã gửi đến email của bạn",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildOtpField(index)),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 3.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            child: Text("Xác nhận", style: TextStyle(fontSize: 15.sp)),
          ),
        ),
      ],
    );
  }
}

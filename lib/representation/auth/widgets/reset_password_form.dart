import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class ResetPasswordForm extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  const ResetPasswordForm({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('resetStep'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tạo mật khẩu mới",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 1.h),
        Text("Nhập mật khẩu mới và xác nhận lại để hoàn tất",
            style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
        SizedBox(height: 3.h),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Mật khẩu mới",
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w)),
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Xác nhận mật khẩu",
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w)),
          ),
        ),
        SizedBox(height: 4.h),
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

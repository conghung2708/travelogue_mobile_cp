import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class EmailStepForm extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  const EmailStepForm({
    super.key,
    required this.emailController,
    required this.formKey,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        key: const ValueKey('emailStep'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lấy lại mật khẩu",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 2.h),
          Text("Vui lòng nhập email để nhận mã xác minh",
              style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
          SizedBox(height: 3.h),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Email không hợp lệ';
              }
              return null;
            },
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
              child: Text("Gửi mã xác minh", style: TextStyle(fontSize: 15.sp)),
            ),
          ),
        ],
      ),
    );
  }
}

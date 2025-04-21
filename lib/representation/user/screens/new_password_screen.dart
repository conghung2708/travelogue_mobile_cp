// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class NewPasswordScreen extends StatefulWidget {
  final String otp;
  const NewPasswordScreen({
    Key? key,
    required this.otp,
  }) : super(key: key);
  static const routeName = '/new_password_screen';

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _saveNewPassword() {
    if (_passwordController.text.isEmpty || _confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin.")),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu xác nhận không khớp!")),
      );
      return;
    }

    AppBloc.authenicateBloc.add(
      ResetPasswordEvent(
        email: UserLocal().getUser().email ?? '',
        otp: widget.otp,
        password: _passwordController.text,
        context: context,
      ),
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Mật khẩu đã được thay đổi!")),
    // );
    // Navigator.popUntil(context, ModalRoute.withName('/edit_profile_screen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        title: Text(
          "Đặt mật khẩu mới",
          style: TextStyle(fontFamily: "Pattaya", fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabel("Mật khẩu mới"),
              _buildPasswordField(controller: _passwordController),
              SizedBox(height: 2.h),
              _buildLabel("Xác nhận mật khẩu"),
              _buildPasswordField(controller: _confirmController),
              SizedBox(height: 5.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveNewPassword,
                  icon: const Icon(Icons.save),
                  label:
                      Text("Lưu mật khẩu", style: TextStyle(fontSize: 13.5.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

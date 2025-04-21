import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/user/screens/otp_vertification_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  String _email = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = UserLocal().getUser().fullName ?? '';
    _email = UserLocal().getUser().email ?? '';
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thông tin đã được cập nhật!")),
    );
    Navigator.pop(context);
  }

  void _confirmChangePassword() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn thay đổi mật khẩu không?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Không")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Có")),
        ],
      ),
    );

    if (result == true) {
      AppBloc.authenicateBloc.add(
        SendOTPEmailEvent(
          context: context,
          email: UserLocal().getUser().email ?? '',
        ),
      );
      Navigator.pushNamed(context, OtpVerificationScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(fontSize: 20.sp, fontFamily: "Pattaya"),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            // Profile Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Tên của bạn"),
                    _buildTextField(_nameController, icon: Icons.person),
                    SizedBox(height: 2.5.h),
                    _buildLabel("Email đăng ký"),
                    _buildTextField(
                      TextEditingController(text: _email),
                      icon: Icons.email,
                      readOnly: true,
                    ),
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Change password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Bạn muốn đổi mật khẩu?"),
                SizedBox(height: 1.h),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _confirmChangePassword,
                    icon:
                        Icon(Icons.lock_reset, size: 18.sp, color: Colors.teal),
                    label: Text(
                      "Thay đổi mật khẩu",
                      style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.6.h),
                      side: const BorderSide(color: Colors.teal, width: 1.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.white,
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: Text("Lưu thay đổi", style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 3,
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, bottom: 0.8.h),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    IconData? icon,
    bool isPassword = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

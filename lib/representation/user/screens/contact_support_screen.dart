import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});
  static const routeName = '/contact_support_screen';

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  // Accent
  static const _blue = Color(0xFF1E88E5);
  static const _blueSoft = Color(0xFFE3F2FD);

  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSent = false;
  bool _isSending = false;

  bool _isValidEmail(String v) {
    final s = v.trim();
    if (s.isEmpty) return false;
    // validate đơn giản
    return s.contains('@') && s.contains('.') && s.length >= 6;
  }

  void _sendMessage() {
    final email = _emailController.text.trim();
    final msg = _messageController.text.trim();

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email hợp lệ.')),
      );
      return;
    }
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung hỗ trợ.')),
      );
      return;
    }

    if (_isSending) return;
    setState(() => _isSending = true);

    AppBloc.authenicateBloc.add(
      SendContactSupportEvent(
        context,
        email: email,
        message: msg,
        onSendSuccess: () {
          if (!mounted) return;
          setState(() {
            _isSent = true;
            _isSending = false;
          });
          Timer(const Duration(seconds: 5), () {
            if (mounted) Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white, // nền trắng
      appBar: AppBar(
        elevation: 0.6,
        title: Text(
          'Liên hệ với chúng tôi',
          style: TextStyle(fontSize: 20.sp, fontFamily: "Pattaya", color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: _isSent
          ? _buildThankYouScreen()
          : SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _blueSoft,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _blueSoft),
                    ),
                    child: Text(
                      "Chúng tôi luôn sẵn sàng hỗ trợ bạn.\nHãy để lại lời nhắn nhé!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  _buildInputField(
                    label: "Email của bạn",
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hint: 'vd: ban@domain.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 2.h),

                  _buildInputField(
                    label: "Nội dung cần hỗ trợ",
                    controller: _messageController,
                    icon: Icons.edit_note,
                    hint: 'Mô tả vấn đề bạn gặp phải...',
                    maxLines: 12,
                  ),
                  SizedBox(height: 4.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _isSending ? "Đang gửi..." : "Gửi hỗ trợ ngay",
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final isMulti = maxLines > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
          child: Text(
            label,
            style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ),
        TextField(
          controller: controller,
          minLines: isMulti ? 8 : 1,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: _blue, size: 18.sp) : null,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black45, fontSize: 12.5.sp),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _blueSoft),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _blue),
            ),
          ),
          style: TextStyle(fontSize: 13.5.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildThankYouScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetHelper.img_thank_you, height: 60.w, width: 60.w),
            SizedBox(height: 2.h),
            Text(
              'Cảm ơn bạn đã liên hệ 💌',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: _blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Chúng tôi sẽ phản hồi bạn sớm nhất có thể.\nChúc bạn một hành trình tuyệt vời cùng Travelogue!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.5.sp, color: Colors.black54, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

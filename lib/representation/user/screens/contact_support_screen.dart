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
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSent = false;

  void _sendMessage() {
    if (_emailController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng nhập email và nội dung hỗ trợ.')),
      );
      return;
    }

    AppBloc.authenicateBloc.add(
      SendContactSupportEvent(
        context,
        email: _emailController.text,
        message: _messageController.text,
        onSendSuccess: () {
          setState(() {
            _isSent = true;
          });

          Timer(const Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Liên hệ với chúng tôi',
          style: TextStyle(fontSize: 20.sp, fontFamily: "Pattaya"),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                  Text(
                    "Chúng tôi luôn sẵn sàng hỗ trợ bạn 💙\nHãy để lại lời nhắn nhé!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildInputField(
                    label: "Email của bạn",
                    controller: _emailController,
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 2.h),
                  _buildInputField(
                    label: "Nội dung cần hỗ trợ",
                    controller: _messageController,
                    icon: Icons.edit_note,
                    maxLines: 12,
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      label: Text(
                        "Gửi hỗ trợ ngay",
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withOpacity(0.3),
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
    IconData? icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        TextField(
          controller: controller,
          minLines: maxLines > 1 ? 8 : 1,
          maxLines: maxLines,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.blueAccent, size: 18.sp)
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
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
            Image.asset(
              AssetHelper.img_thank_you,
              height: 60.w,
              width: 60.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Cảm ơn bạn đã liên hệ 💌',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Chúng tôi sẽ phản hồi bạn sớm nhất có thể.\nChúc bạn một hành trình tuyệt vời cùng Go Young!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

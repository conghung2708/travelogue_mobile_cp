import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(fontSize: 13.sp),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              style: TextStyle(fontSize: 13.5.sp),
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.blueAccent),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

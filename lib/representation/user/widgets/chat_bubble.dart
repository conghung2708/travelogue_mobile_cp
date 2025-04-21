import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final from = message['from'];

    if (from == 'user') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(3.w),
          constraints: BoxConstraints(maxWidth: 70.w),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message['text'],
            style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
          ),
        ),
      );
    }

    if (from == 'typing') {
      return _botBubble(Text(
        'Go Young đang nhập...',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black54,
          fontSize: 13.sp,
        ),
      ));
    }

    if (from == 'image') {
      return Padding(
        padding: EdgeInsets.only(left: 12.w, right: 2.w, bottom: 2.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: Image.asset(
            message['asset'],
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Bot text
    return _botBubble(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: message['style'] == 'quote'
              ? Colors.blue.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            fontSize: 14.5.sp,
            fontStyle: message['style'] == 'quote'
                ? FontStyle.italic
                : FontStyle.normal,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _botBubble(Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              AssetHelper.img_logo_travelogue,
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(child: child),
        ],
      ),
    );
  }
}

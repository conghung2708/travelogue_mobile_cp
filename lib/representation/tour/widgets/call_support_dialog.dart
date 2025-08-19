// lib/features/tour/presentation/widgets/call_support_dialog.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CallSupportDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                child: Icon(Icons.headset_mic, color: Colors.blueAccent, size: 28.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                "Gọi hỗ trợ từ Travelogue?",
                style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.2.h),
              Text(
                "Bạn có muốn gọi ngay cho chúng tôi qua số 0336 626 193 để được tư vấn & hỗ trợ nhanh chóng?",
                style: TextStyle(fontSize: 13.sp, height: 1.5, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        child: Text("Huỷ", style: TextStyle(fontSize: 13.5.sp)),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context, true);
                        final Uri callUri = Uri(scheme: 'tel', path: '0336626193');
                        if (await canLaunchUrl(callUri)) {
                          await launchUrl(callUri);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                      child: Text("Gọi ngay", style: TextStyle(fontSize: 13.5.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

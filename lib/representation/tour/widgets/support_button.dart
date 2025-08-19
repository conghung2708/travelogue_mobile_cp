import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelogue_mobile/representation/tour/widgets/call_support_dialog.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key, this.phoneNumber = '0336626193'});

  final String phoneNumber;

  Future<void> _launchCall(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      final can = await canLaunchUrl(uri);
      if (!can) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở ứng dụng gọi điện.')),
        );
        return;
      }
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thực hiện cuộc gọi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await CallSupportDialog.show(context);
          if (confirmed == true) {
            await _launchCall(context);
          }
        },
        icon: const Icon(Icons.headset_mic, color: Colors.blue),
        label: Text(
          'Liên hệ hỗ trợ',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blue),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }
}

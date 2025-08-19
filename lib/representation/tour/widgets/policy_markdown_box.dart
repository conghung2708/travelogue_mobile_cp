// lib/features/tour/presentation/widgets/policy_markdown_box.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';

class PolicyMarkdownBox extends StatelessWidget {
  const PolicyMarkdownBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const MarkdownBody(
        data: '''
🚩 **Cam kết dịch vụ của Travelogue**

✅ **Không hoàn hủy vé** sau khi thanh toán *(trừ khi có lý do đặc biệt được xác nhận)*.

✅ Mang theo **CMND/CCCD hoặc hộ chiếu** để xác minh danh tính.

✅ **Tuân thủ tuyệt đối** hướng dẫn trưởng đoàn và nhân viên hỗ trợ.

✅ Mặc trang phục **lịch sự, kín đáo** phù hợp văn hoá điểm đến.

✅ **Không xả rác**, giữ vệ sinh và không gây ồn ào nơi công cộng.

✅ Nếu không khoẻ, **báo ngay hướng dẫn viên** để được hỗ trợ kịp thời.

✨ *Chúng tôi vinh dự được đồng hành cùng bạn trong hành trình đầy ý nghĩa này. Cảm ơn bạn đã tin tưởng Travelogue!* ✨
''',
      ),
    );
  }
}

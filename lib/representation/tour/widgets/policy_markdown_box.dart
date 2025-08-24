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
### 🚩 **Cam kết & Chính sách dịch vụ Travelogue**

**1) Huỷ/Hoàn tiền**  
✅ Bạn được quyền **huỷ đơn trong vòng 24 giờ** kể từ lúc đặt.  
✅ Sau 24 giờ, đơn sẽ được xác nhận và **không thể huỷ/hoàn**.

**2) Xác minh & tuân thủ**  
✅ Mang theo **CMND/CCCD hoặc hộ chiếu** để xác minh danh tính.  
✅ **Tuân thủ** hướng dẫn của trưởng đoàn/nhân viên hỗ trợ trong suốt hành trình.

**3) Ứng xử & an toàn**  
✅ Mặc trang phục **lịch sự, phù hợp** văn hoá điểm đến.  
✅ **Không xả rác**, giữ vệ sinh và hạn chế gây ồn nơi công cộng.  
✅ Nếu có dấu hiệu **không khoẻ**, hãy **báo ngay** cho hướng dẫn viên để được hỗ trợ.

> ✨ *Cảm ơn bạn đã đồng hành cùng Travelogue! Chúc bạn có trải nghiệm thật trọn vẹn.* ✨
''',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class GuidePolicyCard extends StatelessWidget {
  final ValueNotifier<bool> hasAcceptedTerms;
  const GuidePolicyCard({super.key, required this.hasAcceptedTerms});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWithCustoneUnderline(
              text: 'Điều khoản ', text2: '& Trách nhiệm'),
          SizedBox(height: 1.2.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 Vui lòng đọc kỹ trước khi xác nhận:',
                    style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade700)),
                SizedBox(height: 1.h),
                ...[
                  '📞 Hướng dẫn viên sẽ liên hệ trước ngày đi để xác nhận.',
                  '🪪 Vui lòng mang theo giấy tờ tùy thân hợp lệ khi tham gia tour.',
                  '⏰ Quý khách cần có mặt đúng giờ theo lịch trình.',
                  '🔁 Mọi thay đổi cần thông báo ít nhất 24h trước giờ khởi hành.',
                  '📄 Sau khi xác nhận đặt, mọi yêu cầu hoàn/hủy sẽ được xử lý theo chính sách của Travelogue.',
                ].map((t) => Padding(
                      padding: EdgeInsets.only(bottom: 0.8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Expanded(
                            child: Text(t,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.blueGrey.shade800,
                                    height: 1.5)),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 1.5.h),
                Center(
                  child: Text('💙 Cảm ơn bạn đã tin tưởng Travelogue!',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue.shade700)),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: hasAcceptedTerms,
                builder: (_, value, __) => Checkbox(
                  value: value,
                  activeColor: ColorPalette.primaryColor,
                  onChanged: (val) => hasAcceptedTerms.value = val ?? false,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => hasAcceptedTerms.value = !hasAcceptedTerms.value,
                  child: Text(
                      'Tôi đã đọc và đồng ý với các điều khoản & trách nhiệm.',
                      style: TextStyle(
                          fontSize: 12.5.sp, color: Colors.blueGrey.shade900)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

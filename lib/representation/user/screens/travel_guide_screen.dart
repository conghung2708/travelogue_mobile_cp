import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TravelGuideScreen extends StatefulWidget {
  const TravelGuideScreen({super.key});
  static const routeName = '/travel_guide_screen';

  @override
  State<TravelGuideScreen> createState() => _TravelGuideScreenState();
}

class _TravelGuideScreenState extends State<TravelGuideScreen> {
  final List<Map<String, dynamic>> _chatHistory = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestions = [
    'Chuẩn bị trước chuyến đi',
    'Văn hoá địa phương',
    'Tiết kiệm chi phí',
    'Khám phá điểm đến',
    'Chào bạn!',
    'Tôi cần tư vấn',
  ];

  @override
  void initState() {
    super.initState();
    _addInitialBotMessages();
  }

  void _addInitialBotMessages() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _chatHistory.addAll([
          {
            'from': 'bot',
            'text': '"Cuộc sống là một cuộc hành trình, không phải đích đến."',
            'style': 'quote',
          },
          {
            'from': 'image',
            'asset': AssetHelper.img_nui_ba_den_1,
          },
          {
            'from': 'bot',
            'text':
                '💡 Luôn kiểm tra thời tiết và thông tin điểm đến trước chuyến đi để chuẩn bị trang phục và lịch trình phù hợp.',
          },
        ]);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  final Map<String, String> _keywordResponses = {
    'tiết kiệm':
        '💰 Đi vào mùa thấp điểm, săn voucher hoặc ở homestay sẽ giúp bạn tiết kiệm đáng kể!',
    'văn hoá':
        '🎎 Học vài câu chào hỏi địa phương sẽ giúp bạn dễ gần và ghi điểm với người bản xứ!',
    'chuẩn bị':
        '🎒 Đừng quên kem chống nắng, thuốc cá nhân, bản đồ offline và sạc dự phòng nha!',
    'khám phá':
        '🧭 Hỏi người dân bản địa là cách tốt nhất để tìm điểm đến mới lạ đó bạn!',
    'chào':
        '👋 Xin chào bạn! Go Young rất vui được đồng hành cùng bạn trong hành trình khám phá ✨',
    'tư vấn':
        '📞 Bạn có thể vào phần "Đóng góp ý kiến" để gửi yêu cầu hỗ trợ, hoặc chat với Go Young để được tư vấn nhanh nhé!',
    'check in':
        '📸 Các điểm check-in đẹp tại Tây Ninh: đỉnh núi Bà, cầu kính, cổng trời, hồ Dầu Tiếng, cổng Tòa Thánh và khu du lịch Ma Thiên Lãnh.',
    'ngủ':
        '🏨 Tại trung tâm Tây Ninh có nhiều khách sạn 2-3 sao sạch sẽ, tiện nghi. Gần núi Bà cũng có homestay view núi cực chill.',
    'khách sạn':
        '🏨 Tại trung tâm Tây Ninh có nhiều khách sạn 2-3 sao sạch sẽ, tiện nghi. Gần núi Bà cũng có homestay view núi cực chill.',
    'đi lại':
        '🚗 Từ TP.HCM đi Tây Ninh mất khoảng 2 tiếng rưỡi bằng xe khách hoặc ô tô. Trong tỉnh có thể thuê xe máy hoặc taxi công nghệ.',
    'di chuyển':
        '🚗 Từ TP.HCM đi Tây Ninh mất khoảng 2 tiếng rưỡi bằng xe khách hoặc ô tô. Trong tỉnh có thể thuê xe máy hoặc taxi công nghệ.',
    'mở cửa':
        '🕘 Phần lớn di tích mở cửa từ 7h sáng đến 5h chiều mỗi ngày. Cáp treo núi Bà hoạt động từ 5h30 đến 18h.',
    'wifi':
        '📶 Một số khu vực như núi và rừng có sóng yếu. Bạn nên tải trước bản đồ và nội dung thuyết minh để dùng offline.',
    'mạng':
        '📶 Một số khu vực như núi và rừng có sóng yếu. Bạn nên tải trước bản đồ và nội dung thuyết minh để dùng offline.',
    'wifi miễn phí':
        '📡 Một số điểm như Tòa Thánh, cáp treo núi Bà có wifi miễn phí. Tuy nhiên, bạn nên chuẩn bị sẵn mạng 4G để phòng trường hợp mất sóng.',
    'hướng dẫn viên':
        '🎙️ Go Young có thuyết minh tự động cho từng di tích. Bạn chỉ cần bật audio hoặc xem bản tóm tắt trong phần thông tin.',
    'lễ hội':
        '🎉 Lễ hội lớn nhất Tây Ninh là Hội Yến Diêu Trì Cung tổ chức vào rằm tháng 8 âm lịch tại Tòa Thánh, thu hút hàng chục nghìn người tham dự.',
    'an toàn':
        '🛡️ Tây Ninh là địa phương an toàn, thân thiện. Tuy nhiên, bạn vẫn nên giữ đồ cá nhân cẩn thận khi tham quan nơi đông người.',
    'mua gì':
        '🛍️ Đặc sản nên mua ở Tây Ninh: muối tôm, bánh tráng, nem bưởi, thốt nốt sấy dẻo và trái cây sấy.',
    'đi mấy ngày':
        '🗓️ Bạn có thể đi Tây Ninh trong 1 hoặc 2 ngày là hợp lý. Nếu có thời gian, kết hợp tham quan và nghỉ dưỡng cuối tuần thì tuyệt vời.',
    'giao thông':
        '🚦 Trong nội tỉnh có xe buýt, taxi truyền thống, xe ôm công nghệ, và các tour xe điện tại các khu du lịch lớn.',
    'góp ý':
        '💬 Cảm ơn bạn đã quan tâm! Bạn có thể vào mục "Góp ý" trong app để chia sẻ nhận xét và giúp Go Young ngày càng hoàn thiện hơn.',
    'ý kiến':
        '💬 Cảm ơn bạn đã quan tâm! Bạn có thể vào mục "Góp ý" trong app để chia sẻ nhận xét và giúp Go Young ngày càng hoàn thiện hơn.',
    'app lỗi':
        '⚠️ Nếu app bị lỗi, bạn hãy thử cập nhật phiên bản mới nhất hoặc gỡ cài đặt và cài lại. Nếu vẫn lỗi, hãy gửi phản hồi cho đội kỹ thuật nhé.',
    'không mở được':
        '⚠️ Nếu app bị lỗi, bạn hãy thử cập nhật phiên bản mới nhất hoặc gỡ cài đặt và cài lại. Nếu vẫn lỗi, hãy gửi phản hồi cho đội kỹ thuật nhé.',
    'nạp tiền':
        '💳 App Go Young hiện miễn phí tất cả tính năng. Nếu có dịch vụ tính phí trong tương lai, sẽ có thông báo rõ ràng trước khi bạn sử dụng.',
    'thanh toán':
        '💳 App Go Young hiện miễn phí tất cả tính năng. Nếu có dịch vụ tính phí trong tương lai, sẽ có thông báo rõ ràng trước khi bạn sử dụng.',
    'quên mật khẩu':
        '🔐 Bạn có thể nhấn vào "Quên mật khẩu" tại màn hình đăng nhập để đặt lại bằng email hoặc số điện thoại đã đăng ký.',
    'không đăng nhập được':
        '🚫 Vui lòng kiểm tra lại kết nối mạng và tài khoản. Nếu vẫn không đăng nhập được, hãy gỡ cài đặt và cài lại app Go Young.',
    'gửi phản hồi':
        '✉️ Bạn vào mục "Góp ý" trong menu chính của app để gửi phản hồi. Đội ngũ Go Young sẽ đọc và cải thiện liên tục.',
    'sai vị trí':
        '📍 Nếu app hiển thị sai vị trí, bạn hãy kiểm tra lại GPS hoặc thử bật tắt lại định vị. Một số vùng núi có thể mất tín hiệu GPS.',
    'bảo mật':
        '🔒 App Go Young không thu thập dữ liệu cá nhân không cần thiết và luôn tuân thủ chính sách bảo mật theo quy định.',
    'bị lạc':
        '🧭 Nếu bạn bị lạc đường, hãy dùng bản đồ trong app hoặc nhờ người dân địa phương chỉ đường – người Tây Ninh rất thân thiện và sẵn sàng giúp đỡ.',
    'hành lý':
        '🎒 Khi đi Tây Ninh, bạn nên mang theo nón, kính râm, áo khoác nhẹ, nước, pin dự phòng và giày thể thao để dễ di chuyển.',
    'y tế':
        '🏥 Gần các điểm du lịch lớn đều có trạm y tế hoặc bệnh viện huyện. Bạn nên mang theo một ít thuốc cơ bản như đau đầu, đau bụng, chống say xe.',
    'lịch sử app':
        '📲 App Go Young được phát triển với mục tiêu kết nối giới trẻ với di tích lịch sử Tây Ninh, giúp việc khám phá trở nên sinh động, tiện lợi và hấp dẫn hơn.',
    'thông tin liên hệ':
        '📞 Liên hệ Go Young qua email traveloguetayninh@gmail.com. Luôn sẵn sàng hỗ trợ bạn!',
    'hỗ trợ khẩn cấp':
        '🚨 Nếu gặp sự cố khẩn cấp, hãy gọi 113 (công an), 114 (cứu hỏa), 115 (cấp cứu). Đồng thời báo với nhân viên gần nhất hoặc quản lý khu du lịch.',
    'tài khoản':
        '👤 Bạn có thể cập nhật thông tin tài khoản, đổi mật khẩu hoặc đăng xuất tại mục "Cài đặt cá nhân" trong app.',
    'cám ơn':
        '🎉Cảm ơn bạn đã đồng hành cùng Go Young – chúc bạn luôn có những hành trình trọn vẹn và đáng nhớ!',
    'cảm ơn':
        '🎉Cảm ơn bạn đã đồng hành cùng Go Young – chúc bạn luôn có những hành trình trọn vẹn và đáng nhớ!',
  };

  void _handleSendMessage(String inputText) {
    final input = inputText.trim();
    if (input.isEmpty) {
      return;
    }

    setState(() {
      _chatHistory.add({'from': 'user', 'text': input});
      _chatHistory.add({'from': 'typing'});
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _chatHistory.removeWhere((msg) => msg['from'] == 'typing');

        String lower = input.toLowerCase();
        String reply =
            'Xin lỗi, tạm thời mình chưa thể trả lời câu hỏi này. Vui lòng liên hệ admin 😅';

        for (final entry in _keywordResponses.entries) {
          if (lower.contains(entry.key)) {
            reply = entry.value;
            break;
          }
        }

        _chatHistory.add({'from': 'bot', 'text': reply});
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildTextBubble(String text, {bool isQuote = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isQuote ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.5.sp,
          fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildImageBubble(String asset) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 2.w, bottom: 2.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.w),
        child: Image.asset(
          asset,
          width: double.infinity,
          height: 25.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _botAvatar() {
    return ClipOval(
      child: Image.asset(
        AssetHelper.img_logo_travelogue,
        width: 10.w,
        height: 10.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _chatBubble({required Widget child, bool isBot = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            _botAvatar(),
            SizedBox(width: 3.w),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Text(
          'Cẩm nang du lịch',
          style: TextStyle(fontSize: 20.sp, fontFamily: "Pattaya"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat list
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _chatHistory.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10.h),
                  itemBuilder: (context, index) {
                    final msg = _chatHistory[index];

                    if (msg['from'] == 'user') {
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
                            msg['text'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5.sp,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    } else if (msg['from'] == 'typing') {
                      return _chatBubble(
                        isBot: true,
                        child: Text(
                          'Go Young đang nhập...',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            fontSize: 13.sp,
                          ),
                        ),
                      );
                    } else if (msg['from'] == 'image') {
                      return _buildImageBubble(msg['asset']);
                    } else {
                      return _chatBubble(
                        isBot: true,
                        child: _buildTextBubble(
                          msg['text'],
                          isQuote: msg['style'] == 'quote',
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            // Gợi ý nhanh
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: _suggestions.map((text) {
                  return ActionChip(
                    label: Text(
                      text,
                      style: TextStyle(fontSize: 12.5.sp),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    onPressed: () => _handleSendMessage(text),
                  );
                }).toList(),
              ),
            ),

            // Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _handleSendMessage,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: TextStyle(fontSize: 13.sp),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: TextStyle(fontSize: 13.5.sp),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: Colors.blueAccent),
                    onPressed: () =>
                        _handleSendMessage(_controller.text.trim()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

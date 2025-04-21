import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/representation/user/widgets/chat_option_button.dart';


class GoYoungChat extends StatefulWidget {
  const GoYoungChat({super.key});

  @override
  State<GoYoungChat> createState() => _GoYoungChatState();
}

class _GoYoungChatState extends State<GoYoungChat> {
  final List<Map<String, dynamic>> chatHistory = [];

  final options = {
    'faq': {
      'text': 'Tôi muốn xem Câu hỏi thường gặp',
      'reply':
          'Tuyệt vời! Đây là nơi bạn có thể tìm các câu hỏi phổ biến nhất 🧐',
      'route': '/faq_screen',
      'button': 'Xem FAQ',
    },
    'contact': {
      'text': 'Tôi cần gửi yêu cầu hỗ trợ chi tiết',
      'reply':
          'Bạn có thể gửi thắc mắc cụ thể để Go Young hỗ trợ kịp thời 💌',
      'route': '/contact_support_screen',
      'button': 'Gửi yêu cầu',
    },
    'guide': {
      'text': 'Tư vấn kinh nghiệm du lịch',
      'reply': 'Go Young có những mẹo khám phá cực hay cho bạn đấy! 🧭',
      'route': '/travel_guide_screen',
      'button': 'Xem cẩm nang',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 3.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    IconButton(
      icon: const Icon(Icons.close_rounded, color: Colors.grey),
      onPressed: () => Navigator.pop(context),
      tooltip: 'Đóng chat',
    ),
  ],
),
SizedBox(height: 1.h),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final msg = chatHistory[index];
                if (msg['from'] == 'user') {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.5.h),
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
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                if (msg['from'] == 'typing') {
                  return Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/logo_travelogue.png',
                          width: 9.w,
                          height: 9.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Go Young đang nhập...',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo_travelogue.png',
                        width: 9.w,
                        height: 9.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 1.5.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['text'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                            if (msg['button'] != null && msg['route'] != null)
                              Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 1.2.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, msg['route']);
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                  label: Text(msg['button']),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 2.w,
            children: options.entries.map((entry) {
              final opt = entry.value;
              return ChatOptionButton(
                label: opt['text'] ?? 'Không rõ',
                onPressed: () {
                  setState(() {
                    chatHistory.add({'from': 'user', 'text': opt['text']});
                    chatHistory.add({'from': 'typing'});
                  });
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    setState(() {
                      chatHistory
                          .removeWhere((msg) => msg['from'] == 'typing');
                      chatHistory.add({
                        'from': 'bot',
                        'text': opt['reply'],
                        'route': opt['route'],
                        'button': opt['button'],
                      });
                    });
                  });
                },
              );
            }).toList(),
          ),
          
        ],
      ),
    );
  }
}

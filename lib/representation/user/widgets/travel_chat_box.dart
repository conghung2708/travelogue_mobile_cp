import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/user/widgets/chat_bubble.dart';
import 'package:travelogue_mobile/representation/user/widgets/chat_input.dart';
import 'package:travelogue_mobile/representation/user/widgets/suggestion_wrap.dart';

class TravelChatBox extends StatefulWidget {
  const TravelChatBox({super.key});

  @override
  State<TravelChatBox> createState() => _TravelChatBoxState();
}

class _TravelChatBoxState extends State<TravelChatBox> {
  final List<Map<String, dynamic>> _chatHistory = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

        String reply =
            'Xin lỗi, tạm thời mình chưa thể trả lời câu hỏi này. Vui lòng liên hệ admin 😅';
        final lower = input.toLowerCase();

        if (lower.contains('tiết kiệm')) {
          reply =
              '💰 Đi vào mùa thấp điểm, săn voucher hoặc ở homestay sẽ giúp bạn tiết kiệm đáng kể!';
        } else if (lower.contains('văn hóa') || lower.contains('văn hoá')) {
          reply =
              '🎎 Học vài câu chào hỏi địa phương sẽ giúp bạn dễ gần và ghi điểm với người bản xứ!';
        } else if (lower.contains('chuẩn bị')) {
          reply =
              '🎒 Đừng quên kem chống nắng, thuốc cá nhân, bản đồ offline và sạc dự phòng nha!';
        } else if (lower.contains('khám phá')) {
          reply =
              '🧭 Hỏi người dân bản địa là cách tốt nhất để tìm điểm đến mới lạ đó bạn!';
        } else if (lower.contains('chào')) {
          reply =
              '👋 Xin chào bạn! Go Young rất vui được đồng hành cùng bạn trong hành trình khám phá ✨';
        } else if (lower.contains('tư vấn')) {
          reply =
              '📞 Bạn có thể vào phần "Đóng góp ý kiến" để gửi yêu cầu hỗ trợ, hoặc chat với Go Young để được tư vấn nhanh nhé!';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatHistory.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 18.h,
              ),
              itemBuilder: (context, index) =>
                  ChatBubble(message: _chatHistory[index]),
            ),
          ),
        ),
        SuggestionWrap(onSuggestionTap: _handleSendMessage),
        ChatInput(
          controller: _controller,
          onSend: () => _handleSendMessage(_controller.text),
        ),
      ],
    );
  }
}

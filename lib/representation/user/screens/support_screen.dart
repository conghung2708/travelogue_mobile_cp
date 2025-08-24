import 'package:flutter/material.dart';
import 'package:travelogue_mobile/representation/user/widgets/go_young_chat.dart';
import 'package:travelogue_mobile/representation/user/widgets/help_card.dart';


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const routeName = '/support_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trợ giúp & Hỗ trợ',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          HelpCard(
            icon: Icons.question_answer,
            title: 'Câu hỏi thường gặp (FAQ)',
            subtitle: 'Xem các câu hỏi phổ biến và cách giải quyết',
            onTap: () {
              Navigator.of(context).pushNamed('/faq_screen');
            },
          ),
          const SizedBox(height: 16),
          HelpCard(
            icon: Icons.mail_outline,
            title: 'Đóng góp ý kiến',
            subtitle: 'Gửi email đến đội ngũ hỗ trợ Travelogue',
            onTap: () {
              Navigator.of(context).pushNamed('/contact_support_screen');
            },
          ),
          const SizedBox(height: 16),
          HelpCard(
            icon: Icons.explore_outlined,
            title: 'Cẩm nang du lịch',
            subtitle: 'Travelogue gửi đến bạn các mẹo & trải nghiệm tuyệt vời',
            onTap: () {
              Navigator.of(context).pushNamed('/travel_guide_screen');
            },
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) => const GoYoungChat(),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text("Chat với Travelogue"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

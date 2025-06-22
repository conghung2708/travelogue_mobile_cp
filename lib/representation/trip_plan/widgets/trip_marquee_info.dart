import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class TripMarqueeInfo extends StatelessWidget {
  const TripMarqueeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      color: const Color(0xFFD6F2FF),
      child: Marquee(
        blankSpace: 60,
        velocity: 30,
        pauseAfterRound: const Duration(seconds: 1),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        text:
            '🧭 Lịch trình rõ ràng\u2003\u2003🏞️ Trải nghiệm làng nghề Tây Ninh\u2003\u2003🍜 Ẩm thực độc đáo\u2003\u2003🎒 Phù hợp nhóm bạn và gia đình\u2003\u2003📸 Check-in địa đạo An Thới – Lợi Thuận\u2003\u2003🔥 Ưu đãi tour nội địa mỗi tháng',
      ),
    );
  }
}

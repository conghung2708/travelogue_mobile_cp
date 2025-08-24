// lib/features/tour/presentation/widgets/marquee_note_bar.dart
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

class MarqueeNoteBar extends StatelessWidget {
  final String text;
  const MarqueeNoteBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Marquee(
          text: text,
          style: TextStyle(fontSize: 13.sp, color: Colors.blueAccent, fontWeight: FontWeight.w500),
          velocity: 30,
        ),
      ),
    );
  }
}

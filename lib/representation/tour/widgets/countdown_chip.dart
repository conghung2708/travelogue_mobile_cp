// lib/features/tour/presentation/widgets/countdown_chip.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CountdownChip extends StatelessWidget {
  final Duration remaining;
  const CountdownChip({super.key, required this.remaining});

  String _fmt(Duration d) {
    final total = d.inSeconds.clamp(0, 5 * 60);
    final mm = (total ~/ 60).toString().padLeft(2, '0');
    final ss = (total % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 20),
          SizedBox(width: 2.w),
          Text(
            _fmt(remaining),
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

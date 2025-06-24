import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TripInfoIconRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const TripInfoIconRow({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 5.w),
            SizedBox(width: 1.w),
            Text(value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
          ],
        ),
        Text(label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
      ],
    );
  }
}

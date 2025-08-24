import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TourCalendarBackground extends StatelessWidget {
  final String image;
  final double overlayOpacity;
  const TourCalendarBackground({
    super.key,
    required this.image,
    this.overlayOpacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(image,
              fit: BoxFit.cover, height: 100.h, width: double.infinity),
          Container(color: Colors.black.withOpacity(overlayOpacity)),
        ],
      ),
    );
  }
}

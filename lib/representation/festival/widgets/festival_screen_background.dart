import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class FestivalScreenBackground extends StatelessWidget {
  final double screenHeight;
  const FestivalScreenBackground({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    // final themeDate = Theme.of(context);
    return ClipPath(
      clipper: BottomShapeClipper(),
      child: Container(
        height: screenHeight * 0.55,
        color: ColorPalette.primaryColor,
      ),
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.85);
    Offset curveEndPoint = Offset(size.width, size.height * 0.85);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
        size.width / 2, size.height, curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

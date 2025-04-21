import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primaryColor = Color(0xFF27A4F2);
  static const Color secondColor = Color(0xFF6EC2F7);
  static const Color yellowColor = Color(0xFFFFD27B);

  static const Color dividerColor = Color(0xFFB0DFFC);
  static const Color text1Color = Colors.black;
  static const Color subTitleColor = Color(0xFF529FD9);
  static const Color backgroundScaffoldColor = Color(0xFFF2F2F2);
}

class Gradients {
  static const Gradient defaultGradientBackground = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
      colors: [
        ColorPalette.secondColor,
        ColorPalette.primaryColor,
      ]);
}

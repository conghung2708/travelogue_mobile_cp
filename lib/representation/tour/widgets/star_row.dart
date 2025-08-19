import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  final num rating;
  const StarRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final stars = <Widget>[];
    for (int i = 1; i <= 5; i++) {
      final fill = rating + 0.001 - i;
      final icon = fill >= 0
          ? Icons.star_rounded
          : (fill > -1 ? Icons.star_half_rounded : Icons.star_border_rounded);
      stars.add(Icon(icon, size: 16, color: const Color(0xFFFFB200)));
    }
    return Row(children: stars);
  }
}

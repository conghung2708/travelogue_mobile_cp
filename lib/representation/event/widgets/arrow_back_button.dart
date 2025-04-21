import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ArrowBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.8),
            Colors.blue.withOpacity(0.6),
          ],
          radius: 0.5,
          stops: const [0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 25,
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}

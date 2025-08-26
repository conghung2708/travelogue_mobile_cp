// ui/widgets/review_pill_button.dart
import 'package:flutter/material.dart';

class ReviewPillButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final bool enabled;

  const ReviewPillButton({
    super.key,
    required this.onPressed,
    this.label = 'Đánh giá',
    this.icon = Icons.star_rounded,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && onPressed != null;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.cardColor, 
        shape: _DashedBorderShape(
          borderRadius: BorderRadius.circular(12), 
          dashWidth: 6,
          dashGap: 3,
          borderColor: Colors.grey.shade400,
          strokeWidth: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: canTap ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _DashedBorderShape extends ShapeBorder {
  final BorderRadius borderRadius;
  final double dashWidth;
  final double dashGap;
  final Color borderColor;
  final double strokeWidth;

  const _DashedBorderShape({
    required this.borderRadius,
    required this.dashWidth,
    required this.dashGap,
    required this.borderColor,
    required this.strokeWidth,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.toRRect(rect);
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final dashPath = Path();
    double distance = 0.0;
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashPath.addPath(
          metric.extractPath(distance, next),
          Offset.zero,
        );
        distance = next + dashGap;
      }
      distance = 0.0; 
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder? a, double t) => this;

  @override
  ShapeBorder lerpTo(ShapeBorder? b, double t) => this;
}

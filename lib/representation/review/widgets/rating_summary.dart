// 📁 lib/representation/review/widgets/rating_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class RatingSummary extends StatelessWidget {
  final num averageRating;
  final int totalReviews;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: averageRating.toDouble(),
          itemCount: 5,
          itemSize: 22.sp,
          itemBuilder: (context, _) => const Icon(
            Icons.star_rounded,
            color: Colors.amber,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          averageRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 2.w),
        Text("($totalReviews đánh giá)"),
      ],
    );
  }
}

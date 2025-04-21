import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';

class SingleEventsItemHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String imageAssetPath;
  final DateTime date;
  @override
  final double maxExtent;
  @override
  final double minExtent;

  const SingleEventsItemHeaderDelegate({
    required this.maxExtent,
    required this.minExtent,
    required this.title,
    required this.imageAssetPath,
    required this.date,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final formattedDate = DateFormat.yMMMd().format(date);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image with gradient overlay
        Positioned.fill(
          child: ImageNetworkCard(
            url: imageAssetPath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          left: 4.w,
          child: ArrowBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          bottom: 3.h,
          left: 5.w,
          right: 5.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    const Shadow(
                      color: Colors.black38,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

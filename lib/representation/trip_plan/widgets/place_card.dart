import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final IconData icon;
  final int overlayOrder;
  final bool blocked;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? distanceText;

  final String? metaText;

  const PlaceCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.icon,
    this.overlayOrder = 0,
    this.blocked = false,
    this.onTap,
    this.onLongPress,
    this.distanceText,
    this.metaText,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(4.w),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            width: 45.w,
            height: 45.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 45.w,
              height: 45.w,
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported, size: 16.sp),
            ),
          ),
          if (overlayOrder > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      '$overlayOrder',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (distanceText != null && distanceText!.isNotEmpty)
            Positioned(
              right: 2.w,
              top: 2.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  distanceText!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 2.w,
            right: 2.w,
            bottom: 2.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 12.sp, color: Colors.white),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (metaText != null && metaText!.isNotEmpty) ...[
                  SizedBox(height: 0.7.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.40),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: Colors.white),
                        SizedBox(width: 1.w),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 36.w),
                          child: Text(
                            metaText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (blocked) {
      return Opacity(
          opacity: 0.3, child: IgnorePointer(ignoring: true, child: content));
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: content,
    );
  }
}

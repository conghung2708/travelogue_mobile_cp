import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';
import 'package:travelogue_mobile/representation/review/widgets/gradient_icon.dart';

class ReviewItem<T extends ReviewBase> extends StatelessWidget {
  final T review;
  final int index;
  final String? vote;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final void Function(BuildContext) onReport; 

  const ReviewItem({
    super.key,
    required this.review,
    required this.index,
    required this.vote,
    required this.onLike,
    required this.onDislike,
    required this.onReport,
  });

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      shadowColor: Colors.black12,
      margin: EdgeInsets.only(bottom: 2.h),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: AssetImage(review.userAvatarUrl),
                radius: 20.sp,
              ),
              title: Text(
                review.userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
              subtitle: Text(
                _getTimeAgo(review.createdAt),
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
              trailing: Icon(Icons.location_on, color: Colors.redAccent, size: 20.sp),
            ),
            SizedBox(height: 1.h),
            RatingBarIndicator(
              rating: review.rating.toDouble(),
              itemCount: 5,
              itemSize: 18.sp,
              itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
            ),
            SizedBox(height: 1.h),
            Text(
              review.comment,
              style: TextStyle(fontSize: 15.sp, color: Colors.black87, height: 1.6),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.thumb_up_alt_outlined,
                        size: 18.sp,
                        gradient: LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF0077B6)]),
                      ),
                      SizedBox(width: 1.w),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                        ).createShader(Rect.fromLTWH(0, 0, 100, 20)),
                        child: Text(
                          "Hữu ích (${review.likes})",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: onDislike,
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_down_alt_outlined,
                        size: 18.sp,
                        color: vote == 'dislike' ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Không hữu ích (${review.dislikes})",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: vote == 'dislike' ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => onReport(context), 
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 18.sp, color: Colors.redAccent),
                      SizedBox(width: 1.w),
                      Text("Báo cáo", style: TextStyle(fontSize: 13.sp, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

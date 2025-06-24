// 📁 lib/representation/review/widgets/write_review_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/review_test_model.dart';

class WriteReviewModal<T> extends StatelessWidget {
  final void Function(T review) onSubmit;

  const WriteReviewModal({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showReviewModal(context),
        icon: Icon(Icons.edit_note_rounded, size: 18.sp),
        label: Text(
          "Viết đánh giá",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showReviewModal(BuildContext context) {
    String? _validationError;
    double tempRating = 5.0;
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 5.w,
                right: 5.w,
                top: 2.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Viết đánh giá",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  RatingBar.builder(
                    initialRating: tempRating,
                    minRating: 1,
                    itemCount: 5,
                    allowHalfRating: false,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) => tempRating = rating,
                  ),
                  SizedBox(height: 2.h),
                  if (_validationError != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _validationError!,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Chia sẻ trải nghiệm của bạn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final comment = commentController.text.trim();
                        if (comment.isEmpty) {
                          setModalState(() {
                            _validationError = "❗ Vui lòng nhập nội dung đánh giá.";
                          });
                          return;
                        }
                        Navigator.pop(context);
                        onSubmit(
                          ReviewTestModel(
                            id: const Uuid().v4(),
                            userName: "Người dùng ẩn danh",
                            userAvatarUrl: AssetHelper.img_ava_1,
                            rating: tempRating.toInt(),
                            comment: comment,
                            createdAt: DateTime.now(),
                            likes: 0,
                            dislikes: 0,
                          ) as T,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("🎉 Đánh giá của bạn đã được gửi. Cảm ơn bạn!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF00B4D8),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "Gửi đánh giá",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
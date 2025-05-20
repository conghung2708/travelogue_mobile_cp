import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';
import 'package:travelogue_mobile/model/review_test_model.dart';
import 'package:uuid/uuid.dart';

class ReviewsScreen<T extends ReviewBase> extends StatefulWidget {
  final List<T> reviews;
  final num averageRating;

  static const String routeName = '/reviews_screen';

  const ReviewsScreen({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  State<ReviewsScreen<T>> createState() => _ReviewsScreenState<T>();
}

class _ReviewsScreenState<T extends ReviewBase> extends State<ReviewsScreen<T>> {
  late List<T> _localReviews;
  final Map<int, String> _userVoteMap = {};
  String _selectedFilter = 'popular'; // 'popular' | 'newest'

  @override
  void initState() {
    super.initState();
    _localReviews = [...widget.reviews];
  }

  List<T> _getSortedReviews() {
    final sorted = [..._localReviews];
    if (_selectedFilter == 'popular') {
      sorted.sort((a, b) => b.likes.compareTo(a.likes));
    } else if (_selectedFilter == 'newest') {
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return sorted;
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
                  SizedBox(
                    width: double.infinity,
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
                        setState(() {
                          _localReviews.insert(
                            0,
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
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("🎉 Đánh giá của bạn đã được gửi. Cảm ơn bạn!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF00B4D8),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Gửi đánh giá"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: Colors.white,
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
  void _showReportDialog(T review) {
    final List<String> reasons = [
      "Ngôn từ không phù hợp",
      "Spam hoặc quảng cáo",
      "Nội dung gây hiểu nhầm",
      "Khác",
    ];

    final Set<String> selectedReasons = {};

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 10,
              insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.report_problem_rounded, size: 30.sp, color: Colors.redAccent),
                          SizedBox(height: 1.h),
                          Text(
                            "Báo cáo đánh giá",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontFamily: "Pattaya",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ...reasons.map(
                      (reason) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedReasons.contains(reason)
                                ? Colors.redAccent.withOpacity(0.1)
                                : Colors.grey.shade100,
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            value: selectedReasons.contains(reason),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  selectedReasons.add(reason);
                                } else {
                                  selectedReasons.remove(reason);
                                }
                              });
                            },
                            activeColor: Colors.blue[300],
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Hủy", style: TextStyle(fontSize: 12.5.sp)),
                        ),
                        ElevatedButton(
                          onPressed: selectedReasons.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _handleReport(
                                    review,
                                    selectedReasons.join(", "),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text("Gửi báo cáo", style: TextStyle(fontSize: 13.sp)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleReport(T review, String reason) {

    // debugPrint("📩 Reported review: ${review.id} - Reason: $reason");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("📩 Cảm ơn bạn đã báo cáo! Chúng tôi sẽ xem xét."),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        title: const Text("Đánh giá", style: TextStyle(fontFamily: "Pattaya")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(),
            SizedBox(height: 2.h),
            _buildTabFilters(),
            SizedBox(height: 2.h),
            Expanded(child: _buildReviewList()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(4.w),
        child: ElevatedButton.icon(
          onPressed: () => _showReviewModal(context),
          icon: const Icon(Icons.edit_note_rounded),
          label: const Text("Viết đánh giá"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B4D8),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 1.8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() => Row(
        children: [
          RatingBarIndicator(
            rating: widget.averageRating.toDouble(),
            itemCount: 5,
            itemSize: 22.sp,
            itemBuilder: (context, _) =>
                const Icon(Icons.star_rounded, color: Colors.amber),
          ),
          SizedBox(width: 2.w),
          Text(
            widget.averageRating.toStringAsFixed(1),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 2.w),
          Text("(${widget.reviews.length} đánh giá)"),
        ],
      );

  Widget _buildTabFilters() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            label: const Text("Phổ biến"),
            selected: _selectedFilter == 'popular',
            selectedColor: const Color(0xFF00B4D8),
            labelStyle: TextStyle(
              color: _selectedFilter == 'popular' ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() => _selectedFilter = 'popular'),
          ),
          ChoiceChip(
            label: const Text("Mới nhất"),
            selected: _selectedFilter == 'newest',
            selectedColor: const Color(0xFF00B4D8),
            labelStyle: TextStyle(
              color: _selectedFilter == 'newest' ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            onSelected: (_) => setState(() => _selectedFilter = 'newest'),
          ),
        ],
      );

  Widget _buildReviewList() {
    final reviews = _getSortedReviews();
    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 1),
      itemBuilder: (context, index) => _buildReviewItem(reviews[index], index),
    );
  }

  Widget _buildReviewItem(T review, int index) {
    final vote = _userVoteMap[index];

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
              itemBuilder: (context, _) =>
                  const Icon(Icons.star_rounded, color: Colors.amber),
            ),
            SizedBox(height: 1.h),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (vote == 'like') {
                        _localReviews[index].likes--;
                        _userVoteMap.remove(index);
                      } else if (vote == 'dislike') {
                        _localReviews[index].dislikes--;
                        _localReviews[index].likes++;
                        _userVoteMap[index] = 'like';
                      } else {
                        _localReviews[index].likes++;
                        _userVoteMap[index] = 'like';
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 18.sp,
                        color: vote == 'like' ? Colors.green : const Color(0xFF00B4D8),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Hữu ích (${_localReviews[index].likes})",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: vote == 'like' ? Colors.green : const Color(0xFF00B4D8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (vote == 'dislike') {
                        _localReviews[index].dislikes--;
                        _userVoteMap.remove(index);
                      } else if (vote == 'like') {
                        _localReviews[index].likes--;
                        _localReviews[index].dislikes++;
                        _userVoteMap[index] = 'dislike';
                      } else {
                        _localReviews[index].dislikes++;
                        _userVoteMap[index] = 'dislike';
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_down_alt_outlined,
                        size: 18.sp,
                        color: vote == 'dislike' ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Không hữu ích (${_localReviews[index].dislikes})",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: vote == 'dislike' ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _showReportDialog(review),
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 18.sp, color: Colors.redAccent),
                      SizedBox(width: 1.w),
                      Text(
                        "Báo cáo",
                        style: TextStyle(fontSize: 13.sp, color: Colors.redAccent),
                      ),
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

// 📁 lib/representation/review/screens/reviews_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';
import 'package:travelogue_mobile/representation/review/widgets/review_list.dart';
import 'package:travelogue_mobile/representation/review/widgets/rating_summary.dart';
import 'package:travelogue_mobile/representation/review/widgets/tab_filters.dart';
import 'package:travelogue_mobile/representation/review/widgets/write_review_modal.dart';
import 'package:travelogue_mobile/representation/review/widgets/report_dialog.dart';

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
  String _selectedFilter = 'popular';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
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
            RatingSummary(
              averageRating: widget.averageRating,
              totalReviews: widget.reviews.length,
            ),
            SizedBox(height: 2.h),
            TabFilters(
              selectedFilter: _selectedFilter,
              onFilterChanged: (value) => setState(() => _selectedFilter = value),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ReviewList<T>(
                reviews: _getSortedReviews(),
                userVoteMap: _userVoteMap,
                onReport: _handleReport,
                onUpdateVote: (index, newReview, newVote) => setState(() {
                  _localReviews[index] = newReview;
                  if (newVote == null) {
                    _userVoteMap.remove(index);
                  } else {
                    _userVoteMap[index] = newVote;
                  }
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(4.w),
        child: WriteReviewModal<T>(
          onSubmit: (review) => setState(() => _localReviews.insert(0, review)),
        ),
      ),
    );
  }

  void _handleReport(T review, String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF0077B6)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.mark_email_read_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "📩 Cảm ơn bạn đã báo cáo! Travelogue sẽ xem xét.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      ),
    );
  }
}

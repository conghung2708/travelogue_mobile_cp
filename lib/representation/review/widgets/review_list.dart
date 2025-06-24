// 📁 lib/representation/review/widgets/review_list.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';
import 'package:travelogue_mobile/representation/review/widgets/review_item.dart';
import 'package:travelogue_mobile/representation/review/widgets/report_dialog.dart';

class ReviewList<T extends ReviewBase> extends StatelessWidget {
  final List<T> reviews;
  final Map<int, String> userVoteMap;
  final void Function(int index, T updatedReview, String? newVote) onUpdateVote;
  final void Function(T review, String reason) onReport;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.userVoteMap,
    required this.onUpdateVote,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 1),
      itemBuilder: (context, index) => ReviewItem<T>(
        review: reviews[index],
        index: index,
        vote: userVoteMap[index],
        onLike: () {
          final review = reviews[index];
          int likes = review.likes;
          int dislikes = review.dislikes;
          String? currentVote = userVoteMap[index];

          if (currentVote == 'like') {
            likes--;
            currentVote = null;
          } else {
            if (currentVote == 'dislike') dislikes--;
            likes++;
            currentVote = 'like';
          }

          final updatedReview =
              review.copyWith(likes: likes, dislikes: dislikes) as T;
          onUpdateVote(index, updatedReview, currentVote);
        },
        onDislike: () {
          final review = reviews[index];
          int likes = review.likes;
          int dislikes = review.dislikes;
          String? currentVote = userVoteMap[index];

          if (currentVote == 'dislike') {
            dislikes--;
            currentVote = null;
          } else {
            if (currentVote == 'like') likes--;
            dislikes++;
            currentVote = 'dislike';
          }

          final updatedReview =
              review.copyWith(likes: likes, dislikes: dislikes) as T;
          onUpdateVote(index, updatedReview, currentVote);
        },
        onReport: (ctx) {
          showDialog(
            context: ctx,
            builder: (_) => ReportDialog<T>(
              review: reviews[index],
              onSubmit: (review, reason) => onReport(review, reason),
            ),
          );
        },
      ),
    );
  }
}

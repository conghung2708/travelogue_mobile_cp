// model/booking/report_review_request.dart
class ReportReviewRequest {
  final String reviewId;
  final String reason;

  const ReportReviewRequest({
    required this.reviewId,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'reviewId': reviewId,
        'reason': reason,
      };
}

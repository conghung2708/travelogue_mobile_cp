
class ReviewBookingRequest {
  final String bookingId;
  final String comment;
  final int rating;

  ReviewBookingRequest({
    required this.bookingId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "comment": comment,
        "rating": rating,
      };
}


class ReviewBookingResult {
  final bool succeeded;
  final String? message;

  ReviewBookingResult({required this.succeeded, this.message});

  factory ReviewBookingResult.fromMap(Map<String, dynamic> m) {
    final ok = (m['succeeded'] ?? m['Succeeded']) == true;
    final msg = (m['message'] ?? m['Message'])?.toString();
    return ReviewBookingResult(succeeded: ok, message: msg);
  }
}

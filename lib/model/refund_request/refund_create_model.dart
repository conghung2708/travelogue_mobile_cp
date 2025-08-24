class RefundCreateModel {
  final String bookingId;
  final String requestDate;
  final String reason;
  final int refundAmount;

  RefundCreateModel({
    required this.bookingId,
    required this.requestDate,
    required this.reason,
    required this.refundAmount,
  });

  factory RefundCreateModel.fromJson(Map<String, dynamic> json) {
    return RefundCreateModel(
      bookingId: json['bookingId'] as String,
      requestDate: json['requestDate'] as String,
      reason: json['reason'] as String,
      refundAmount: json['refundAmount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'requestDate': requestDate,
      'reason': reason,
      'refundAmount': refundAmount,
    };
  }
}

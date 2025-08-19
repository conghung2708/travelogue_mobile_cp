class RefundRequestModel {
  final String id;
  final String bookingId;
  final String userId;
  final String userName;
  final int status;
  final String statusText;
  final String? rejectionReason;
  final int refundAmount;            // int nhưng API có thể trả double
  final DateTime createdTime;
  final DateTime lastUpdatedTime;

  RefundRequestModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.status,
    required this.statusText,
    required this.rejectionReason,
    required this.refundAmount,
    required this.createdTime,
    required this.lastUpdatedTime,
  });

  factory RefundRequestModel.fromJson(Map<String, dynamic> json) {
    final num? amountNum = json['refundAmount'] as num?;
    return RefundRequestModel(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      status: json['status'] ?? 0,
      statusText: json['statusText'] ?? '',
      rejectionReason: json['rejectionReason'] as String?,
      refundAmount: amountNum?.round() ?? 0, // 👈 xử lý 10000.0 -> 10000
      createdTime: DateTime.tryParse(json['createdTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      lastUpdatedTime: DateTime.tryParse(json['lastUpdatedTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

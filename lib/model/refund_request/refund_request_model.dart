class RefundRequestModel {
  final String id;
  final String bookingId;
  final String userId;
  final String userName;
  final int status;
  final String statusText;
  final String? rejectionReason;
  final int refundAmount;
  final String? note;
  final DateTime? requestedAt;
  final DateTime? respondedAt;
  final DateTime createdTime;
  final DateTime lastUpdatedTime;
  final String? createdBy;
  final String? createdByName;
  final String? lastUpdatedBy;
  final String? lastUpdatedByName;

  RefundRequestModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.status,
    required this.statusText,
    this.rejectionReason,
    required this.refundAmount,
    this.note,
    this.requestedAt,
    this.respondedAt,
    required this.createdTime,
    required this.lastUpdatedTime,
    this.createdBy,
    this.createdByName,
    this.lastUpdatedBy,
    this.lastUpdatedByName,
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
      refundAmount: amountNum?.round() ?? 0,
      note: json['note'] as String?,
      requestedAt: DateTime.tryParse(json['requestedAt'] ?? ''),
      respondedAt: DateTime.tryParse(json['respondedAt'] ?? ''),
      createdTime: DateTime.tryParse(json['createdTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      lastUpdatedTime: DateTime.tryParse(json['lastUpdatedTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      createdBy: json['createdBy'] as String?,
      createdByName: json['createdByName'] as String?,
      lastUpdatedBy: json['lastUpdatedBy'] as String?,
      lastUpdatedByName: json['lastUpdatedByName'] as String?,
    );
  }
}

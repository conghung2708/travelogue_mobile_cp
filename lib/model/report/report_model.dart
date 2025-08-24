class ReportModel {
  final String id;
  final String userId;
  final String reviewId;
  final String reason;
  /// 1 = Pending, 2 = Accepted 
  final int status;
  final DateTime? reportedAt;
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;

  const ReportModel({
    required this.id,
    required this.userId,
    required this.reviewId,
    required this.reason,
    required this.status,
    this.reportedAt,
    this.createdTime,
    this.lastUpdatedTime,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: (json['id'] ?? '').toString(),
    userId: (json['userId'] ?? '').toString(),
    reviewId: (json['reviewId'] ?? '').toString(),
    reason: (json['reason'] ?? '').toString(),
    status: (json['status'] ?? 0) as int,
    reportedAt: json['reportedAt'] != null ? DateTime.tryParse(json['reportedAt']) : null,
    createdTime: json['createdTime'] != null ? DateTime.tryParse(json['createdTime']) : null,
    lastUpdatedTime: json['lastUpdatedTime'] != null ? DateTime.tryParse(json['lastUpdatedTime']) : null,
  );
}

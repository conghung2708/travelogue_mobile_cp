enum NotificationType { account, interaction, booking, system, unknown }
NotificationType _typeFromInt(dynamic v) {
  final n = (v is int) ? v : int.tryParse('$v');
  switch (n) { case 1: return NotificationType.account; case 2: return NotificationType.interaction;
    case 3: return NotificationType.booking; case 4: return NotificationType.system; default: return NotificationType.unknown; }
}

class NotificationModel {
  final String id, title, content, userId;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final String? tourId, tourGuideId, bookingId, reviewId, reportId;

  NotificationModel({
    required this.id, required this.title, required this.content,
    required this.createdAt, required this.isRead, required this.userId,
    required this.type, this.tourId, this.tourGuideId, this.bookingId, this.reviewId, this.reportId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    content: (json['content'] ?? '').toString(),
    createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    isRead: (json['isRead'] ?? json['isReaded'] ?? false) == true,
    userId: (json['userId'] ?? '').toString(),
    type: _typeFromInt(json['type']),
    tourId: json['tourId']?.toString(),
    tourGuideId: json['tourGuideId']?.toString(),
    bookingId: json['bookingId']?.toString(),
    reviewId: json['reviewId']?.toString(),
    reportId: json['reportId']?.toString(),
  );

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id, title: title, content: content, createdAt: createdAt,
    isRead: isRead ?? this.isRead, userId: userId, type: type,
    tourId: tourId, tourGuideId: tourGuideId, bookingId: bookingId, reviewId: reviewId, reportId: reportId,
  );
}

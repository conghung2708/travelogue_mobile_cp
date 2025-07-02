class TourGroupMemberTestModel {
  final int id;
  final int orderId;
  final int userId;
  final DateTime? joinDate;
  final String? comment;

  TourGroupMemberTestModel({
    required this.id,
    required this.orderId,
    required this.userId,
    this.joinDate,
    this.comment,
  });
}

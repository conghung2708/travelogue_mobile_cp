class OrderTestModel {
  final String id;
  final String userId;
  final String tourId;
  final String? tourGuideId;
  final DateTime orderDate;
  final DateTime scheduledStartDate;
  final DateTime scheduledEndDate;
  final int status;
  final DateTime? cancelledAt;
  final bool isOpenToJoin;
  final double totalPaid;
  final String? tripPlanId;
  final String? tripPlanVersionId;
  final DateTime createdTime;
  final DateTime lastUpdatedTime;
  final DateTime? deletedTime;
  final String createdBy;
  final String lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;
  final String? tourPlanVersionId;
  final String? tourVersionId;

  OrderTestModel({
    required this.id,
    required this.userId,
    required this.tourId,
    this.tourGuideId,
    required this.orderDate,
    required this.scheduledStartDate,
    required this.scheduledEndDate,
    required this.status,
    this.cancelledAt,
    required this.isOpenToJoin,
    required this.totalPaid,
    this.tripPlanId,
    this.tripPlanVersionId,
    required this.createdTime,
    required this.lastUpdatedTime,
    this.deletedTime,
    required this.createdBy,
    required this.lastUpdatedBy,
    this.deletedBy,
    required this.isActive,
    required this.isDeleted,
    this.tourPlanVersionId,
    this.tourVersionId,
  });
}

List<OrderTestModel> mockOrders = [];

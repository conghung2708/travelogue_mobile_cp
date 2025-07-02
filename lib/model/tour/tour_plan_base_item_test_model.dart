abstract class TourPlanBaseItemTestModel {
  final String id;
  final int dayOrder;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isActive;
  final bool isDeleted;
  final String tourPlanVersionId;

  TourPlanBaseItemTestModel({
    required this.id,
    required this.dayOrder,
    this.startTime,
    this.endTime,
    required this.isActive,
    required this.isDeleted,
    required this.tourPlanVersionId,
  });
}

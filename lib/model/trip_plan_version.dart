class TripPlanVersion {
  final String id;
  final String tripPlanId;
  final int versionNumber;
  final DateTime versionDate;
  final String description;
  final String notes;
  final String status;

  TripPlanVersion({
    required this.id,
    required this.tripPlanId,
    required this.versionNumber,
    required this.versionDate,
    required this.description,
    required this.notes,
    required this.status,
  });
}


final TripPlanVersion tripVersion = TripPlanVersion(
  id: 'ver001',
  tripPlanId: 'trip001',
  versionNumber: 1,
  versionDate: DateTime(2025, 7, 1),
  description: 'Phiên bản 1 - lịch trình 3 ngày tại Tây Ninh',
  notes: 'Kế hoạch tiêu chuẩn',
  status: 'active',
);


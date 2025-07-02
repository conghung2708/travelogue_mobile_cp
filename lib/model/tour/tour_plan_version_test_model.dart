class TourPlanVersionTestModel {
  final String id;
  final String tourId;
  final double price;
  final DateTime versionDate;
  final String description;
  final int versionNumber;
  final String? notes;
  final bool isActive;
  final bool isDeleted;
  final String? tourGuideId;

  TourPlanVersionTestModel({
    required this.id,
    required this.tourId,
    required this.price,
    required this.versionDate,
    required this.description,
    required this.versionNumber,
    this.notes,
    required this.isActive,
    required this.isDeleted,
    this.tourGuideId,
  });
}

final List<TourPlanVersionTestModel> mockTourPlanVersions = [
  TourPlanVersionTestModel(
    id: 'version1',
    tourId: 'tour1',
    price: 350000,
    versionDate: DateTime(2025, 7, 1),
    description: 'Phiên bản tiêu chuẩn cho tour trong ngày Núi Bà Đen.',
    versionNumber: 1,
    notes: 'Thích hợp cho nhóm nhỏ, không bao gồm vé cáp treo.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide1',
  ),
  TourPlanVersionTestModel(
    id: 'version2',
    tourId: 'tour2',
    price: 490000,
    versionDate: DateTime(2025, 7, 1),
    description: 'Phiên bản gốc 2 ngày khám phá tâm linh.',
    versionNumber: 1,
    notes: 'Bao gồm chỗ nghỉ qua đêm và ăn 4 bữa.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide3',
  ),
  TourPlanVersionTestModel(
    id: 'version3',
    tourId: 'tour2',
    price: 540000,
    versionDate: DateTime(2025, 7, 15),
    description: 'Phiên bản nâng cao với thêm điểm đến và bữa BBQ tối.',
    versionNumber: 2,
    notes: 'Thêm trải nghiệm thiền và đốt lửa trại.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide4',
  ),
];

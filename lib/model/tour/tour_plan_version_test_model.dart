class TourPlanVersionTestModel {
  final String id;
  final String tourId;
  final double adultPrice;
  final double childrenPrice;
  final DateTime versionDate;
  final String description;
  final int versionNumber;
  final String? notes;
  final bool isActive;
  final bool isDeleted;
  final String? tourGuideId;
  final bool isDiscount;
  final double price;

  TourPlanVersionTestModel({
    required this.id,
    required this.tourId,
    required this.adultPrice,
    required this.childrenPrice,
    required this.versionDate,
    required this.description,
    required this.versionNumber,
    this.notes,
    required this.isActive,
    required this.isDeleted,
    this.tourGuideId,
    this.isDiscount = false,
    double? price,
  }) : price = price ?? (isDiscount ? adultPrice * 0.9 : adultPrice);
}

final List<TourPlanVersionTestModel> mockTourPlanVersions = [
  TourPlanVersionTestModel(
    id: 'version1',
    tourId: 'tour1',
    adultPrice: 350000,
    childrenPrice: 250000,
    versionDate: DateTime(2025, 7, 1),
    description: 'Phiên bản tiêu chuẩn cho tour trong ngày Núi Bà Đen.',
    versionNumber: 1,
    notes: 'Thích hợp cho nhóm nhỏ, không bao gồm vé cáp treo.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide1',
    isDiscount: false,
    price: 350000, 
  ),
  TourPlanVersionTestModel(
    id: 'version2',
    tourId: 'tour2',
    adultPrice: 490000,
    childrenPrice: 340000,
    versionDate: DateTime(2025, 7, 1),
    description: 'Phiên bản gốc 2 ngày khám phá tâm linh.',
    versionNumber: 1,
    notes: 'Bao gồm chỗ nghỉ qua đêm và ăn 4 bữa.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide3',
    isDiscount: true,
    price: 550000, 
  ),
  TourPlanVersionTestModel(
    id: 'version3',
    tourId: 'tour2',
    adultPrice: 690000,
    childrenPrice: 390000,
    versionDate: DateTime(2025, 7, 15),
    description: 'Phiên bản nâng cao với thêm điểm đến và bữa BBQ tối.',
    versionNumber: 2,
    notes: 'Thêm trải nghiệm thiền và đốt lửa trại.',
    isActive: true,
    isDeleted: false,
    tourGuideId: 'guide4',
    isDiscount: true,
    price: 540000,
  ),
];

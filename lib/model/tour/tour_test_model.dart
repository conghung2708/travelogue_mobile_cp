

class TourTestModel {
  final String id;
  final String name;
  final String description;
  final String content;
  final String tourTypeId;
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final DateTime? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;
  final String? currentVersionId;
  final int totalDays;

  TourTestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.tourTypeId,
    this.createdTime,
    this.lastUpdatedTime,
    this.deletedTime,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    required this.isActive,
    required this.isDeleted,
    this.currentVersionId,
    required this.totalDays,
  });
}

final List<TourTestModel> mockTourTests = [
  TourTestModel(
    id: 'tour1',
    name: 'Khám phá Núi Bà Đen trong ngày',
    description: 'Tour trong ngày khám phá núi Bà Đen với các địa điểm nổi bật.',
    content: 'Lịch trình bao gồm leo núi, ăn trưa sinh thái và tắm suối.',
    tourTypeId: 'type1',
    currentVersionId: 'version1',
    isActive: true,
    isDeleted: false,
    totalDays: 1,
  ),
  TourTestModel(
    id: 'tour2',
    name: 'Tour Văn hoá - Tâm linh 2 ngày',
    description: 'Tour khám phá các địa điểm văn hóa, tâm linh đặc sắc tại Tây Ninh trong 2 ngày.',
    content: 'Lịch trình bao gồm ăn tại nhà hàng nổi tiếng.',
    tourTypeId: 'type2',
    currentVersionId: 'version3',
    isActive: true,
    isDeleted: false,
    totalDays: 2,
  ),
];

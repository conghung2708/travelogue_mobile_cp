class TourTypeTestModel {
  final String id;
  final String name;
  final String description;
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final DateTime? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;

  TourTypeTestModel({
    required this.id,
    required this.name,
    required this.description,
    this.createdTime,
    this.lastUpdatedTime,
    this.deletedTime,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    required this.isActive,
    required this.isDeleted,
  });
}

final List<TourTypeTestModel> mockTourTypes = [
  TourTypeTestModel(
    id: 'type1',
    name: 'Trọn gói',
    description: 'Bao gồm hướng dẫn viên và toàn bộ dịch vụ',
    isActive: true,
    isDeleted: false,
  ),
  TourTypeTestModel(
    id: 'type2',
    name: 'Chỉ HDV',
    description: 'Chỉ gồm hướng dẫn viên',
    isActive: true,
    isDeleted: false,
  ),
];

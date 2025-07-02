class TourScheduleTestModel {
  final String id;
  final String tourId;
  final DateTime departureDate;
  final int maxParticipant;
  final int currentBooked;
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final DateTime? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;

  TourScheduleTestModel({
    required this.id,
    required this.tourId,
    required this.departureDate,
    required this.maxParticipant,
    required this.currentBooked,
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

final List<TourScheduleTestModel> mockTourSchedules = [
  TourScheduleTestModel(
    id: 'schedule1',
    tourId: 'tour1',
    departureDate: DateTime(2025, 7, 10),
    maxParticipant: 20,
    currentBooked: 12,
    isActive: true,
    isDeleted: false,
  ),
  TourScheduleTestModel(
    id: 'schedule2',
    tourId: 'tour1',
    departureDate: DateTime(2025, 7, 20),
    maxParticipant: 25,
    currentBooked: 18,
    isActive: true,
    isDeleted: false,
  ),
  TourScheduleTestModel(
    id: 'schedule3',
    tourId: 'tour2',
    departureDate: DateTime(2025, 7, 15),
    maxParticipant: 30,
    currentBooked: 27,
    isActive: true,
    isDeleted: false,
  ),
  TourScheduleTestModel(
    id: 'schedule4',
    tourId: 'tour2',
    departureDate: DateTime(2025, 7, 25),
    maxParticipant: 30,
    currentBooked: 21,
    isActive: true,
    isDeleted: false,
  ),
];

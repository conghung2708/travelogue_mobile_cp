// workshop_schedule_test_model.dart
class WorkshopScheduleTestModel {
  final String id;
  final String workshopId;
  final String startTime;          
  final String endTime;
  final int maxParticipant;
  final String? notes;
  final double adultPrice;
  final double childrenPrice;
  final String? createdTime;
  final String? lastUpdatedTime;
  final String? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;
  final int? currentBooked;

  WorkshopScheduleTestModel({
    required this.id,
    required this.workshopId,
    required this.startTime,
    required this.endTime,
    required this.maxParticipant,
    this.notes,
    required this.adultPrice,
    required this.childrenPrice,
    this.createdTime,
    this.lastUpdatedTime,
    this.deletedTime,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    this.isActive = true,
    this.isDeleted = false,
    this.currentBooked,
  });
}

final List<WorkshopScheduleTestModel> workshopSchedules = [
  WorkshopScheduleTestModel(
    id: 'ws01-1',
    workshopId: 'w01',
    startTime: '2025-07-15T08:00:00',
    endTime:   '2025-07-15T10:30:00',
    maxParticipant: 20,
    currentBooked: 12,
    notes: 'Ca sáng – bao gồm ăn nhẹ.',
    adultPrice: 120000,
    childrenPrice: 60000,
    createdTime: '2025-07-01T09:00:00',
    lastUpdatedTime: '2025-07-05T15:30:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff01',
  ),
  WorkshopScheduleTestModel(
    id: 'ws01-2',
    workshopId: 'w01',
    startTime: '2025-07-16T14:00:00',
    endTime:   '2025-07-16T16:30:00',
    maxParticipant: 20,
    currentBooked: 5,
    notes: 'Ca chiều, kèm demo phơi sương bánh.',
    adultPrice: 120000,
    childrenPrice: 60000,
  ),

  WorkshopScheduleTestModel(
    id: 'ws02-1',
    workshopId: 'w02',
    startTime: '2025-07-18T09:00:00',
    endTime:   '2025-07-18T11:00:00',
    maxParticipant: 15,
    currentBooked: 7,
    notes: 'Pha hương quế–trầm, se nhang.',
    adultPrice: 90000,
    childrenPrice: 50000,
  ),

  WorkshopScheduleTestModel(
    id: 'ws03-1',
    workshopId: 'w03',
    startTime: '2025-07-20T13:30:00',
    endTime:   '2025-07-20T16:00:00',
    maxParticipant: 25,
    currentBooked: 18,
    notes: 'Tặng giỏ mây mang về.',
    adultPrice: 150000,
    childrenPrice: 80000,
  ),

  WorkshopScheduleTestModel(
    id: 'ws04-1',
    workshopId: 'w04',
    startTime: '2025-07-22T08:30:00',
    endTime:   '2025-07-22T11:30:00',
    maxParticipant: 30,
    currentBooked: 0,
    notes: 'Làm nón lá + vẽ hoa sen.',
    adultPrice: 100000,
    childrenPrice: 50000,
  ),


  WorkshopScheduleTestModel(
    id: 'ws05-1',
    workshopId: 'w05',
    startTime: '2025-07-24T09:00:00',
    endTime:   '2025-07-24T10:30:00',
    maxParticipant: 25,
    currentBooked: 3,
    notes: 'Thử bánh tráng trộn remix.',
    adultPrice: 80000,
    childrenPrice: 40000,
  ),
];

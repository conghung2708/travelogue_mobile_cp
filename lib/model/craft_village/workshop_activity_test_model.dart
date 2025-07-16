class WorkshopActivityTestModel {
  final String id;
  final String workshopId;
  final String activity;
  final String? description;
  final String? startTime;
  final String? endTime;
  final String? notes;
  final int? dayOrder;
  final String? createdTime;
  final String? lastUpdatedTime;
  final String? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;

  WorkshopActivityTestModel({
    required this.id,
    required this.workshopId,
    required this.activity,
    this.description,
    this.startTime,
    this.endTime,
    this.notes,
    this.dayOrder,
    this.createdTime,
    this.lastUpdatedTime,
    this.deletedTime,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    this.isActive = true,
    this.isDeleted = false,
  });
}



final List<WorkshopActivityTestModel> workshopActivities = [

  WorkshopActivityTestModel(
    id: 'wa101',
    workshopId: 'w01',
    activity: 'Giới thiệu lịch sử bánh tráng',
    description: 'Video + thuyết minh 15 phút về nguồn gốc bánh tráng phơi sương.',
    startTime: '08:00',
    endTime: '08:15',
    dayOrder: 1,
    notes: 'Phòng chiếu mini 25 chỗ.',
    createdBy: 'admin',
  ),
  WorkshopActivityTestModel(
    id: 'wa102',
    workshopId: 'w01',
    activity: 'Pha bột & đánh bột',
    description: 'Học viên chia nhóm, thực hành pha bột gạo.',
    startTime: '08:15',
    endTime: '08:45',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa103',
    workshopId: 'w01',
    activity: 'Tráng bánh trên nồi hơi',
    startTime: '08:50',
    endTime: '09:30',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa104',
    workshopId: 'w01',
    activity: 'Phơi sương thực tế',
    startTime: '09:30',
    endTime: '10:00',
    dayOrder: 1,
    notes: 'Nếu trời mưa dùng máy phun sương giả lập.',
  ),
  WorkshopActivityTestModel(
    id: 'wa105',
    workshopId: 'w01',
    activity: 'Cuốn bánh & thưởng thức',
    startTime: '10:00',
    endTime: '10:30',
    dayOrder: 1,
    notes: 'Kèm rau rừng, thịt luộc, mắm me.',
  ),


  WorkshopActivityTestModel(
    id: 'wa201',
    workshopId: 'w02',
    activity: 'Chọn tre & chẻ lõi',
    startTime: '14:00',
    endTime: '14:30',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa202',
    workshopId: 'w02',
    activity: 'Pha bột hương quế-trầm',
    startTime: '14:30',
    endTime: '15:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa203',
    workshopId: 'w02',
    activity: 'Se nhang bằng khung xoay',
    startTime: '15:05',
    endTime: '15:45',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa204',
    workshopId: 'w02',
    activity: 'Nhuộm màu & phơi nhang',
    startTime: '15:45',
    endTime: '16:15',
    dayOrder: 1,
    notes: 'Màu tự nhiên từ lá bàng.',
  ),


  WorkshopActivityTestModel(
    id: 'wa301',
    workshopId: 'w03',
    activity: 'Giới thiệu chất liệu mây, tre',
    startTime: '09:00',
    endTime: '09:20',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa302',
    workshopId: 'w03',
    activity: 'Chẻ & vót nan',
    startTime: '09:20',
    endTime: '10:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa303',
    workshopId: 'w03',
    activity: 'Đan mắt cáo',
    startTime: '10:10',
    endTime: '11:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa304',
    workshopId: 'w03',
    activity: 'Định hình giỏ & hoàn thiện',
    startTime: '11:00',
    endTime: '11:30',
    dayOrder: 1,
  ),


  WorkshopActivityTestModel(
    id: 'wa401',
    workshopId: 'w04',
    activity: 'Phân loại & xử lý lá',
    startTime: '13:30',
    endTime: '14:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa402',
    workshopId: 'w04',
    activity: 'Lên khung tre vầu',
    startTime: '14:00',
    endTime: '14:40',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa403',
    workshopId: 'w04',
    activity: 'Chằm chỉ sen',
    startTime: '14:50',
    endTime: '15:40',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa404',
    workshopId: 'w04',
    activity: 'Trang trí & quét dầu bóng',
    startTime: '15:40',
    endTime: '16:00',
    dayOrder: 1,
  ),


  WorkshopActivityTestModel(
    id: 'wa501',
    workshopId: 'w05',
    activity: 'Chọn ớt & sơ chế',
    startTime: '08:30',
    endTime: '09:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa502',
    workshopId: 'w05',
    activity: 'Rang muối hột',
    startTime: '09:00',
    endTime: '09:20',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa503',
    workshopId: 'w05',
    activity: 'Xay & phối gia vị',
    startTime: '09:25',
    endTime: '10:00',
    dayOrder: 1,
  ),
  WorkshopActivityTestModel(
    id: 'wa504',
    workshopId: 'w05',
    activity: 'Đóng lọ & kiểm tra vị giác',
    startTime: '10:00',
    endTime: '10:20',
    dayOrder: 1,
    notes: 'Thử vị trên thang 6 vị Việt.',
  ),
];

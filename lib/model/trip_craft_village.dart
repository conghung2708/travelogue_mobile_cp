import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';

class TripPlanCraftVillage {
  final String tripPlanVersionId;
  final CraftVillageModel craftVillage;
  final DateTime startTime;
  final DateTime endTime;
  final String note;
  final int order;

  TripPlanCraftVillage({
    required this.tripPlanVersionId,
    required this.craftVillage,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.order,
  });
}

final List<TripPlanCraftVillage> tripCraftVillages = [
  TripPlanCraftVillage(
    tripPlanVersionId: 'ver001',
    craftVillage: craftVillages[0],
    startTime: DateTime(2025, 7, 10, 8, 0),
    endTime: DateTime(2025, 7, 10, 9, 30),
    note: 'Trải nghiệm làng nghề bánh tráng',
    order: 0,
  ),
  TripPlanCraftVillage(
    tripPlanVersionId: 'ver001',
    craftVillage: craftVillages[1],
    startTime: DateTime(2025, 7, 11, 8, 0),
    endTime: DateTime(2025, 7, 11, 9, 30),
    note: 'Trải nghiệm làm nhang thủ công',
    order: 1,
  ),
];


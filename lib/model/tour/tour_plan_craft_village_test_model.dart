import 'package:travelogue_mobile/model/tour/tour_plan_base_item_test_model.dart';

class TourPlanCraftVillageTestModel extends TourPlanBaseItemTestModel {
  final String craftVillageId;

  TourPlanCraftVillageTestModel({
    required String id,
    required int dayOrder,
    DateTime? startTime,
    DateTime? endTime,
    required bool isActive,
    required bool isDeleted,
    required String tourPlanVersionId,
    required this.craftVillageId,
  }) : super(
          id: id,
          dayOrder: dayOrder,
          startTime: startTime,
          endTime: endTime,
          isActive: isActive,
          isDeleted: isDeleted,
          tourPlanVersionId: tourPlanVersionId,
        );
}

final List<TourPlanCraftVillageTestModel> mockTourPlanCraftVillages = [
  TourPlanCraftVillageTestModel(
    id: "tourPlanCraftVillage1",
    dayOrder: 2,
    tourPlanVersionId: "version3",
    craftVillageId: 'craft01',
    isActive: true,
    isDeleted: false,
  ),
];

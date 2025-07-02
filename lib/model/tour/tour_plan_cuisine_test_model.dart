import 'package:travelogue_mobile/model/tour/tour_plan_base_item_test_model.dart';

class TourPlanCuisineTestModel extends TourPlanBaseItemTestModel {
  final String cuisineId;

  TourPlanCuisineTestModel({
    required String id,
    required int dayOrder,
    DateTime? startTime,
    DateTime? endTime,
    required bool isActive,
    required bool isDeleted,
    required String tourPlanVersionId,
    required this.cuisineId,
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


final List<TourPlanCuisineTestModel> mockTourPlanCuisines = [
  TourPlanCuisineTestModel(
    id: "tourPlanCuisine1",
    dayOrder: 1,
    tourPlanVersionId: "version1",
    cuisineId: "08dd734a-3eb5-4605-8023-70183cc30cd0",
    isActive: true,
    isDeleted: false,
  ),
  TourPlanCuisineTestModel(
    id: 'tourPlanCuisine2',
    dayOrder: 1,
    tourPlanVersionId: 'version3',
    cuisineId: '08dd734a-3eb5-4605-8023-70183cc30cd1',
    isActive: true,
    isDeleted: false,
  ),
  TourPlanCuisineTestModel(
    id: 'tourPlanCuisine3',
    dayOrder: 2,
    tourPlanVersionId: 'version3',
    cuisineId: '08dd750c-f97e-41cd-854c-402a7634a231',
    isActive: true,
    isDeleted: false,
  ),
];

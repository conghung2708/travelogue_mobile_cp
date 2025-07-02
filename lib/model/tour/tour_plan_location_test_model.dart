import 'package:travelogue_mobile/model/tour/tour_plan_base_item_test_model.dart';

class TourPlanLocationTestModel extends TourPlanBaseItemTestModel {
  final String locationId;

  TourPlanLocationTestModel({
    required String id,
    required int dayOrder,
    DateTime? startTime,
    DateTime? endTime,
    required bool isActive,
    required bool isDeleted,
    required String tourPlanVersionId,
    required this.locationId,
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

final List<TourPlanLocationTestModel> mockTourPlanLocations = [
  TourPlanLocationTestModel(
    id: 'tourPlanLocation1',
    dayOrder: 1,
    tourPlanVersionId: 'version1',
    locationId: '08dd751f-1dd4-4d6d-89be-e18ea5cc1d27',
    isActive: true,
    isDeleted: false,
  ),
  TourPlanLocationTestModel(
    id: 'tourPlanLocation2',
    dayOrder: 1,
    tourPlanVersionId: 'version1',
    locationId: "08dd7528-6ee4-4582-8b89-d79b762cb4a3",
    isActive: true,
    isDeleted: false,
  ),
  TourPlanLocationTestModel(
    id: 'tourPlanLocation3',
    dayOrder: 1,
    tourPlanVersionId: 'version3',
    locationId: '08dd752b-807b-4197-83b0-8b146c766726',
    isActive: true,
    isDeleted: false,
  ),
  TourPlanLocationTestModel(
    id: 'tourPlanLocation4',
    dayOrder: 1,
    tourPlanVersionId: 'version3',
    locationId: '08dd752b-38d1-4640-8bdf-131370085b87',
    isActive: true,
    isDeleted: false,
  ),
  TourPlanLocationTestModel(
    id: 'tourPlanLocation5',
    dayOrder: 2,
    tourPlanVersionId: 'version3',
    locationId: '08dd751e-5789-4a69-894c-ae4e837cf991',
    isActive: true,
    isDeleted: false,
  ),
  TourPlanLocationTestModel(
    id: 'tourPlanLocation6',
    dayOrder: 2,
    tourPlanVersionId: 'version3',
    locationId: '08dd751a-4262-4bee-8ce2-51c4d0fa4497',
    isActive: true,
    isDeleted: false,
  ),
];

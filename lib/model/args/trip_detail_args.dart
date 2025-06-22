import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';

class TripDetailArgs {
  final BaseTrip trip;
  final TourGuideTestModel? guide;
  final List<TripPlanLocation>? locations;
  final List<TripPlanCuisine>? cuisines;
  final List<TripPlanCraftVillage>? villages;
  final List<DateTime>? days;

  TripDetailArgs({
    required this.trip,
    this.guide,
    this.locations,
    this.cuisines,
    this.villages,
    this.days,
  });
}

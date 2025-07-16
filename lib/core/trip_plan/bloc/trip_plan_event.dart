

import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

abstract class TripPlanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitTripPlanDaysEvent extends TripPlanEvent {
  final List<DateTime> days;
  InitTripPlanDaysEvent(this.days);

  @override
  List<Object?> get props => [days];
}

class SelectLocationEvent extends TripPlanEvent {
  final DateTime day;
  final LocationModel location;
  SelectLocationEvent({required this.day, required this.location});

  @override
  List<Object?> get props => [day, location];
}

class SelectRestaurantEvent extends TripPlanEvent {
  final DateTime day;
  final RestaurantModel restaurant;
  SelectRestaurantEvent({required this.day, required this.restaurant});

  @override
  List<Object?> get props => [day, restaurant];
}

class SelectCraftVillageEvent extends TripPlanEvent {
  final DateTime day;
  final CraftVillageModel village;
  SelectCraftVillageEvent({required this.day, required this.village});

  @override
  List<Object?> get props => [day, village];
}

class MarkDayCompleteEvent extends TripPlanEvent {
  final DateTime day;
  MarkDayCompleteEvent(this.day);

  @override
  List<Object?> get props => [day];
}

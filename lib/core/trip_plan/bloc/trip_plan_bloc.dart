import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/trip_plan/bloc/trip_plan_event.dart';
import 'package:travelogue_mobile/core/trip_plan/bloc/trip_plan_state.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';


class TripPlanBloc extends Bloc<TripPlanEvent, TripPlanState> {
  TripPlanBloc() : super(const TripPlanState()) {
    on<InitTripPlanDaysEvent>(_onInitDays);
    on<SelectLocationEvent>(_onSelectLocation);
    on<SelectRestaurantEvent>(_onSelectRestaurant);
    on<SelectCraftVillageEvent>(_onSelectVillage);
    on<MarkDayCompleteEvent>(_onCompleteDay);
  }

  void _onInitDays(InitTripPlanDaysEvent event, Emitter<TripPlanState> emit) {
    final sortedDays = [...event.days]..sort();
    emit(state.copyWith(
      days: sortedDays,
      currentDay: sortedDays.isNotEmpty ? sortedDays.first : null,
    ));
  }

  void _onSelectLocation(SelectLocationEvent event, Emitter<TripPlanState> emit) {
    final updated = Map.of(state.selectedLocations);
final list = List<LocationModel>.of(updated[event.day] ?? []);
    list.add(event.location);
    updated[event.day] = list;
    emit(state.copyWith(selectedLocations: updated));
  }

  void _onSelectRestaurant(SelectRestaurantEvent event, Emitter<TripPlanState> emit) {
    final updated = Map.of(state.selectedRestaurants);
final list = List<RestaurantModel>.of(updated[event.day] ?? []);
    list.add(event.restaurant);
    updated[event.day] = list;
    emit(state.copyWith(selectedRestaurants: updated));
  }

  void _onSelectVillage(SelectCraftVillageEvent event, Emitter<TripPlanState> emit) {
    final updated = Map.of(state.selectedVillages);
final list = List<CraftVillageModel>.of(updated[event.day] ?? []);
    list.add(event.village);
    updated[event.day] = list;
    emit(state.copyWith(selectedVillages: updated));
  }

  void _onCompleteDay(MarkDayCompleteEvent event, Emitter<TripPlanState> emit) {
    final completed = Set.of(state.completedDays)..add(event.day);
    final currentIndex = state.days.indexOf(event.day);
    final nextDay = (currentIndex + 1 < state.days.length)
        ? state.days[currentIndex + 1]
        : null;
    emit(state.copyWith(
      completedDays: completed,
      currentDay: nextDay,
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/home_repository.dart';
import 'package:travelogue_mobile/data/data_local/home_local.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/type_location_model.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<TypeLocationModel> locationTypes = [];
  List<LocationModel> locations = [];
  final List<EventModel> events = [];
  final List<LocationModel> locationFavorites = [];
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is GetLocationTypeEvent) {
        if (HomeLocal().getListTypeLocation()?.isNotEmpty ?? false) {
          locationTypes.addAll(HomeLocal().getListTypeLocation()!);
          emit(_getHomeSuccess);
        }

        await _getLocationType();
        emit(_getHomeSuccess);
      }

      if (event is GetAllLocationEvent) {
        if (HomeLocal().getAllLocations()?.isNotEmpty ?? false) {
          locations.addAll(HomeLocal().getAllLocations()!);
          emit(_getHomeSuccess);
        }

        await _getLocationAll();
        emit(_getHomeSuccess);
      }

      if (event is FilterLocationTypeEvent) {
        if (HomeLocal().getAllLocations()?.isNotEmpty ?? false) {
          locations.clear();
          locations.addAll(HomeLocal()
              .getAllLocations()!
              .where((e) => e.typeLocationId == event.locationTypeId)
              .toList());

          if (locations.isEmpty) {
            locations.addAll(HomeLocal().getAllLocations()!);
          }
          emit(_getHomeSuccess);
        }
      }

      if (event is GetEventHomeEvent) {
        if (HomeLocal().getEvents()?.isNotEmpty ?? false) {
          events.addAll(HomeLocal().getEvents()!);
          emit(_getHomeSuccess);
        }

        await _getEvents();
        emit(_getHomeSuccess);
      }

      if (event is GetLocationFavoriteEvent) {
        await _getLocationFavorite();
        locations = locations
            .map((e) => e.copyWith(
                isLiked:
                    locationFavorites.map((e) => e.id).toList().contains(e.id)))
            .toList();

        emit(_getHomeSuccess);
      }

      if (event is UpdateLikedLocationEvent) {
        if (UserLocal().getAccessToken.isEmpty) {
          Navigator.of(event.context).pushNamed(LoginScreen.routeName);
          return;
        }

        final List<String> listIdFavorite = HomeLocal().getListLocationFavorite;

        if (event.isLiked) {
          bool isSuccess = await _updateFavorite(event);
          if (!isSuccess) {
            return;
          }
          listIdFavorite.add(event.locationId);
          HomeLocal().saveLocationFavorite(listIdFavorite: listIdFavorite);
        } else {
          bool isSuccess = await _updateFavorite(event);
          if (!isSuccess) {
            return;
          }
          listIdFavorite.remove(event.locationId);
          HomeLocal().saveLocationFavorite(listIdFavorite: listIdFavorite);
        }

        locations = locations
            .map((e) => e.copyWith(isLiked: listIdFavorite.contains(e.id)))
            .toList();
        emit(_getHomeSuccess);
      }
    });
  }

  // Private function
  GetHomeSuccess get _getHomeSuccess => GetHomeSuccess(
        typeLocations: locationTypes,
        locations: locations,
        events: events,
        locationFavorites: locationFavorites,
      );

  Future<void> _getLocationType() async {
    final List<TypeLocationModel> listType =
        await HomeRepository().getTypeLocation();

    if (listType.isEmpty) {
      return;
    }

    locationTypes.addAll(listType);
    HomeLocal().saveTypeLocations(types: listType);
  }

  Future<void> _getLocationAll() async {
    final List<LocationModel> allLocations =
        await HomeRepository().getAllLocation();

    if (allLocations.isEmpty) {
      return;
    }

    locations.addAll(allLocations);
    HomeLocal().saveAllLocations(locations: allLocations);
  }

  Future<void> _getEvents() async {
    final List<EventModel> allEvents = await HomeRepository().getEvents();
    if (allEvents.isEmpty) {
      return;
    }

    events.addAll(allEvents);
    HomeLocal().saveEvents(events: allEvents);
  }

  Future<void> _getLocationFavorite() async {
    final List<LocationModel> listFavorite =
        await HomeRepository().getLocationFavorite();
    if (listFavorite.isEmpty) {
      return;
    }

    locationFavorites.addAll(listFavorite);
    HomeLocal().saveLocationFavorite(
        listIdFavorite: listFavorite.map((e) => e.id ?? '').toList());
  }

  Future<bool> _updateFavorite(UpdateLikedLocationEvent event) async {
    bool isSuccess = false;
    if (event.isLiked) {
      isSuccess = await HomeRepository()
          .updateLikedLocation(locationId: event.locationId);
    } else {
      isSuccess = await HomeRepository()
          .deletedLikedLocation(locationId: event.locationId);
    }
    return isSuccess;
  }
}

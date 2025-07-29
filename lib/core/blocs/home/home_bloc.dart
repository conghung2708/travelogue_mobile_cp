import 'package:equatable/equatable.dart';
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
    on<GetLocationTypeEvent>(_onGetLocationType);
    on<GetAllLocationEvent>(_onGetAllLocation);
    on<GetEventHomeEvent>(_onGetEvents);
    on<GetLocationFavoriteEvent>(_onGetLocationFavorite);
    on<FilterLocationByCategoryEvent>(_onFilterLocationByCategory);
    on<UpdateLikedLocationEvent>(_onUpdateLikedLocation);
  }

  Future<void> _onGetLocationType(
      GetLocationTypeEvent event, Emitter<HomeState> emit) async {
    if (HomeLocal().getListTypeLocation()?.isNotEmpty ?? false) {
      locationTypes
        ..clear()
        ..addAll(HomeLocal().getListTypeLocation()!);
      emit(_getHomeSuccess);
    }

    final listType = await HomeRepository().getTypeLocation();
    if (listType.isNotEmpty) {
      locationTypes
        ..clear()
        ..addAll(listType);
      HomeLocal().saveTypeLocations(types: listType);
      emit(_getHomeSuccess);
    }
  }
Future<void> _onGetAllLocation(GetAllLocationEvent event, Emitter<HomeState> emit) async {
  emit(HomeLoading()); 

  final allLocations = await HomeRepository().getAllLocation();
  print('📡 Gọi API lấy địa điểm...');

  if (allLocations.isNotEmpty) {
    locations = [...allLocations];
    print('✅ Lấy địa điểm từ API thành công: ${locations.length} địa điểm');
    HomeLocal().saveAllLocations(locations: allLocations);
    emit(_getHomeSuccess); 
  } else {
    print('❌ API trả về danh sách rỗng.');
    emit(HomeInitial());
  }
}


  Future<void> _onGetEvents(
      GetEventHomeEvent event, Emitter<HomeState> emit) async {
    if (HomeLocal().getEvents()?.isNotEmpty ?? false) {
      events
        ..clear()
        ..addAll(HomeLocal().getEvents()!);
      emit(_getHomeSuccess);
    }

    final allEvents = await HomeRepository().getEvents();
    if (allEvents.isNotEmpty) {
      events
        ..clear()
        ..addAll(allEvents);
      HomeLocal().saveEvents(events: allEvents);
      emit(_getHomeSuccess);
    }
  }

  Future<void> _onGetLocationFavorite(
      GetLocationFavoriteEvent event, Emitter<HomeState> emit) async {
    final listFavorite = await HomeRepository().getLocationFavorite();
    if (listFavorite.isEmpty) return;

    locationFavorites
      ..clear()
      ..addAll(listFavorite);

    final favoriteIds = locationFavorites.map((e) => e.id).toSet();
    locations = locations
        .map((e) => e.copyWith(isLiked: favoriteIds.contains(e.id)))
        .toList();

    HomeLocal().saveLocationFavorite(
      listIdFavorite: locationFavorites.map((e) => e.id ?? '').toList(),
    );

    emit(_getHomeSuccess);
  }

void _onFilterLocationByCategory(
    FilterLocationByCategoryEvent event, Emitter<HomeState> emit) {
  final all = HomeLocal().getAllLocations();
  if (all == null) return;

  final filtered = all.where((e) {
    final cat = e.category?.toLowerCase().trim();
    final selectedCat = event.category.toLowerCase().trim();
    return cat == selectedCat;
  }).toList();

  locations = filtered.isEmpty ? all : filtered;
  emit(_getHomeSuccess);
}


  Future<void> _onUpdateLikedLocation(
      UpdateLikedLocationEvent event, Emitter<HomeState> emit) async {
    if (UserLocal().getAccessToken.isEmpty) {
      Navigator.of(event.context).pushNamed(LoginScreen.routeName);
      return;
    }

    final listIdFavorite = HomeLocal().getListLocationFavorite.toSet();

    final success = event.isLiked
        ? await HomeRepository()
            .updateLikedLocation(locationId: event.locationId)
        : await HomeRepository()
            .deletedLikedLocation(locationId: event.locationId);

    if (!success) return;

    event.isLiked
        ? listIdFavorite.add(event.locationId)
        : listIdFavorite.remove(event.locationId);

    HomeLocal()
        .saveLocationFavorite(listIdFavorite: listIdFavorite.toList());

    locations = locations
        .map((e) => e.copyWith(isLiked: listIdFavorite.contains(e.id)))
        .toList();

    emit(_getHomeSuccess);
  }

  GetHomeSuccess get _getHomeSuccess => GetHomeSuccess(
        typeLocations: locationTypes,
        locations: locations,
        events: events,
        locationFavorites: locationFavorites,
      );
}

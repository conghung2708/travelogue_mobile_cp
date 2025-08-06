import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/experience/experience_bloc.dart';
import 'package:travelogue_mobile/core/blocs/festival/festival_bloc.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/blocs/hotel_restaurent/hotel_restaurant_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_bloc.dart';
import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';
import 'package:travelogue_mobile/core/blocs/search/search_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_bloc.dart';
import 'package:travelogue_mobile/core/blocs/user/user_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/core/repository/user_repository.dart';
import 'package:travelogue_mobile/core/repository/workshop_repository.dart';
import 'package:travelogue_mobile/core/trip_plan/bloc/trip_plan_bloc.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class AppBloc {
  static final MainBloc mainBloc = MainBloc();
  static final HomeBloc homeBloc = HomeBloc();
  static final AuthenicateBloc authenicateBloc = AuthenicateBloc();
  static final SearchBloc searchBloc = SearchBloc();
  static final HotelRestaurantBloc hotelRestaurantBloc = HotelRestaurantBloc();
  static final NewsBloc newsBloc = NewsBloc();
  static final FestivalBloc festivalBloc = FestivalBloc();
  static final ExperienceBloc experienceBloc = ExperienceBloc();
  static final TripPlanBloc tripPlanBloc = TripPlanBloc();
  static final TourBloc tourBloc = TourBloc();
  static final TourGuideBloc tourGuideBloc =
      TourGuideBloc(TourGuideRepository());
  static final BookingBloc bookingBloc = BookingBloc(BookingRepository());
  static final WorkshopBloc workshopBloc = WorkshopBloc(WorkshopRepository());
  static final UserBloc userBloc = UserBloc(UserRepository());

  List<BlocProvider> providers = [
    BlocProvider<MainBloc>(
      create: (context) => mainBloc,
    ),
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
    BlocProvider<AuthenicateBloc>(
      create: (context) => authenicateBloc,
    ),
    BlocProvider<SearchBloc>(
      create: (context) => searchBloc,
    ),
    BlocProvider<HotelRestaurantBloc>(
      create: (context) => hotelRestaurantBloc,
    ),
    BlocProvider<NewsBloc>(
      create: (context) => newsBloc,
    ),
    BlocProvider<FestivalBloc>(
      create: (context) => festivalBloc,
    ),
    BlocProvider<ExperienceBloc>(
      create: (context) => experienceBloc,
    ),
    BlocProvider<TripPlanBloc>(
      create: (context) => tripPlanBloc,
    ),
    BlocProvider<TourBloc>(
      create: (context) => tourBloc,
    ),
    BlocProvider<TourGuideBloc>(
      create: (context) => tourGuideBloc,
    ),
    BlocProvider<BookingBloc>(
      create: (context) => bookingBloc,
    ),
    BlocProvider<WorkshopBloc>(
      create: (context) => workshopBloc,
    ),
    BlocProvider<UserBloc>(
      create: (context) => userBloc,
    ),
  ];

  void initial() {
    final token = UserLocal().getAccessToken;
    print('AccessToken tại AppBloc.initial: $token');

    authenicateBloc.add(OnCheckAccountEvent());

    if (token.isNotEmpty) {
      initialLoggedin();
    }

    homeBloc.add(GetLocationTypeEvent());
    homeBloc.add(GetAllLocationEvent());
    homeBloc.add(GetEventHomeEvent());
    newsBloc.add(GetAllNewsEvent());
    festivalBloc.add(GetAllFestivalEvent());
    experienceBloc.add(GetAllExperienceEvent());
  }

  void initialLoggedin() {
    homeBloc.add(GetLocationFavoriteEvent());
    authenicateBloc.add(OnCheckAccountEvent());
  }

  void cleanData() {
    searchBloc.add(CleanSearchEvent());
    newsBloc.add(CleanNewsEvent());
  }

  void dispose() {
    mainBloc.close();
    homeBloc.close();
    authenicateBloc.close();
    searchBloc.close();
    hotelRestaurantBloc.close();
    newsBloc.close();
    festivalBloc.close();
    experienceBloc.close();
    tripPlanBloc.close();
    tourBloc.close();
    tourGuideBloc.close();
    bookingBloc.close();
    workshopBloc.close();
    userBloc.close();
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}

import 'package:flutter/material.dart';
import 'package:travelogue_mobile/model/args/reviews_screen_args.dart';
import 'package:travelogue_mobile/model/craft_village_model.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/experience_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/review_test_model.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/representation/auth/screens/forgot_password_screen.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';
import 'package:travelogue_mobile/representation/event/screens/event_detail.dart';
import 'package:travelogue_mobile/representation/event/screens/event_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/home_screen.dart';
import 'package:travelogue_mobile/representation/home/widgets/reviews_screen.dart';
import 'package:travelogue_mobile/representation/hotel/screens/hotel_detail_screen.dart';

import 'package:travelogue_mobile/representation/intro/screens/intro_screen.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';
import 'package:travelogue_mobile/representation/news/screens/news_screen.dart';
import 'package:travelogue_mobile/representation/restaurent/screens/restaurent_detail_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/search_screen.dart';
import 'package:travelogue_mobile/representation/intro/screens/splash_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/contact_support_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/edit_profile_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/faq_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/location_favorite_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/new_password_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/otp_vertification_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/privacy_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/support_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tay_ninh_predictor_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/travel_guide_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/user_profile_screen.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  EventDetailScreen.routeName: (context) => const EventDetailScreen(),
  EventScreen.routeName: (context) => const EventScreen(),
  PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(
        place: ModalRoute.of(context)!.settings.arguments as LocationModel,
      ),
  HotelDetailScreen.routeName: (context) => const HotelDetailScreen(),
  RestaurantDetailScreen.routeName: (context) => const RestaurantDetailScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  UserProfileScreen.routeName: (context) => const UserProfileScreen(),
  FestivalScreen.routeName: (context) => const FestivalScreen(),
  FestivalDetailScreen.routeName: (context) {
    final festival = ModalRoute.of(context)!.settings.arguments as EventModel;
    return FestivalDetailScreen(festival: festival);
  },
  ExperienceScreen.routeName: (context) => const ExperienceScreen(),
  ExperienceDetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as ExperienceModel;
    return ExperienceDetailScreen(experience: args);
  },
  PrivacyScreen.routeName: (context) => const PrivacyScreen(),
  SupportScreen.routeName: (context) => const SupportScreen(),
  NewsScreen.routeName: (context) => const NewsScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  ContactSupportScreen.routeName: (context) => const ContactSupportScreen(),
  FaqScreen.routeName: (ctx) => const FaqScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  OtpVerificationScreen.routeName: (_) => const OtpVerificationScreen(),
  NewPasswordScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return NewPasswordScreen(
      otp: args,
    );
  },
  TravelGuideScreen.routeName: (_) => const TravelGuideScreen(),
  TayNinhPredictorScreen.routeName: (_) => const TayNinhPredictorScreen(),
  VietMapLocationScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as LatLng;
    return VietMapLocationScreen(destination: args);
  },
  FavoriteLocationScreen.routeName: (_) => const FavoriteLocationScreen(),
  ReviewsScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ReviewsScreenArgs<ReviewTestModel>;
    return ReviewsScreen<ReviewTestModel>(
      reviews: args.reviews,
      averageRating: args.averageRating,
    );
  },
  CraftVillageDetailScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CraftVillageModel;
    return CraftVillageDetailScreen();
  },
  MyTripPlansScreen.routeName: (_) => const MyTripPlansScreen(),
  TripDetailScreen.routeName: (context) {
    final trip = ModalRoute.of(context)!.settings.arguments as TripPlan;
    return TripDetailScreen(trip: trip);
  },
};

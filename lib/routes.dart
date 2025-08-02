import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/args/reviews_screen_args.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/experience_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/review_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/auth/screens/forgot_password_screen.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/my_booking_screen.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';
import 'package:travelogue_mobile/representation/event/screens/event_detail.dart';
import 'package:travelogue_mobile/representation/event/screens/event_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/home_screen.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/hotel/screens/hotel_detail_screen.dart';
import 'package:travelogue_mobile/representation/intro/screens/intro_screen.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';
import 'package:travelogue_mobile/representation/news/screens/news_screen.dart';
import 'package:travelogue_mobile/representation/restaurent/screens/restaurent_detail_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/search_screen.dart';
import 'package:travelogue_mobile/representation/intro/screens/splash_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_schedule_calender_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_team_selector_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_type_selector.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_booking_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_qr_payment_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/create_trip_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_place_for_day_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_tour_guide_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_trip_day_screen.dart';
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
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (_) => const SplashScreen(),
  IntroScreen.routeName: (_) => const IntroScreen(),
  MainScreen.routeName: (_) => const MainScreen(),
  HomeScreen.routeName: (_) => const HomeScreen(),
  SearchScreen.routeName: (_) => const SearchScreen(),
  EventDetailScreen.routeName: (_) => const EventDetailScreen(),
  EventScreen.routeName: (_) => const EventScreen(),
  PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(
        place: ModalRoute.of(context)!.settings.arguments as LocationModel,
      ),
  HotelDetailScreen.routeName: (_) => const HotelDetailScreen(),
  RestaurantDetailScreen.routeName: (_) => const RestaurantDetailScreen(),
  LoginScreen.routeName: (_) => const LoginScreen(),
  UserProfileScreen.routeName: (_) => const UserProfileScreen(),
  FestivalScreen.routeName: (_) => const FestivalScreen(),
  FestivalDetailScreen.routeName: (context) {
    final festival = ModalRoute.of(context)!.settings.arguments as EventModel;
    return FestivalDetailScreen(festival: festival);
  },
  ExperienceScreen.routeName: (_) => const ExperienceScreen(),
  ExperienceDetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as ExperienceModel;
    return ExperienceDetailScreen(experience: args);
  },
  PrivacyScreen.routeName: (_) => const PrivacyScreen(),
  SupportScreen.routeName: (_) => const SupportScreen(),
  NewsScreen.routeName: (_) => const NewsScreen(),
  ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
  ContactSupportScreen.routeName: (_) => const ContactSupportScreen(),
  FaqScreen.routeName: (_) => const FaqScreen(),
  EditProfileScreen.routeName: (_) => const EditProfileScreen(),
  OtpVerificationScreen.routeName: (_) => const OtpVerificationScreen(),
  NewPasswordScreen.routeName: (context) {
    final otp = ModalRoute.of(context)!.settings.arguments as String;
    return NewPasswordScreen(otp: otp);
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
  CraftVillageDetailScreen.routeName: (_) => const CraftVillageDetailScreen(),
  MyTripPlansScreen.routeName: (_) => const MyTripPlansScreen(),
  TripDetailScreen.routeName: (_) => const TripDetailScreen(),
  CreateTripScreen.routeName: (_) => const CreateTripScreen(),
  SelectTripDayScreen.routeName: (_) => const SelectTripDayScreen(),
  SelectPlaceForDayScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SelectPlaceForDayScreen(trip: args['trip'], day: args['day']);
  },
  SelectTourGuideScreen.routeName: (_) => const SelectTourGuideScreen(),

  TourDetailScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return TourDetailScreen(
      tour: args['tour'] as TourModel,
      image: args['image'] as String? ?? AssetHelper.img_default,
      departureDate: args['departureDate'] as DateTime?,
      isBooked: args['isBooked'] ?? false,
      readOnly: args['readOnly'] ?? false,
    );
  },

  TourTypeSelector.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tourJson = args['tour'] as Map<String, dynamic>;
    final tour = TourModel.fromJson(tourJson);
    return TourTypeSelector(tour: tour);
  },

  TourScheduleCalendarScreen.routeName: (_) =>
      const TourScheduleCalendarScreen(),

  TourQrPaymentScreen.routeName: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text('Thiếu dữ liệu thanh toán')),
      );
    }

    try {
      return TourQrPaymentScreen(
        tour: args['tour'] is TourModel
            ? args['tour']
            : TourModel.fromJson(args['tour']),
        schedule: args['schedule'] is TourScheduleModel
            ? args['schedule']
            : TourScheduleModel.fromJson(args['schedule']),
        departureDate: args['departureDate'] is DateTime
            ? args['departureDate']
            : DateTime.parse(args['departureDate']),
        adults: args['adults'] as int,
        children: args['children'] as int,
        totalPrice: args['totalPrice'] as double,
        startTime: args['startTime'] is DateTime
            ? args['startTime']
            : DateTime.parse(args['startTime']),
        // checkoutUrl: args['checkoutUrl'] as String?,
      );
    } catch (e) {
      return Scaffold(
        body: Center(child: Text('Lỗi dữ liệu thanh toán: ${e.toString()}')),
      );
    }
  },

  TourScreen.routeName: (_) => const TourScreen(),

  TourPaymentConfirmationScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return TourPaymentConfirmationScreen(
      tour: args['tour'],
      schedule: args['schedule'],
      media: args['media'],
      departureDate: args['departureDate'],
      adults: args['adults'],
      children: args['children'],
      bookingId: args['bookingId'],
    );
  },

  TourTeamSelectorScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return TourTeamSelectorScreen(
      tour: args['tour'],
      schedule: args['schedule'],
      media: args['media'],
    );
  },

  // OrderScreen.routeName: (context) {
  //   final args =
  //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //   return OrderScreen(orders: args['orders'], isBooked: args['isBooked']);
  // },

  WorkshopDetailScreen.routeName: (context) => WorkshopDetailScreen(
        workshop:
            ModalRoute.of(context)!.settings.arguments as WorkshopTestModel,
      ),

  GuideBookingConfirmationScreen.routeName: (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return GuideBookingConfirmationScreen(
    guide: args['guide'],
    startDate: args['startDate'],
    endDate: args['endDate'],
    adults: args['adults'],
    children: args['children'],
  );
},

TourGuideQrPaymentScreen.routeName: (context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args == null || args is! Map<String, dynamic>) {
    return const Scaffold(
      body: Center(child: Text('Thiếu dữ liệu thanh toán hướng dẫn viên')),
    );
  }

  try {
    return TourGuideQrPaymentScreen(
      guide: args['guide'],
      startDate: args['startDate'],
      endDate: args['endDate'],
      adults: args['adults'],
      children: args['children'],
      startTime: args['startTime'],
      paymentUrl: args['paymentUrl'],
    );
  } catch (e) {
    return Scaffold(
      body: Center(child: Text('Lỗi dữ liệu: ${e.toString()}')),
    );
  }
},

MyBookingScreen.routeName: (context) {
  final args = ModalRoute.of(context)!.settings.arguments
      as List<BookingModel>;
  return MyBookingScreen(bookings: args);
},

};

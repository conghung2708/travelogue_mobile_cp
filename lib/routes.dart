import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/args/reviews_screen_args.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/model/review_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/auth/screens/forgot_password_screen.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/booking_detail_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/my_booking_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/refund_detail_screen.dart';
import 'package:travelogue_mobile/representation/chatbox/screens/chat_screen.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';
import 'package:travelogue_mobile/representation/event/screens/event_detail.dart';
import 'package:travelogue_mobile/representation/event/screens/event_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/home_screen.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/intro/screens/intro_screen.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';
import 'package:travelogue_mobile/representation/news/screens/news_screen.dart';
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
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_detail_screen.dart';
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
import 'package:travelogue_mobile/representation/user/screens/my_reports_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/new_password_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/otp_vertification_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/privacy_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/support_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tay_ninh_predictor_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tour_guide_request_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/travel_guide_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/user_profile_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/withdraw_request_screen.dart';
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
  LoginScreen.routeName: (_) => const LoginScreen(),
  UserProfileScreen.routeName: (_) => const UserProfileScreen(),
  FestivalScreen.routeName: (_) => const FestivalScreen(),

  FestivalDetailScreen.routeName: (context) {
    final festival = ModalRoute.of(context)!.settings.arguments as NewsModel;
    return Provider<NewsModel>.value(
      value: festival,
      child: const FestivalDetailScreen(),
    );
  },

  ExperienceScreen.routeName: (_) => const ExperienceScreen(),

  ExperienceDetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as NewsModel;
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
  SelectPlaceForDayScreen.routeName: (_) => const SelectPlaceForDayScreen(),
  SelectTourGuideScreen.routeName: (_) => const SelectTourGuideScreen(),

  TourDetailScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return TourDetailScreen(
      tour: args['tour'] as TourModel,
      image: args['image'] as String? ?? AssetHelper.img_default,
      startTime: args['startTime'] as DateTime?,
      isBooked: args['isBooked'] ?? false,
      readOnly: args['readOnly'] ?? false,
    );
  },

  TourTypeSelector.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tourArg = args['tour'];
    final tour = (tourArg is TourModel)
        ? tourArg
        : TourModel.fromJson(tourArg as Map<String, dynamic>);
    return TourTypeSelector(tour: tour);
  },
  TourScheduleCalendarScreen.routeName: (_) =>
      const TourScheduleCalendarScreen(),

  TourQrPaymentScreen.routeName: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! Map) {
      return const Scaffold(
        body: Center(child: Text('Thiếu dữ liệu thanh toán')),
      );
    }

    try {
      // tour
      final tour = args['tour'] is TourModel
          ? args['tour'] as TourModel
          : TourModel.fromJson(args['tour']);

      // schedule
      final schedule = args['schedule'] is TourScheduleModel
          ? args['schedule'] as TourScheduleModel
          : TourScheduleModel.fromJson(args['schedule']);

      // numbers: chấp nhận int/double/string
      int toInt(dynamic v, {int fallback = 0}) {
        if (v is int) {
          return v;
        }
        if (v is num) {
          return v.toInt();
        }
        return int.tryParse(v?.toString() ?? '') ?? fallback;
      }

      double toDouble(dynamic v, {double fallback = 0.0}) {
        if (v is double) {
          return v;
        }
        if (v is num) {
          return v.toDouble();
        }
        return double.tryParse(v?.toString() ?? '') ?? fallback;
      }

      final adults = toInt(args['adults'], fallback: 1);
      final children = toInt(args['children'], fallback: 0);
      final totalPrice = toDouble(args['totalPrice'], fallback: 0);

      final startTime = args['startTime'] is DateTime
          ? args['startTime'] as DateTime
          : (DateTime.tryParse(args['startTime']?.toString() ?? '') ??
              DateTime.now());

      final String? bookingId =
          (args['bookingId']?.toString().isNotEmpty == true)
              ? args['bookingId'].toString()
              : null;

      final String? checkoutUrl = args['checkoutUrl']?.toString();
      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('Thiếu checkoutUrl để thanh toán')),
        );
      }

      return TourQrPaymentScreen(
        tour: tour,
        schedule: schedule,
        adults: adults,
        children: children,
        totalPrice: totalPrice,
        startTime: startTime,
        bookingId: bookingId,
        checkoutUrl: checkoutUrl,
      );
    } catch (e) {
      return Scaffold(
        body: Center(child: Text('Lỗi dữ liệu thanh toán: $e')),
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
      startTime: args['startTime'],
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

  WorkshopDetailScreen.routeName: (context) {
    final workshopId = ModalRoute.of(context)!.settings.arguments as String;
    return WorkshopDetailScreen(workshopId: workshopId);
  },

  GuideBookingConfirmationScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return GuideBookingConfirmationScreen(
      tripPlanId: args['tripPlanId'] as String,
      guide: args['guide'] as TourGuideModel,
      startDate: args['startDate'] as DateTime,
      endDate: args['endDate'] as DateTime,
      adults: (args['adults'] as int?) ?? 1,
      children: (args['children'] as int?) ?? 0,
    );
  },
  TourGuideQrPaymentScreen.routeName: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text('Thiếu dữ liệu thanh toán hướng dẫn viên')),
      );
    }

    try {
      final guide = args['guide'] as TourGuideModel;
      final startDate = args['startDate'] as DateTime;
      final endDate = args['endDate'] as DateTime;
      final adults = args['adults'] as int;
      final children = args['children'] as int;
      final startTime = args['startTime'] as DateTime;
      final paymentUrl = args['paymentUrl'] as String;

      final tripPlanId = args['tripPlanId'] as String;

      return TourGuideQrPaymentScreen(
        guide: guide,
        startDate: startDate,
        endDate: endDate,
        adults: adults,
        children: children,
        startTime: startTime,
        paymentUrl: paymentUrl,
        tripPlanId: tripPlanId,
      );
    } catch (e) {
      return Scaffold(
        body: Center(child: Text('Lỗi dữ liệu: $e')),
      );
    }
  },

  MyBookingScreen.routeName: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as List<BookingModel>;
    return MyBookingScreen(bookings: args);
  },

  TourGuideRequestScreen.routeName: (_) => const TourGuideRequestScreen(),

  TourGuideDetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as TourGuideModel;
    return TourGuideDetailScreen(guide: args);
  },

  // BookingDetailScreen.routeName: (context) {
  //   final booking = ModalRoute.of(context)!.settings.arguments as BookingModel;
  //   return BookingDetailScreen(booking: booking);
  // },

  BookingDetailScreen.routeName: (_) => const BookingDetailScreen(),
  WithdrawRequestScreen.routeName: (_) => const WithdrawRequestScreen(),

  MyReportsScreen.routeName: (_) => const MyReportsScreen(),

  RefundDetailScreen.routeName: (_) => const RefundDetailScreen(),

    ChatScreen.routeName: (_) => const ChatScreen(),
};

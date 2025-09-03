import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_bloc.dart';
import 'package:travelogue_mobile/core/blocs/bank_lookup/bank_lookup_cubit.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/festival/festival_bloc.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/blocs/location/location_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_bloc.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_bloc.dart';
import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';
import 'package:travelogue_mobile/core/blocs/notification/notification_bloc.dart';
import 'package:travelogue_mobile/core/blocs/notification/notification_event.dart';
import 'package:travelogue_mobile/core/blocs/report/report_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_bloc.dart';
import 'package:travelogue_mobile/core/blocs/search/search_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_bloc.dart';
import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/core/blocs/user/user_bloc.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/core/repository/bank_account_repository.dart';
import 'package:travelogue_mobile/core/repository/bank_lookup_repository.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/core/repository/location_repository.dart';
import 'package:travelogue_mobile/core/repository/nearest_data_repository.dart';
import 'package:travelogue_mobile/core/repository/notification_repository.dart';
import 'package:travelogue_mobile/core/repository/refund_request_repository.dart';
import 'package:travelogue_mobile/core/repository/report_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/core/repository/user_repository.dart';
import 'package:travelogue_mobile/core/repository/wallet_repository.dart';
import 'package:travelogue_mobile/core/repository/workshop_repository.dart';
import 'package:travelogue_mobile/core/services/notification_hub_service.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class AppBloc {
  static final MainBloc mainBloc = MainBloc();
  static final HomeBloc homeBloc = HomeBloc();
  static final AuthenicateBloc authenicateBloc = AuthenicateBloc();
  static final SearchBloc searchBloc = SearchBloc();
  static final NewsBloc newsBloc = NewsBloc();
  static final FestivalBloc festivalBloc = FestivalBloc();
  static final TripPlanBloc tripPlanBloc = TripPlanBloc();
  static final TourBloc tourBloc = TourBloc();
  static final TourGuideBloc tourGuideBloc =
      TourGuideBloc(TourGuideRepository());
  static final BookingBloc bookingBloc = BookingBloc(BookingRepository());
  static final WorkshopBloc workshopBloc = WorkshopBloc(WorkshopRepository());
  static final UserBloc userBloc = UserBloc(UserRepository());
  static final NearestDataBloc nearestDataBloc =
      NearestDataBloc(repository: NearestDataRepository());
  static final MediaUploadBloc mediaUploadBloc = MediaUploadBloc();
  static final RefundBloc refundBloc = RefundBloc(RefundRepository());
  static final BankAccountBloc bankAccountBloc =
      BankAccountBloc(BankAccountRepository());
  static final BankLookupCubit bankLookupCubit =
      BankLookupCubit(BankLookupRepository());
  static final WalletBloc walletBloc =
      WalletBloc(walletRepository: WalletRepository());

static final LocationBloc locationBloc =
    LocationBloc(LocationRepository()); 

  static final ReportBloc reportBloc = ReportBloc(ReportRepository());

// singletons
  static final NotificationBloc notificationBloc =
      NotificationBloc(NotificationRepository(), NotificationHubService());

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
    BlocProvider<NewsBloc>(
      create: (context) => newsBloc,
    ),
    BlocProvider<FestivalBloc>(
      create: (context) => festivalBloc,
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
    BlocProvider<NearestDataBloc>(create: (context) => nearestDataBloc),
    BlocProvider<MediaBloc>.value(value: mediaUploadBloc),
    BlocProvider<RefundBloc>.value(
      value: refundBloc,
    ),
    BlocProvider<BankAccountBloc>.value(value: bankAccountBloc),
    BlocProvider<BankLookupCubit>.value(value: bankLookupCubit),
    BlocProvider<WalletBloc>.value(value: walletBloc),
    BlocProvider<ReportBloc>(
      create: (context) => reportBloc,
    ),
    BlocProvider<NotificationBloc>(create: (context) => notificationBloc),
    BlocProvider<LocationBloc>(
  create: (context) => locationBloc,
), 
  ];

  void initial() {
    final token = UserLocal().getAccessToken;
    final userId = UserLocal().getUserId;
    print('🔑 AccessToken tại AppBloc.initial: $token');
    print('👤 UserId tại AppBloc.initial: $userId');

    authenicateBloc.add(OnCheckAccountEvent());

    if (token.isNotEmpty) {
      initialLoggedin();
      if (userId.isNotEmpty) {
        print('▶️ Gửi event ConnectNotificationHub');
        notificationBloc.add(
          ConnectNotificationHub(
            hubUrl: 'https://travelogue.homes/notificationHub',
            accessToken: token,
            userId: userId,
          ),
        );
      } else {
        print(
            '⚠️ Không có userId, bỏ qua connect SignalR và load notifications.');
      }
    } else {
      print('⚠️ Không có token, user chưa login.');
    }

    homeBloc.add(const GetLocationTypeEvent());
    homeBloc.add(const GetAllLocationEvent());
    homeBloc.add(const GetEventHomeEvent());
    newsBloc.add(GetAllNewsEvent());
    festivalBloc.add(GetAllFestivalEvent());

    print('✅ AppBloc.initial hoàn tất.');
  }

  void initialLoggedin() {
    homeBloc.add(const GetLocationFavoriteEvent());
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
    newsBloc.close();
    festivalBloc.close();

    tripPlanBloc.close();
    tourBloc.close();
    tourGuideBloc.close();
    bookingBloc.close();
    workshopBloc.close();
    userBloc.close();
    nearestDataBloc.close();
    mediaUploadBloc.close();
    refundBloc.close();
    bankAccountBloc.close();
    bankLookupCubit.close();
    walletBloc.close();
    reportBloc.close();
locationBloc.close(); 
    notificationBloc.close();
  }

  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/app_sync/app_sync.dart';

import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';

import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_event.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_state.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/core/repository/refund_request_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/core/repository/trip_plan_repository.dart';
import 'package:travelogue_mobile/core/repository/workshop_repository.dart';

import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/booking/review_booking_request.dart';
import 'package:travelogue_mobile/model/refund_request/refund_create_model.dart';
import 'package:travelogue_mobile/model/refund_request/refund_request_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

import 'package:travelogue_mobile/representation/booking/screens/booking_detail_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/refund_list_screen.dart';
import 'package:travelogue_mobile/representation/booking/widgets/review_pill_button.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_detail_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';

extension BookingX on BookingModel {
  int typeCode(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  bool get wasPaidOnline => (paymentLinkId ?? '').isNotEmpty;

  int get tab => tabCode;

  String get statusLabelUi {
    switch (tab) {
      case 0:
        return 'Hết hạn';
      case 1:
        return 'Đã thanh toán';
      case 2:
        return 'Đã hoàn thành';
      case 3:
        return 'Đã huỷ';
      default:
        return 'Khác';
    }
  }
}

class _CardActions {
  final bool showManage;
  final bool showReview;
  final bool showReviewedBadge;
  final bool showRefundSentBadge;
  final bool showRefundMenu;

  const _CardActions({
    required this.showManage,
    required this.showReview,
    required this.showReviewedBadge,
    required this.showRefundSentBadge,
    this.showRefundMenu = false,
  });
}

class MyBookingScreen extends StatefulWidget {
  static const String routeName = '/my-bookings';
  final List<BookingModel> bookings;

  const MyBookingScreen({super.key, required this.bookings});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

enum SortOrder { newest, oldest }

class DisplayBookingArgs {
  final BookingModel booking;
  final String displayTitle;
  final String? displayImageUrl;
  const DisplayBookingArgs({
    required this.booking,
    required this.displayTitle,
    this.displayImageUrl,
  });
}

class _StatusStyle {
  final Color fg;
  final Color bg;
  final IconData icon;
  const _StatusStyle(this.fg, this.bg, this.icon);
}

const int _uiRefundSent = 99;

const _statusStyles = <int, _StatusStyle>{
  0: _StatusStyle(
      Color(0xFFB54708), Color(0xFFFFF4E5), Icons.timer_off_rounded),
  1: _StatusStyle(Color(0xFF027A48), Color(0xFFE9F7EF), Icons.verified_rounded),
  2: _StatusStyle(
      Color(0xFF05603A), Color(0xFFE6F4EA), Icons.check_circle_rounded),
  3: _StatusStyle(Color(0xFFB42318), Color(0xFFFDECEC), Icons.cancel_rounded),
  _uiRefundSent: _StatusStyle(
    Color(0xFF2563EB),
    Color(0xFFEFF6FF),
    Icons.send_rounded,
  ),
};

class _MyBookingScreenState extends State<MyBookingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int selectedStatusTab = 0;
  final List<String> statusTabs = [
    "Hết hạn",
    "Đã thanh toán",
    "Đã hoàn thành",
    "Đã hủy",
  ];

  final Set<String> _refundRequestedIdsBE = <String>{};
  void _markRefundRequested(String bookingId) {
    _refundRequestedIdsBE.add(bookingId);
    if (mounted) setState(() {});
  }

  final Map<String, int> _reviewed = {};

  final Set<String> _reviewedIdsBE = <String>{};

  bool _metaLoaded = false;
  late List<BookingModel> _items;

  int selectedType = 0;
  SortOrder selectedSort = SortOrder.newest;
  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  static const int _REFUND_WINDOW_HOURS = 24;

  final Map<String, String> _tripPlanTitleById = {};
  final Map<String, String> _tripPlanImgById = {};

  final Map<String, String> _guideNameById = {};
  final Map<String, String> _guideAvatarById = {};

  final Map<String, String> _workshopNameById = {};
  final Map<String, String> _workshopImgById = {};

  Widget _buildTableHeader() {
    final style = Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Colors.grey[700],
          fontWeight: FontWeight.w700,
        );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
      color: Colors.grey.shade100,
      child: Row(children: [
        Expanded(flex: 4, child: Text('DỊCH VỤ', style: style)),
        Expanded(flex: 3, child: Text('GIÁ', style: style)),
        Expanded(flex: 4, child: Text('TRẠNG THÁI', style: style)),
        const SizedBox(width: 8),
      ]),
    );
  }

  Widget _buildOrderRow({
    required BookingModel booking,
    required String title,
    required String priceText,
    required String orderDateText,
    required String statusText,
    required int statusCode,
    required VoidCallback onTap,
    required bool showManage,
    required bool showReview,
    required bool showReviewedBadge,
    required bool showRefundSentBadge,
    required bool showRefundMenu,
    VoidCallback? onManage,
    VoidCallback? onReview,
    VoidCallback? onRefund,
  }) {
    final st = _statusStyles[statusCode] ??
        const _StatusStyle(Colors.teal, Color(0xFFE0F2F1), Icons.info_rounded);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ColorPalette.primaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _typeText(_bookingTypeOf(booking)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Text(
                        orderDateText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  priceText,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.green[700],
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatusChip(
                  text: statusText,
                  fg: st.fg,
                  bg: st.bg,
                  icon: st.icon,
                ),
              ),
            ),
            _RowActions(
              showManage: showManage,
              showReview: showReview,
              showReviewedBadge: showReviewedBadge,
              showRefundSentBadge: showRefundSentBadge,
              showRefundMenu: showRefundMenu,
              onManage: onManage,
              onReview: onReview,
              onRefund: onRefund,
            ),
          ],
        ),
      ),
    );
  }

  bool _withinRefundWindow(BookingModel b) {
    final bookingTime = _safeBookingDate(b);
    return DateTime.now().difference(bookingTime).inHours <
        _REFUND_WINDOW_HOURS;
  }

  bool _canCancel(BookingModel b) => b.isConfirmed && _withinRefundWindow(b);

  bool _canRefund(BookingModel b) {
    final wasPaidOnline =
        b.paymentLinkId != null && b.paymentLinkId!.isNotEmpty;
    return b.isCancelledPaid && wasPaidOnline;
  }

  _CardActions _actionsFor(BookingModel b) {
    final alreadyRefunded = _refundRequestedIdsBE.contains(b.id);
    final canCancel = _canCancel(b);
    final canRefund = _canRefund(b) && !alreadyRefunded;
    final canReview = _canReview(b);

    switch (b.tabCode) {
      case 0: // Hết hạn
        return const _CardActions(
          showManage: false,
          showReview: false,
          showReviewedBadge: false,
          showRefundSentBadge: false,
        );

      case 1:
        return _CardActions(
          showManage: (canCancel || canRefund),
          showReview: false,
          showReviewedBadge: false,
          showRefundSentBadge: alreadyRefunded,
          showRefundMenu: false,
        );

      case 2:
        return _CardActions(
          showManage: false,
          showReview: canReview,
          showReviewedBadge: false,
          showRefundSentBadge: false,
          showRefundMenu: false,
        );

      case 3:
        return _CardActions(
          showManage: canRefund,
          showReview: false,
          showReviewedBadge: false,
          showRefundSentBadge: alreadyRefunded,
          showRefundMenu: canRefund,
        );

      default:
        return const _CardActions(
          showManage: false,
          showReview: false,
          showReviewedBadge: false,
          showRefundSentBadge: false,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _items = List<BookingModel>.from(widget.bookings);
    _warmDisplayMeta();
    context.read<BookingBloc>().add(const GetMyReviewsEvent());
    _loadExistingRefunds();
  }

  Future<void> _loadExistingRefunds() async {
    try {
      final refunds = await RefundRepository().getUserRefundRequests();

      final latestByBooking = <String, RefundRequestModel>{};
      for (final r in refunds) {
        final old = latestByBooking[r.bookingId];
        if (old == null || r.lastUpdatedTime.isAfter(old.lastUpdatedTime)) {
          latestByBooking[r.bookingId] = r;
        }
      }

      _refundRequestedIdsBE
        ..clear()
        ..addAll(
          latestByBooking.entries.map((e) => e.key),
        );
      if (mounted) setState(() {});
    } catch (_) {}
  }

  int _pendingRefundCount() => _refundRequestedIdsBE.length;

  Future<void> _refreshAll() async {
    await Future.wait([
      _loadExistingRefunds(),
      Future(() => context.read<BookingBloc>().add(const GetMyReviewsEvent())),
      _warmDisplayMeta(),
    ]);
    if (mounted) setState(() {});
  }

  int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  int _bookingTypeOf(BookingModel b) => _asInt(b.bookingType, fallback: -1);
  bool _isPersonalGuide(BookingModel b) =>
      _bookingTypeOf(b) == 3 && b.tripPlanId != null;
  bool _isPlainGuide(BookingModel b) =>
      _bookingTypeOf(b) == 3 && b.tripPlanId == null;

  bool _canReview(BookingModel b) {
    final reviewedByBE = _reviewedIdsBE.contains(b.id);
    final reviewedLocally = _reviewed.containsKey(b.id);
    return b.isCompleted && !reviewedByBE && !reviewedLocally;
  }

  void _markReviewed(BookingModel b, int rating) {
    _reviewed[b.id] = rating;
    _reviewedIdsBE.add(b.id);
    if (mounted) setState(() {});
  }

  Future<void> _openServiceDetail(BookingModel b) async {
    final bt = _bookingTypeOf(b);

    if (bt == 1 && b.tourId != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final TourModel? tour = await TourRepository().getTourById(b.tourId!);
      if (mounted) Navigator.pop(context);
      if (tour != null) {
        final idx = _items.indexWhere((bk) => bk.id == b.id);
        if (idx != -1) _items[idx] = _items[idx].copyWith(tour: tour);
        if (mounted) setState(() {});
        final coverImage = tour.medias.isNotEmpty
            ? (tour.medias.first.mediaUrl ?? AssetHelper.img_tay_ninh_login)
            : AssetHelper.img_tay_ninh_login;
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourDetailScreen(
              tour: tour,
              image: coverImage,
              startTime: b.bookingDate,
              isBooked: true,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không tìm thấy thông tin tour.")),
          );
        }
      }
      return;
    }

    if (bt == 3 && _isPersonalGuide(b) && b.tripPlanId != null) {
      Navigator.pushNamed(
        context,
        TripDetailScreen.routeName,
        arguments: b.tripPlanId.toString(),
      );
      return;
    }

    if (bt == 3 && b.tourGuideId != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final TourGuideModel? guide =
          await TourGuideRepository().getTourGuideById(b.tourGuideId!);
      if (mounted) Navigator.pop(context);
      if (guide != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TourGuideDetailScreen(guide: guide)),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Không tìm thấy thông tin hướng dẫn viên.")),
          );
        }
      }
      return;
    }

    final args = DisplayBookingArgs(
      booking: b,
      displayTitle: _displayTitle(b),
      displayImageUrl: _displayImageUrl(b),
    );
    Navigator.pushNamed(context, BookingDetailScreen.routeName,
        arguments: args);
  }

  Future<void> _showPaidChoiceSheet(BookingModel b) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2)),
              ),
              ListTile(
                leading: const Icon(Icons.explore_rounded),
                title: const Text('Xem chi tiết lịch trình',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(ctx);
                  _openServiceDetail(b);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_rounded),
                title: const Text('Xem chi tiết đơn hàng',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(ctx);
                  final args = DisplayBookingArgs(
                    booking: b,
                    displayTitle: _displayTitle(b),
                    displayImageUrl: _displayImageUrl(b),
                  );
                  Navigator.pushNamed(
                    context,
                    BookingDetailScreen.routeName,
                    arguments: args,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  DateTime _safeBookingDate(BookingModel b) {
    try {
      return b.bookingDate;
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  Future<void> _warmDisplayMeta() async {
    final tourIds = <String>{};
    final guideIds = <String>{};
    final tripPlanIds = <String>{};
    final workshopIds = <String>{};

    for (final b in _items) {
      final t = _bookingTypeOf(b);
      if (t == 1 && (b.tourId?.isNotEmpty ?? false) && b.tour == null) {
        tourIds.add(b.tourId!);
      } else if (t == 2 && (b.workshopId?.isNotEmpty ?? false)) {
        workshopIds.add(b.workshopId!);
      } else if (t == 3) {
        if (_isPersonalGuide(b) && (b.tripPlanId?.isNotEmpty ?? false)) {
          tripPlanIds.add(b.tripPlanId!);
        } else if (_isPlainGuide(b) && (b.tourGuideId?.isNotEmpty ?? false)) {
          guideIds.add(b.tourGuideId!);
        }
      }
    }

    await Future.wait([
      ...tourIds.map((id) async {
        final tour = await TourRepository().getTourById(id);
        if (tour != null) {
          for (int i = 0; i < _items.length; i++) {
            if (_items[i].tourId == id) {
              _items[i] = _items[i].copyWith(tour: tour);
            }
          }
        }
      }),
      ...workshopIds.map((id) async {
        final ws = await WorkshopRepository().getWorkshopDetail(workshopId: id);
        if (ws != null) {
          if ((ws.name ?? '').isNotEmpty) _workshopNameById[id] = ws.name!;
          final img =
              (ws.imageList?.isNotEmpty ?? false) ? ws.imageList!.first : null;
          if ((img ?? '').isNotEmpty) _workshopImgById[id] = img!;
        }
      }),
      ...tripPlanIds.map((id) async {
        final tp = await TripPlanRepository().getTripPlanDetail(id);
        if (tp.name.isNotEmpty) _tripPlanTitleById[id] = tp.name;
        final img = (tp.imageUrl ?? '').trim();
        if (img.isNotEmpty) _tripPlanImgById[id] = img;
      }),
      ...guideIds.map((id) async {
        final g = await TourGuideRepository().getTourGuideById(id);
        if ((g?.userName?.isNotEmpty ?? false))
          _guideNameById[id] = g!.userName!;
        final av = (g?.avatarUrl ?? '').trim();
        if (av.isNotEmpty) _guideAvatarById[id] = av;
      }),
    ]);

    _metaLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Quản lý đơn hàng",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        // centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Semantics(
              label: 'Lịch sử hoàn tiền',
              hint: 'Xem các yêu cầu hoàn tiền đã gửi',
              button: true,
              child: Tooltip(
                message: 'Xem lịch sử hoàn tiền',
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                      icon: Icon(Icons.receipt_long_rounded,
                          color: Colors.green[700]),
                      label: const Text(
                        'Hoàn tiền',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () async {
                        final bookingTitleLookup = {
                          for (final b in _items) b.id: _displayTitle(b)
                        };
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RefundListScreen(
                                bookingTitleLookup: bookingTitleLookup),
                          ),
                        );
                        await _refreshAll();
                      },
                    ),
                    if (_pendingRefundCount() > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${_pendingRefundCount()}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RefundBloc, RefundState>(
              listener: _onRefundStateChanged),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              if (state is ReviewBookingSubmitting) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                    const SnackBar(content: Text('Đang gửi đánh giá...')));
                AppSync.instance.refreshGuides = true;
              } else if (state is ReviewBookingSuccess) {
                Navigator.of(context, rootNavigator: true).maybePop();
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(SnackBar(
                    content: Text(state.message ?? 'Cảm ơn bạn đã đánh giá!')));
              } else if (state is MyReviewsLoaded) {
                _reviewedIdsBE
                  ..clear()
                  ..addAll(state.bookingIds);
                if (mounted) setState(() {});
              } else if (state is BookingFailure) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              _buildTypeFilterChips(),
              SizedBox(height: 1.5.h),
              _buildStatusTab(),
              SizedBox(height: 1.h),
              _buildSortControl(),
              SizedBox(height: 1.5.h),
              Expanded(child: _buildBookingList()),
            ],
          ),
        ),
      ),
    );
  }

  void _onRefundStateChanged(BuildContext context, RefundState state) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (state is RefundLoading) {
      messenger.showSnackBar(const SnackBar(
        content: Text('Đang gửi yêu cầu hoàn tiền...'),
        duration: Duration(milliseconds: 1200),
      ));
    } else if (state is RefundSuccess) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Gửi yêu cầu hoàn tiền thành công.')));
    } else if (state is RefundFailure) {
      messenger.showSnackBar(
          SnackBar(content: Text('Lỗi hoàn tiền: ${state.error}')));
    }
  }

  Widget _buildTypeFilterChips() {
    const items = [
      {'label': 'Tất cả', 'value': 0, 'icon': Icons.all_inbox_outlined},
      {'label': 'Tour', 'value': 1, 'icon': Icons.card_travel_outlined},
      {'label': 'Workshop', 'value': 2, 'icon': Icons.handyman_outlined},
      {'label': 'Hướng dẫn viên', 'value': 3, 'icon': Icons.badge_outlined},
      {'label': 'Chuyến đi cá nhân', 'value': 4, 'icon': Icons.hiking},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((e) {
          final value = e['value'] as int;
          final selected = selectedType == value;
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e['icon'] as IconData, size: 14.sp),
                  SizedBox(width: 1.w),
                  Text(e['label'] as String),
                ],
              ),
              selected: selected,
              onSelected: (_) => setState(() => selectedType = value),
              selectedColor: ColorPalette.primaryColor.withOpacity(0.9),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                    color: selected
                        ? ColorPalette.primaryColor
                        : Colors.grey.shade300),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusTab() {
    return Container(
      height: 5.5.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white),
      child: Row(
        children: List.generate(statusTabs.length, (index) {
          final isSelected = selectedStatusTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedStatusTab = index),
              child: Container(
                height: 5.5.h,
                alignment: Alignment.center,
                decoration: isSelected
                    ? BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius: BorderRadius.circular(30),
                      )
                    : null,
                child: Text(
                  statusTabs[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isSelected ? Colors.white : ColorPalette.subTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _sortLabel(SortOrder order) =>
      order == SortOrder.newest ? 'Gần đây nhất' : 'Lâu nhất';

  Widget _buildSortControl() {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<SortOrder>(
        onSelected: (val) => setState(() => selectedSort = val),
        offset: const Offset(0, 8),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        constraints: const BoxConstraints(minWidth: 200),
        itemBuilder: (context) => [
          CheckedPopupMenuItem(
              checked: selectedSort == SortOrder.newest,
              value: SortOrder.newest,
              child: const Text('Gần đây nhất')),
          CheckedPopupMenuItem(
              checked: selectedSort == SortOrder.oldest,
              value: SortOrder.oldest,
              child: const Text('Lâu nhất')),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.9.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 14.sp, color: Colors.grey[800]),
              SizedBox(width: 1.5.w),
              Text(
                _sortLabel(selectedSort),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5.sp,
                    color: Colors.black87),
              ),
              SizedBox(width: 1.w),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // bool _withinRefundWindow(BookingModel b) {
  //   final bookingTime = _safeBookingDate(b);
  //   return DateTime.now().difference(bookingTime).inHours <
  //       _REFUND_WINDOW_HOURS;
  // }

  // bool _canCancel(BookingModel b) => b.isConfirmed && _withinRefundWindow(b);

  // bool _canRefund(BookingModel b) {
  //   final wasPaidOnline =
  //       b.paymentLinkId != null && b.paymentLinkId!.isNotEmpty;
  //   return b.isCancelledPaid && wasPaidOnline;
  // }
  Widget _buildBookingList() {
    // Giữ nguyên filter + sort như bạn đang làm:
    final typeFiltered = _items.where((b) {
      if (selectedType == 0) return true;
      final bt = _bookingTypeOf(b);
      if (selectedType == 1) return bt == 1;
      if (selectedType == 2) return bt == 2;
      if (selectedType == 3) return _isPlainGuide(b);
      if (selectedType == 4) return _isPersonalGuide(b);
      return true;
    }).toList();

    final filtered = typeFiltered.where((b) {
      final code = b.tabCode;
      switch (selectedStatusTab) {
        case 0:
          return code == 0;
        case 1:
          return code == 1;
        case 2:
          return code == 2;
        case 3:
          return code == 3;
        default:
          return false;
      }
    }).toList();

    filtered.sort((a, b) {
      final da = _safeBookingDate(a);
      final db = _safeBookingDate(b);
      return selectedSort == SortOrder.newest
          ? db.compareTo(da)
          : da.compareTo(db);
    });

    if (filtered.isEmpty) return _buildEmptyState();

    return ListView.separated(
      itemCount: filtered.length + 1,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) return _buildTableHeader();

        final b = filtered[index - 1];
        final acts = _actionsFor(b);
        final title = _displayTitle(b);
        final hasRefund = _refundRequestedIdsBE.contains(b.id);

        final statusTextUi =
            (b.tabCode == 3 && hasRefund) ? 'Đã gửi' : b.statusTextUi;

        final uiStatusCode =
            (b.tabCode == 3 && hasRefund) ? _uiRefundSent : b.tabCode;

        final showRefundBadge = hasRefund ? false : acts.showRefundSentBadge;

        return _buildOrderRow(
          booking: b,
          title: title,
          priceText: currency.format((b.finalPrice)),
          orderDateText: DateFormat('dd/MM/yyyy').format(_safeBookingDate(b)),
          statusText: statusTextUi,
          statusCode: uiStatusCode,
          onTap: () async {
            if (b.isConfirmed) {
              await _showPaidChoiceSheet(b);
              return;
            }
            final args = DisplayBookingArgs(
              booking: b,
              displayTitle: _displayTitle(b),
              displayImageUrl: _displayImageUrl(b),
            );
            Navigator.pushNamed(context, BookingDetailScreen.routeName,
                arguments: args);
          },
          showManage: acts.showManage,
          showReview: acts.showReview,
          showReviewedBadge: acts.showReviewedBadge,
          showRefundSentBadge: showRefundBadge,
          showRefundMenu: acts.showRefundMenu,
          onManage: () => _showManageSheet(b),
          onReview: () => _showReviewSheet(context, b),
          onRefund: () => _showRefundSheet(context, b),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_rounded, size: 56, color: Colors.black26),
          const SizedBox(height: 8),
          const Text('Chưa có đơn nào',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _displayTitle(BookingModel b) {
    final bt = _bookingTypeOf(b);

    if (bt == 1) {
      return b.tour?.name ?? "Tour ...";
    }

    if (bt == 2) {
      final wid = b.workshopId;
      if (wid != null && wid.isNotEmpty) {
        return _workshopNameById[wid] ?? "Workshop";
      }
      return "Workshop";
    }

    if (bt == 3) {
      if (_isPersonalGuide(b)) {
        final tpid = b.tripPlanId;
        if (tpid != null && tpid.isNotEmpty) {
          return _tripPlanTitleById[tpid] ?? "Chuyến đi cá nhân";
        }
        return "Chuyến đi cá nhân";
      }

      final gid = b.tourGuideId;
      if (gid != null && gid.isNotEmpty) {
        return _guideNameById[gid] ?? "Hướng dẫn viên";
      }
      return "Hướng dẫn viên";
    }

    return b.bookingTypeText ?? _typeText(bt);
  }

  String? _displayImageUrl(BookingModel b) {
    final bt = _bookingTypeOf(b);

    if (bt == 1) {
      final medias = b.tour?.medias;
      if (medias != null && medias.isNotEmpty) {
        final url = (medias.first.mediaUrl ?? '').trim();
        if (url.isNotEmpty) return url;
      }
      return null;
    }

    if (bt == 2) {
      final wid = b.workshopId;
      if (wid != null && wid.isNotEmpty) {
        final url = (_workshopImgById[wid] ?? '').trim();
        if (url.isNotEmpty) return url;
      }
      return null;
    }

    if (bt == 3) {
      if (_isPersonalGuide(b)) {
        final tpid = b.tripPlanId;
        if (tpid != null && tpid.isNotEmpty) {
          final url = (_tripPlanImgById[tpid] ?? '').trim();
          if (url.isNotEmpty) return url;
        }
        return null;
      }

      final gid = b.tourGuideId;
      if (gid != null && gid.isNotEmpty) {
        final url = (_guideAvatarById[gid] ?? '').trim();
        if (url.isNotEmpty) return url;
      }
      return null;
    }

    return null;
  }

  String _typeText(int t) {
    switch (t) {
      case 1:
        return 'Tour';
      case 2:
        return 'Workshop';
      case 3:
        return 'Hướng dẫn viên';
      default:
        return 'Khác';
    }
  }

  Future<void> _confirmAndCancel(BuildContext context, BookingModel b) async {
    final allow = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: Gradients.defaultGradientBackground,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.help_outline_rounded,
                          color: Colors.white, size: 26),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Huỷ đơn?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      Text(
                        'Huỷ đơn sẽ chuyển trạng thái sang "Đã huỷ". '
                        'Bạn có thể yêu cầu hoàn tiền sau khi huỷ.',
                        style: TextStyle(fontSize: 14.5, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                const Divider(height: 1, color: ColorPalette.dividerColor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorPalette.primaryColor,
                            side: const BorderSide(
                                color: ColorPalette.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Không'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: Gradients.defaultGradientBackground,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: const Text(
                                'Huỷ đơn',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

    if (allow != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: ColorPalette.primaryColor),
      ),
    );

    final result = await BookingRepository().cancelBooking(b.id);
    if (Navigator.of(context).canPop()) Navigator.pop(context);

    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ??
              'Không thể hủy đơn đã hoàn tất hoặc đã hết hạn.'),
          backgroundColor: ColorPalette.secondColor,
        ),
      );
      return;
    }

    _markBookingCanceled(b);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã huỷ đơn thành công.'),
        backgroundColor: ColorPalette.primaryColor,
      ),
    );
  }

  void _markBookingCanceled(BookingModel b) {
    final idx = _items.indexWhere((x) => x.id == b.id);
    if (idx != -1) {
      final updated = _items[idx].copyWith(
        status: '3',
        statusText: 'Bị huỷ đã thanh toán',
        cancelledAt: DateTime.now(),
      );
      _items[idx] = updated;
      setState(() {});
    }
  }

  int _toIntAmount(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is num) return v.round();
    final digits = v.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _showRefundSheet(BuildContext context, BookingModel b) {
    final int amount = _toIntAmount(b.finalPrice);
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: BlocListener<RefundBloc, RefundState>(
            listenWhen: (prev, curr) =>
                curr is RefundLoading ||
                curr is RefundSuccess ||
                curr is RefundFailure,
            listener: (ctx2, state) {
              final messenger = ScaffoldMessenger.of(ctx2);
              if (state is RefundLoading) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(const SnackBar(
                    content: Text('Đang gửi yêu cầu hoàn tiền...')));
              } else if (state is RefundSuccess) {
                Navigator.of(ctx).pop();
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(const SnackBar(
                    content: Text('Gửi yêu cầu hoàn tiền thành công.')));

                _markRefundRequested(b.id);
              } else if (state is RefundFailure) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                    SnackBar(content: Text('Lỗi hoàn tiền: ${state.error}')));
              }
            },
            child: BlocBuilder<RefundBloc, RefundState>(
              builder: (ctx3, state) {
                final isLoading = state is RefundLoading;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.undo_rounded),
                        const SizedBox(width: 8),
                        Text('Yêu cầu hoàn tiền',
                            style: Theme.of(ctx)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 12),
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Số tiền (₫)',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                              .format(amount),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Lý do',
                          hintText: 'Mô tả ngắn gọn lý do',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(ctx).pop(),
                              child: const Text('Huỷ'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      final reason =
                                          reasonController.text.trim();
                                      if (reason.isEmpty) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Vui lòng nhập lý do.')),
                                        );
                                        return;
                                      }
                                      final model = RefundCreateModel(
                                        bookingId: b.id.toString(),
                                        requestDate:
                                            DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                                .format(DateTime.now()),
                                        reason: reason,
                                        refundAmount: amount,
                                      );
                                      ctx
                                          .read<RefundBloc>()
                                          .add(SendRefundRequestEvent(model));
                                    },
                              icon: isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Icon(Icons.send_rounded),
                              label: Text(
                                  isLoading ? 'Đang gửi...' : 'Gửi yêu cầu'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showManageSheet(BookingModel b) async {
    final canCancel = _canCancel(b);
    final canRefund = _canRefund(b) && !_refundRequestedIdsBE.contains(b.id);
    final canReview = _canReview(b);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        Widget item({
          required IconData icon,
          required String title,
          String? sub,
          bool enabled = true,
          VoidCallback? onTap,
        }) {
          return ListTile(
            leading:
                Icon(icon, color: enabled ? Colors.black87 : Colors.black26),
            title: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: enabled ? Colors.black87 : Colors.black38)),
            subtitle: sub != null
                ? Text(sub, style: const TextStyle(color: Colors.black45))
                : null,
            onTap: enabled
                ? () {
                    Navigator.pop(ctx);
                    onTap?.call();
                  }
                : null,
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              item(
                icon: Icons.receipt_long,
                title: 'Xem chi tiết đơn',
                onTap: () {
                  final args = DisplayBookingArgs(
                    booking: b,
                    displayTitle: _displayTitle(b),
                    displayImageUrl: _displayImageUrl(b),
                  );
                  Navigator.pushNamed(context, BookingDetailScreen.routeName,
                      arguments: args);
                },
              ),
              const Divider(height: 1),
              item(
                icon: Icons.cancel_schedule_send_outlined,
                title: 'Huỷ đơn',
                sub: !canCancel
                    ? 'Chỉ huỷ trong ${_REFUND_WINDOW_HOURS}h sau khi xác nhận'
                    : null,
                enabled: canCancel,
                onTap: () => _confirmAndCancel(context, b),
              ),
              item(
                icon: Icons.undo_rounded,
                title: 'Yêu cầu hoàn tiền',
                sub: !canRefund
                    ? (b.isCancelledAny
                        ? 'Chỉ hỗ trợ khi thanh toán online'
                        : 'Chỉ hiện khi đơn đã huỷ')
                    : null,
                enabled: canRefund,
                onTap: () => _showRefundSheet(context, b),
              ),
              item(
                icon: Icons.star_rate_rounded,
                title: 'Đánh giá trải nghiệm',
                sub: !canReview
                    ? 'Chỉ khi đã hoàn thành và chưa từng đánh giá'
                    : null,
                enabled: canReview,
                onTap: () => _showReviewSheet(context, b),
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingCard({
    required Widget image,
    required String title,
    required String status,
    required int statusCode,
    required String location,
    required String price,
    required String orderDate,
    bool showCancelButton = false,
    VoidCallback? onCancelPressed,
    bool showRefundButton = false,
    VoidCallback? onRefundPressed,
    bool showRefundSentBadge = false,
    bool showReviewButton = false,
    VoidCallback? onReviewPressed,
    int? reviewedStars,
    bool showReviewedBadge = false,
    VoidCallback? onManagePressed,
    bool showManageButton = true,
  }) {
    final style = _statusStyles[statusCode] ??
        const _StatusStyle(Colors.teal, Color(0xFFE0F2F1), Icons.info_rounded);

    final fg = style.fg;
    final bg = style.bg;
    final icon = style.icon;

    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.35),
            width: 0.7),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(aspectRatio: 16 / 9, child: image),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.06),
                          Colors.black.withOpacity(0.25)
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.8.w, vertical: 0.7.h),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: fg.withOpacity(0.22), width: 0.8),
                      boxShadow: [
                        BoxShadow(
                            color: fg.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 12.sp, color: fg),
                        SizedBox(width: 1.2.w),
                        Text(
                          status,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                              color: fg,
                              letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(3.5.w, 0.6.h, 3.5.w, 1.2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            title,
                            key: ValueKey(title),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: ColorPalette.primaryColor,
                              fontSize: 14.5.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      price,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 13.8.sp,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        size: 13.5.sp, color: Colors.grey[600]),
                    SizedBox(width: 1.4.w),
                    Expanded(
                      child: Text(
                        'Ngày đặt: $orderDate',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700], fontSize: 11.8.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.place_rounded,
                        size: 13.5.sp, color: Colors.grey[600]),
                    SizedBox(width: 1.4.w),
                    Expanded(
                      child: Text(
                        'Tây Ninh',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700], fontSize: 11.8.sp),
                      ),
                    ),
                    if (showRefundSentBadge) ...[
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () async {
                          final bookingTitleLookup = {
                            for (final x in _items) x.id: _displayTitle(x)
                          };
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RefundListScreen(
                                    bookingTitleLookup: bookingTitleLookup)),
                          );
                          await _refreshAll();
                        },
                        child: const _RefundSentBadge(),
                      ),
                    ],
                    if (showReviewedBadge) ...[
                      SizedBox(width: 2.w),
                      _ReviewedThanksBadge(stars: reviewedStars),
                    ],
                    if (showReviewButton) ...[
                      SizedBox(width: 2.w),
                      Tooltip(
                          message: 'Đánh giá đơn này',
                          child: ReviewPillButton(onPressed: onReviewPressed)),
                    ] else if (showManageButton) ...[
                      SizedBox(width: 2.w),
                      Tooltip(
                        message: 'Quản lý đơn này',
                        child: TextButton.icon(
                          onPressed: onManagePressed,
                          icon: const Icon(Icons.manage_accounts_rounded,
                              size: 14, color: Colors.white),
                          label: const Text('Quản lý',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorPalette.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.2.w, vertical: 0.8.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context, BookingModel b) {
    final commentCtrl = TextEditingController();
    double stars = 5;
    const int maxLen = 300;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, state) {
              final isLoading = state is ReviewBookingSubmitting;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const Row(children: [
                      TitleWithCustoneUnderline(
                          text: 'Đánh giá ', text2: ' trải nghiệm')
                    ]),
                    const SizedBox(height: 6),
                    Text(
                      'Đánh giá & để lại lời nhắn ngắn gọn (tuỳ chọn).',
                      style: Theme.of(ctx)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: RatingBar.builder(
                        initialRating: 5,
                        minRating: 1,
                        allowHalfRating: false,
                        glow: false,
                        itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade600),
                        itemSize: 36,
                        unratedColor: Colors.grey.shade300,
                        onRatingUpdate: (v) => stars = v,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: commentCtrl,
                      maxLines: 4,
                      maxLength: maxLen,
                      decoration: InputDecoration(
                        counterText: '${commentCtrl.text.length}/$maxLen',
                        hintText:
                            'Chia sẻ thêm một chút về chuyến đi (tuỳ chọn)',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.08),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(ctx).primaryColor, width: 1.2),
                        ),
                      ),
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(ctx).maybePop(),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Đóng'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final cmt = commentCtrl.text.trim();
                                    final rating = stars.round().clamp(1, 5);
                                    ctx.read<BookingBloc>().add(
                                          ReviewBookingEvent(
                                            ReviewBookingRequest(
                                                bookingId: b.id,
                                                comment: cmt,
                                                rating: rating),
                                          ),
                                        );
                                    _markReviewed(b, rating);
                                  },
                            icon: isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.send_rounded, size: 20),
                            label: Text(
                                isLoading ? 'Đang gửi...' : 'Gửi đánh giá'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ReviewedThanksBadge extends StatelessWidget {
  final int? stars;
  const _ReviewedThanksBadge({this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified_rounded, size: 18, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Đã đánh giá',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundSentBadge extends StatelessWidget {
  const _RefundSentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.green.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
          SizedBox(width: 6),
          Text(
            'Đã gửi yêu cầu hoàn tiền',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSort extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool asc;
  final VoidCallback onTap;
  const _HeaderSort({
    required this.label,
    required this.isActive,
    required this.asc,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final st = Theme.of(context).textTheme.labelMedium!.copyWith(
          color: isActive ? Colors.black87 : Colors.grey[700],
          fontWeight: FontWeight.w800,
        );
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        Text(label, style: st),
        Icon(asc ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 18),
      ]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;
  final IconData icon;
  const _StatusChip(
      {required this.text,
      required this.fg,
      required this.bg,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: fg.withOpacity(0.2)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Flexible(
            // <- tránh tràn
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700),
            ),
          ),
        ]),
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  final bool showManage;
  final bool showReview;
  final bool showReviewedBadge;
  final bool showRefundSentBadge;
  final bool showRefundMenu;
  final VoidCallback? onManage;
  final VoidCallback? onReview;
  final VoidCallback? onRefund;

  const _RowActions({
    Key? key,
    required this.showManage,
    required this.showReview,
    required this.showReviewedBadge,
    required this.showRefundSentBadge,
    required this.showRefundMenu,
    this.onManage,
    this.onReview,
    this.onRefund,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <PopupMenuEntry<int>>[];

    if (showManage) {
      items.add(const PopupMenuItem<int>(
        value: 1,
        child: ListTile(
          leading: Icon(Icons.manage_accounts_rounded),
          title: Text('Quản lý đơn'),
        ),
      ));

      if (showRefundMenu) {
        items.add(const PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.undo_rounded),
            title: Text('Yêu cầu hoàn tiền'),
          ),
        ));
      }
    }

    if (showReview) {
      items.add(const PopupMenuItem<int>(
        value: 3,
        child: ListTile(
          leading: Icon(Icons.star_rate_rounded),
          title: Text('Đánh giá trải nghiệm'),
        ),
      ));
    }

    return Flexible(
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          if (showRefundSentBadge) const _RefundSentBadge(),
          if (showReviewedBadge) const _ReviewedThanksBadge(),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 40, maxWidth: 48),
            child: Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<int>(
                tooltip: 'Thao tác',
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) {
                  if (val == 1) onManage?.call();
                  if (val == 2) onRefund?.call();
                  if (val == 3) onReview?.call();
                },
                itemBuilder: (_) => items.isEmpty
                    ? const [
                        PopupMenuItem<int>(
                            enabled: false, child: Text('Không còn thao tác'))
                      ]
                    : items,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniThumb extends StatelessWidget {
  final String? url;
  final BookingModel booking;
  const _MiniThumb({this.url, required this.booking});
  @override
  Widget build(BuildContext context) {
    if ((url ?? '').isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _thumbFallback(booking),
          loadingBuilder: (c, w, p) =>
              Container(width: 56, height: 56, color: Colors.black12),
        ),
      );
    }
    return _thumbFallback(booking);
  }
}

Widget _thumbFallback(BookingModel b) {
  final bookingType = int.tryParse(b.bookingType.toString()) ?? -1;
  final isPersonal =
      bookingType == 3 && (b.tripPlanId != null && b.tripPlanId!.isNotEmpty);

  return Stack(children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        AssetHelper.img_tay_ninh_login,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
    ),
    if (isPersonal)
      Positioned(
        right: 2,
        top: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.hiking, size: 12, color: Colors.white),
        ),
      ),
  ]);
}

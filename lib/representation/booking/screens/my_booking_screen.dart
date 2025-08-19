import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';

import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_event.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_state.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/core/repository/tour_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';

import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/booking/review_booking_request.dart';
import 'package:travelogue_mobile/model/refund_request/refund_create_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

import 'package:travelogue_mobile/representation/booking/screens/refund_list_screen.dart';
import 'package:travelogue_mobile/representation/booking/widgets/review_pill_button.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_detail_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/trip_detail_screen.dart';
import 'package:travelogue_mobile/representation/booking/screens/booking_detail_screen.dart';

class MyBookingScreen extends StatefulWidget {
  static const String routeName = '/my-bookings';
  final List<BookingModel> bookings;

  const MyBookingScreen({super.key, required this.bookings});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

enum SortOrder { newest, oldest }

class _MyBookingScreenState extends State<MyBookingScreen> {
  int selectedStatusTab = 0;
  final List<String> statusTabs = [
    "Hết hạn",
    "Đã thanh toán",
    "Đã hoàn thành",
    "Đã hủy",
  ];

  final Map<String, int> _reviewed = {};

  // Chỉ được review khi đã hoàn thành và chưa review
  bool _canReview(BookingModel b) {
    return _statusCodeOf(b) == 2 && !_reviewed.containsKey(b.id);
  }

// Sau khi review xong
  void _markReviewed(BookingModel b, int rating) {
    _reviewed[b.id] = rating;
    if (mounted) setState(() {});
  }

  int selectedType = 0;
  SortOrder selectedSort = SortOrder.newest;
  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  bool _prefetchedTours = false;

  static const int _REFUND_WINDOW_HOURS = 24;

  @override
  void initState() {
    super.initState();
    _prefetchToursForType1();
  }

  int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  int _statusCodeOf(BookingModel b) {
    final txt = (b.statusText ?? '').trim().toLowerCase();

    if (txt.contains('hủy') ||
        txt.contains('huỷ') ||
        txt.contains('canceled') ||
        txt.contains('cancelled')) {
      return 3;
    }

    // 2) Đọc status số
    final dynamic s = b.status;
    int? raw;
    if (s is int) raw = s;
    if (s is String) raw = int.tryParse(s);

    if (raw != null) {
      if (raw == 3 || raw == 4) return 3; // hủy
      if (raw == 5) return 2; // BE: 5 = hoàn thành
      if (raw == 2) return 2; // hoàn tất
      if (raw == 1) return 1; // đã thanh toán
      if (raw == 0) return 0; // hết hạn/pending
    }

    // 3) Fallback theo text
    if (txt.contains('đã hoàn tất') ||
        txt.contains('đã hoàn thành') ||
        txt.contains('completed')) return 2;
    if (txt.contains('đã thanh toán') ||
        txt.contains('confirmed') ||
        txt.contains('paid')) return 1;
    if (txt.contains('hết hạn') ||
        txt.contains('pending') ||
        txt.contains('unpaid')) return 0;

    return 0;
  }

  String _statusText(BookingModel b) {
    switch (_statusCodeOf(b)) {
      case 0:
        return 'Hết hạn thanh toán';
      case 1:
        return 'Đã thanh toán';
      case 2:
        return 'Đã hoàn thành';
      case 3:
        return 'Đã hủy';
      default:
        return b.statusText ?? 'Không rõ';
    }
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

  int _bookingTypeOf(BookingModel b) => _asInt(b.bookingType, fallback: -1);

  bool _isPersonalGuide(BookingModel b) =>
      _bookingTypeOf(b) == 3 && b.tripPlanId != null;

  bool _isPlainGuide(BookingModel b) =>
      _bookingTypeOf(b) == 3 && b.tripPlanId == null;

  String _displayTitle(BookingModel b) {
    final bt = _bookingTypeOf(b);
    if (bt == 1) return b.tour?.name ?? "Tour ...";
    if (bt == 3)
      return _isPersonalGuide(b) ? "Chuyến đi cá nhân" : "Hướng dẫn viên";
    return b.bookingTypeText ?? _typeText(bt);
  }

  DateTime _safeBookingDate(BookingModel b) {
    try {
      return b.bookingDate;
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  Future<void> _prefetchToursForType1() async {
    if (_prefetchedTours) return;

    final futures = <Future<void>>[];

    for (final b in widget.bookings) {
      final bt = _asInt(b.bookingType, fallback: -1);
      final hasTourId = b.tourId != null && b.tourId!.isNotEmpty;

      if (bt == 1 && hasTourId && b.tour == null) {
        futures.add(() async {
          final tour = await TourRepository().getTourById(b.tourId!);
          if (tour == null) return;

          final idx = widget.bookings.indexWhere((x) => x.id == b.id);
          if (idx != -1) {
            final updated = widget.bookings[idx].copyWith(tour: tour);
            widget.bookings[idx] = updated;
          }
        }());
      }
    }

    await Future.wait(futures);

    if (mounted) {
      setState(() => _prefetchedTours = true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Xem yêu cầu hoàn tiền',
            icon: const Icon(Icons.folder_open_rounded, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RefundListScreen()),
              );
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RefundBloc, RefundState>(
            listener: _onRefundStateChanged,
          ),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);

              if (state is ReviewBookingSubmitting) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Đang gửi đánh giá...')),
                );
              } else if (state is ReviewBookingSuccess) {
                // đóng bottom sheet nếu đang mở
                Navigator.of(context, rootNavigator: true).maybePop();
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                      content:
                          Text(state.message ?? 'Cảm ơn bạn đã đánh giá!')),
                );
              } else if (state is BookingFailure) {
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
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
      Navigator.of(context, rootNavigator: true).maybePop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Gửi yêu cầu hoàn tiền thành công.')),
      );
    } else if (state is RefundFailure) {
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi hoàn tiền: ${state.error}')),
      );
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
                      : Colors.grey.shade300,
                ),
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
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
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

  String _sortLabel(SortOrder order) {
    switch (order) {
      case SortOrder.newest:
        return 'Gần đây nhất';
      case SortOrder.oldest:
        return 'Lâu nhất';
    }
  }

  Widget _buildSortControl() {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<SortOrder>(
        onSelected: (val) => setState(() => selectedSort = val),
        offset: const Offset(0, 8),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        constraints: const BoxConstraints(minWidth: 200),
        itemBuilder: (context) => const [
          CheckedPopupMenuItem(
              checked: true,
              value: SortOrder.newest,
              child: Text('Gần đây nhất')),
          CheckedPopupMenuItem(
              checked: false, value: SortOrder.oldest, child: Text('Lâu nhất')),
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
                  offset: const Offset(0, 2)),
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

  // 24h kể từ thời điểm đặt
  bool _withinRefundWindow(BookingModel b) {
    final bookingTime = _safeBookingDate(b);
    final now = DateTime.now();
    return now.difference(bookingTime).inHours < _REFUND_WINDOW_HOURS;
  }

  bool _canCancel(BookingModel b) =>
      _statusCodeOf(b) == 1 && _withinRefundWindow(b);

  bool _canRefund(BookingModel b) {
    final wasPaid = b.paymentLinkId != null && b.paymentLinkId!.isNotEmpty;
    return _statusCodeOf(b) == 3 && wasPaid;
  }

  Widget _buildBookingList() {
    final typeFiltered = widget.bookings.where((b) {
      if (selectedType == 0) return true;
      final bt = _bookingTypeOf(b);
      if (selectedType == 1) return bt == 1;
      if (selectedType == 2) return bt == 2;
      if (selectedType == 3) return _isPlainGuide(b);
      if (selectedType == 4) return _isPersonalGuide(b);
      return true;
    }).toList();

    final filtered = typeFiltered.where((b) {
      final code = _statusCodeOf(b);
      switch (selectedStatusTab) {
        case 0:
          return code == 0; // Hết hạn
        case 1:
          return code == 1; // Đã thanh toán
        case 2:
          return code == 2; // Đã hoàn thành
        case 3:
          return code == 3; // Đã hủy
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

    if (filtered.isEmpty) {
      return Center(
          child: Text('Không có đơn nào.', style: TextStyle(fontSize: 11.sp)));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final b = filtered[index];
        final bt = _bookingTypeOf(b);

        Widget imageWidget;
        if (bt == 1 && b.tour?.mediaList.isNotEmpty == true) {
          imageWidget = Image.network(
            b.tour!.mediaList.first.mediaUrl ?? '',
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              AssetHelper.img_tay_ninh_login,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          );
        } else if (bt == 3 && _isPersonalGuide(b)) {
          imageWidget = Stack(
            children: [
              Image.asset(
                AssetHelper.img_tay_ninh_login,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.hiking, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Cá nhân',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          imageWidget = Image.asset(
            AssetHelper.img_tay_ninh_login,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          );
        }

        final title = _displayTitle(b);
        final statusCode = _statusCodeOf(b);
        final canReview = _canReview(b);
        final reviewedStars = _reviewed[b.id];

        return GestureDetector(
          onTap: () async {
            if (statusCode == 3) {
              Navigator.pushNamed(context, BookingDetailScreen.routeName,
                  arguments: b);
              return;
            }

            if (statusCode == 1) {
              if (bt == 1 && b.tourId != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
                final TourModel? tour =
                    await TourRepository().getTourById(b.tourId!);
                if (mounted) Navigator.pop(context);

                if (tour != null) {
                  final idx = widget.bookings.indexWhere((bk) => bk.id == b.id);
                  if (idx != -1) {
                    widget.bookings[idx] =
                        widget.bookings[idx].copyWith(tour: tour);
                  }
                  if (mounted) setState(() {});
                  final coverImage = tour.mediaList.isNotEmpty
                      ? (tour.mediaList.first.mediaUrl ??
                          AssetHelper.img_tay_ninh_login)
                      : AssetHelper.img_tay_ninh_login;
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
                      const SnackBar(
                          content: Text("Không tìm thấy thông tin tour.")),
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
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
                final TourGuideModel? guide = await TourGuideRepository()
                    .getTourGuideById(b.tourGuideId!);
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
                          content:
                              Text("Không tìm thấy thông tin hướng dẫn viên.")),
                    );
                  }
                }
                return;
              }
            }

            Navigator.pushNamed(context, BookingDetailScreen.routeName,
                arguments: b);
          },
          child: _buildBookingCard(
            image: imageWidget,
            title: title,
            status: _statusText(b),
            statusCode: statusCode,
            location: "Tây Ninh",
            price: currency.format((b.finalPrice)),
            orderDate: DateFormat('dd/MM/yyyy').format(_safeBookingDate(b)),

            showCancelButton: _canCancel(b),
            onCancelPressed: () => _confirmAndCancel(context, b),

            showRefundButton: _canRefund(b),
            onRefundPressed: () => _showRefundSheet(context, b),

            // 👇 THÊM 3 THAM SỐ NÀY
            showReviewButton: canReview,
            onReviewPressed: () => _showReviewSheet(context, b),
            reviewedStars: reviewedStars,
          ),
        );
      },
    );
  }

  // ====== HUỶ ĐƠN ======
  Future<void> _confirmAndCancel(BuildContext context, BookingModel b) async {
    final allow = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Huỷ đơn?'),
        content: const Text(
            'Huỷ đơn sẽ chuyển trạng thái sang "Đã huỷ". Bạn có thể yêu cầu hoàn tiền sau khi huỷ.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Không')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Huỷ đơn')),
        ],
      ),
    );

    if (allow != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final result = await BookingRepository().cancelBooking(b.id);

    if (mounted) Navigator.pop(context);

    if (!result.ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result.message ??
                'Không thể hủy đơn đã hoàn tất hoặc đã hết hạn.')),
      );
      return;
    }

    _markBookingCanceled(b);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã huỷ đơn thành công.')),
    );
  }

  void _markBookingCanceled(BookingModel b) {
    final idx = widget.bookings.indexWhere((x) => x.id == b.id);
    if (idx != -1) {
      final updated = widget.bookings[idx].copyWith(
        status: '3',
        statusText: 'Đã hủy',
        cancelledAt: DateTime.now(),
      );
      widget.bookings[idx] = updated;
      setState(() {});
    }
  }

  // ====== HOÀN TIỀN ======
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
          child: BlocBuilder<RefundBloc, RefundState>(
            builder: (ctx, state) {
              final isLoading = state is RefundLoading;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.undo_rounded),
                        const SizedBox(width: 8),
                        Text(
                          'Yêu cầu hoàn tiền',
                          style: Theme.of(ctx)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
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
                                    final reason = reasonController.text.trim();
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
                            label:
                                Text(isLoading ? 'Đang gửi...' : 'Gửi yêu cầu'),
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

  String _amountToText(dynamic v) {
    if (v == null) return '0';
    if (v is int) return v.toString();
    if (v is double) return v.round().toString();
    if (v is num) return v.round().toString();
    return v.toString().replaceAll(RegExp(r'[^0-9]'), '');
  }

  int _parseAmount(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  // ====== Card UI ======
  Widget _buildBookingCard({
    required Widget image,
    required String title,
    required String status, // chỉ để hiển thị
    required int statusCode, // dùng để style
    required String location,
    required String price,
    required String orderDate,
    bool showCancelButton = false,
    VoidCallback? onCancelPressed,
    bool showRefundButton = false,
    VoidCallback? onRefundPressed,
    bool showReviewButton = false,
    VoidCallback? onReviewPressed,
    int? reviewedStars, // nếu đã review, hiển thị chip “Cảm ơn …” + sao
  }) {
    // Chọn màu/icon theo statusCode
    late Color fg;
    late Color bg;
    late IconData icon;

    switch (statusCode) {
      case 0:
        fg = const Color(0xFFB46900);
        bg = const Color(0xFFFFEDD5);
        icon = Icons.timer_off_rounded;
        break;
      case 1:
        fg = Colors.white;
        bg = Colors.lightBlueAccent.withOpacity(0.18);
        icon = Icons.verified_rounded;
        break;
      case 2:
        fg = Colors.green.shade800;
        bg = Colors.green.shade100;
        icon = Icons.check_circle_rounded;
        break;
      case 3:
        fg = Colors.red.shade600;
        bg = Colors.redAccent.withOpacity(0.16);
        icon = Icons.cancel_rounded;
        break;
      default:
        fg = Colors.teal.shade700;
        bg = Colors.teal.withOpacity(0.14);
        icon = Icons.info_rounded;
    }

    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
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
                          Colors.black.withOpacity(0.25),
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
                          offset: const Offset(0, 6),
                        )
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
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(3.5.w, 1.8.h, 3.5.w, 1.6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          color: ColorPalette.primaryColor,
                          fontSize: 14.5.sp,
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
                          color: Colors.grey[700],
                          fontSize: 11.8.sp,
                        ),
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
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 11.8.sp,
                        ),
                      ),
                    ),
                    if (showCancelButton) ...[
                      SizedBox(width: 2.w),
                      Tooltip(
                        message: 'Huỷ đơn',
                        child: TextButton.icon(
                          onPressed: onCancelPressed,
                          icon: Icon(Icons.cancel_schedule_send_outlined,
                              size: 13.sp, color: Colors.white),
                          label: Text(
                            'Huỷ đơn',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.orangeAccent.withOpacity(0.92),
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
                    if (showRefundButton) ...[
                      SizedBox(width: 2.w),
                      Tooltip(
                        message: 'Yêu cầu hoàn tiền',
                        child: TextButton.icon(
                          onPressed: onRefundPressed,
                          icon: Icon(Icons.undo_rounded,
                              size: 13.sp, color: Colors.white),
                          label: Text(
                            'Hoàn tiền',
                            style: TextStyle(
                                fontSize: 10.8.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.92),
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
                    if (showReviewButton) ...[
                      SizedBox(width: 2.w),
                      Tooltip(
                        message: 'Đánh giá đơn này',
                        child: ReviewPillButton(
                          onPressed: onReviewPressed,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
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
                    // --- drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // --- header
                    Row(
                      children: [
                        const TitleWithCustoneUnderline(
                          text: 'Đánh giá ',
                          text2: ' trải nghiệm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Đánhh giá & để lại lời nhắn ngắn gọn (tuỳ chọn).',
                      style: Theme.of(ctx)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 14),
                    // --- rating big & clean
                    Center(
                      child: RatingBar.builder(
                        initialRating: 5,
                        minRating: 1,
                        allowHalfRating: false,
                        glow: false,
                        itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Colors.amber.shade600, // ⭐ vàng dịu
                        ),
                        itemSize: 36,
                        unratedColor:
                            Colors.grey.shade300, // sao chưa chọn màu xám
                        onRatingUpdate: (v) => stars = v,
                      ),
                    ),

                    const SizedBox(height: 14),
                    // --- comment field (filled, rounded)
                    TextField(
                      controller: commentCtrl,
                      maxLines: 4,
                      maxLength: maxLen,
                      decoration: InputDecoration(
                        counterText:
                            '${commentCtrl.text.length}/$maxLen', // sẽ cập nhật sau setState nếu muốn dynamic
                        hintText:
                            'Chia sẻ thêm một chút về chuyến đi (tuỳ chọn)',
                        // >>> chú ý: KHÔNG dùng câu “điều bạn thích/không thích”
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
                      onChanged: (_) {
                        // nếu muốn counter cập nhật realtime, gọi setState(() {});
                      },
                    ),

                    const SizedBox(height: 10),
                    // --- actions
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
                                              comment:
                                                  cmt, 
                                              rating: rating,
                                            ),
                                          ),
                                        );
                                    _markReviewed(
                                        b, rating); 
                                  },
                            icon: isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
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

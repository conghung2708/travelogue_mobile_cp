import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_qr_payment_screen.dart';

import '../widgets/guide_top_banner.dart';
import '../widgets/guide_info_card.dart';
import '../widgets/guide_policy_card.dart';
import '../widgets/confirm_total_bar.dart';
import '../widgets/exit_confirm_dialog.dart';

class GuideBookingConfirmationScreen extends StatefulWidget {
  static const String routeName = '/guide-booking-confirmation';

  final TourGuideModel guide;
  final String? tripPlanId;
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;

  const GuideBookingConfirmationScreen({
    super.key,
    required this.guide,
    this.tripPlanId,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
  });

  @override
  State<GuideBookingConfirmationScreen> createState() =>
      _GuideBookingConfirmationScreenState();
}

class _GuideBookingConfirmationScreenState
    extends State<GuideBookingConfirmationScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  final hasAcceptedTerms = ValueNotifier<bool>(false);
  bool isLoading = false;
  String? bookingId;

  String get _tripPlanId => widget.tripPlanId ?? '';

  bool get _lockedByTripPlan => _tripPlanId.isNotEmpty;

  void _showInfo(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  Future<void> _changeDateRange() async {
    if (_lockedByTripPlan) {
      _showInfo('Bạn không thể đổi ngày vì đang liên kết với Trip Plan.');
      return;
    }

    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _onConfirmBooking() {
    final model = CreateBookingTourGuideModel(
      tripPlanId: _tripPlanIdOrNull,
      tourGuideId: widget.guide.id!,
      startDate: _startDate,
      endDate: _endDate,
      adultCount: widget.adults,
      childrenCount: widget.children,
    );

    context.read<BookingBloc>().add(CreateTourGuideBookingEvent(model));
    setState(() => isLoading = true);
  }

  void _onBookingSuccess(String id) {
    bookingId = id;
    context
        .read<BookingBloc>()
        .add(CreatePaymentLinkEvent(id, fromGuide: true));
  }

  void _onPaymentSuccess(String paymentUrl) {
    setState(() => isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TourGuideQrPaymentScreen(
          guide: widget.guide,
          startDate: _startDate,
          endDate: _endDate,
          adults: widget.adults,
          children: widget.children,
          startTime: DateTime.now(),
          paymentUrl: paymentUrl,
          tripPlanId: _tripPlanId,
          bookingId: bookingId,
        ),
      ),
    );
  }

  String? get _tripPlanIdOrNull =>
      (widget.tripPlanId != null && widget.tripPlanId!.isNotEmpty)
          ? widget.tripPlanId
          : null;

  void _showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEEE, dd MMM yyyy', 'vi_VN');
    final currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

    final VoidCallback? editDatesCallback =
        _lockedByTripPlan ? null : _changeDateRange;

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingGuideSuccess) {
          bookingId = state.booking.id;
          _onBookingSuccess(state.booking.id);
        } else if (state is PaymentLinkGuideSuccess) {
          _onPaymentSuccess(state.paymentUrl);
        } else if (state is BookingFailure) {
          _showError(state.error);
        }
      },
      child: WillPopScope(
        onWillPop: () async => await ExitConfirmDialog.show(context) ?? false,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9FAFC),
              body: SafeArea(
                child: Column(
                  children: [
                    GuideTopBanner(
                      guide: widget.guide,
                      onBackPressed: () async {
                        final ok = await ExitConfirmDialog.show(context);
                        if (ok == true && mounted) Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GuideInfoCard(
                              guide: widget.guide,
                              startDate: _startDate,
                              endDate: _endDate,
                              adults: widget.adults,
                              children: widget.children,
                              onEditDates: editDatesCallback,
                              dateFormatter: formatter,
                              currencyFormat: currencyFormat,
                            ),
                            SizedBox(height: 2.h),
                            GuidePolicyCard(hasAcceptedTerms: hasAcceptedTerms),
                            SizedBox(height: 3.h),
                            ConfirmTotalBar(
                              startDate: _startDate,
                              endDate: _endDate,
                              guideDailyPrice: widget.guide.price ?? 0,
                              currencyFormat: currencyFormat,
                              acceptedListenable: hasAcceptedTerms,
                              onConfirm: _onConfirmBooking,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

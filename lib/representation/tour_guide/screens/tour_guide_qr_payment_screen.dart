import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

import 'package:travelogue_mobile/representation/tour_guide/widgets/payment_countdown_header.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/payment_expired_dialog.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/payment_leave_confirm_dialog.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/payment_marquee_bar.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/payment_webview_section.dart';

class TourGuideQrPaymentScreen extends StatefulWidget {
  static const String routeName = '/guide-qr-payment';

  final TourGuideModel guide;
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;
  final DateTime startTime;
  final String? paymentUrl;
  final String? tripPlanId;
  final String? bookingId;

  const TourGuideQrPaymentScreen({
    super.key,
    required this.guide,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
    required this.startTime,
    this.paymentUrl,
    this.tripPlanId,
    this.bookingId,
  });

  @override
  State<TourGuideQrPaymentScreen> createState() =>
      _TourGuideQrPaymentScreenState();
}

class _TourGuideQrPaymentScreenState extends State<TourGuideQrPaymentScreen> {
  WebViewController? _webViewController;
  final _gestureRecognizers = {Factory(() => EagerGestureRecognizer())};

  Duration _remaining = const Duration(minutes: 5);
  late Timer _timer;
  bool _isLoading = true;
  final _bookingRepository = BookingRepository();
  @override
  void initState() {
    super.initState();

    final elapsed = DateTime.now().difference(widget.startTime);
    _remaining = const Duration(minutes: 5) - elapsed;
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
    }

    _startCountdown();

    if (widget.paymentUrl != null && widget.paymentUrl!.isNotEmpty) {
      _loadWebViewFromUrl(widget.paymentUrl!);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        timer.cancel();
        showPaymentExpiredDialog(context);
      }
    });
  }

  void _loadWebViewFromUrl(String url) {
    final uri = Uri.parse(url);
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
          onPageStarted: (_) => setState(() => _isLoading = true),
          onNavigationRequest: (request) {
            final u = request.url;
            if (u.contains("status=PAID")) {
              _completePayment();
              return NavigationDecision.prevent;
            } else if (u.contains('status=CANCELLED') ||
                u.contains('status=CANCELED')) {
              _handleCancel();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    setState(() {
      _webViewController = controller;
      _isLoading = true;
    });
  }

void _handleCancel() async {
  final id = widget.bookingId;
  if (id == null || id.isEmpty) {
    print('[⚠️] tripPlanId is null or empty, skip cancel API');
    _finishFlow();
    return;
  }

  try {
   
    final result = await _bookingRepository.cancelBooking(id);
    if (result.ok) {
      print('[✅] Booking cancelled successfully');
    } else {
      print('[⚠️] Booking cancel failed: ${result.message ?? 'Unknown error'}');
    }
  } catch (e) {
    print('[❌] Cancel Booking Error: $e');
  } finally {
    Future.delayed(const Duration(seconds: 5), _finishFlow);
  }
}

  void _finishFlow() {
    if (!mounted) {
      return;
    }

    final goToIndex = (widget.tripPlanId?.isNotEmpty == true) ? 2 : 1;

    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      (route) => false,
    );
    AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: goToIndex));
  }

  void _completePayment() => _finishFlow();

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final price = widget.guide.price != null
        ? currency.format(widget.guide.price)
        : "Không rõ";
    final name = widget.guide.userName ?? "Hướng dẫn viên";

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => showLeaveConfirmDialog(context, onConfirm: _finishFlow),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              PaymentCountdownHeader(
                title: 'Thanh toán hướng dẫn viên',
                subtitle: '$name – $price/ngày',
                remaining: _remaining,
                onBackPressed: () =>
                    showLeaveConfirmDialog(context, onConfirm: _finishFlow),
              ),
              Expanded(
                child: PaymentWebViewSection(
                  controller: _webViewController,
                  gestureRecognizers: _gestureRecognizers,
                  isLoading: _isLoading,
                ),
              ),
              const PaymentMarqueeBar(
                text: '💳 Travelogue – Thanh toán bảo mật với PayOS',
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}

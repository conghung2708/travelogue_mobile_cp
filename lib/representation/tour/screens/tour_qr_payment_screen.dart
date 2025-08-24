// lib/features/tour/presentation/screens/tour_qr_payment_screen.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';

// Widgets
import 'package:travelogue_mobile/representation/tour/widgets/marquee_note_bar.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_dialogs.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_webview.dart';
import 'package:travelogue_mobile/representation/tour/widgets/qr_payment_header.dart';

class TourQrPaymentScreen extends StatefulWidget {
  static const routeName = '/tour-qr-payment';

  final TourModel tour;
  final TourScheduleModel schedule;
  final DateTime startTime;
  final int adults;
  final int children;
  final double totalPrice;


  final String? bookingId;
  final String checkoutUrl;
  

  const TourQrPaymentScreen({
    super.key,
    required this.tour,
    required this.schedule,
    required this.startTime,
    required this.adults,
    required this.children,
    required this.totalPrice,
     this.bookingId,
    required this.checkoutUrl,
  });

  @override
  State<TourQrPaymentScreen> createState() => _TourQrPaymentScreenState();
}

class _TourQrPaymentScreenState extends State<TourQrPaymentScreen> {
  WebViewController? _webViewController;
  bool _hasController = false;
  bool _isLoading = true;
  bool _navigated = false;

  // Countdown 5 phút
  late DateTime _deadline;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  final _gestureRecognizers = { Factory(() => EagerGestureRecognizer()) };

  @override
  void initState() {
    super.initState();
    _deadline = DateTime.now().add(const Duration(minutes: 5));
    _tick();
    _startCountdown();

    _loadWebViewFromUrl(widget.checkoutUrl);
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final diff = _deadline.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
    if (_remaining == Duration.zero) {
      _timer?.cancel();
      PaymentDialogs.showExpired(context);
    }
  }

  void _loadWebViewFromUrl(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            final u = request.url;
            if (u.contains('status=PAID')) {
              _completePayment();
              return NavigationDecision.prevent;
            } else if (u.contains('status=CANCELLED')) {
              _handleCancelAndBack();
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
      _hasController = true;
      _isLoading = true;
    });
  }

  void _completePayment() => _backToMain();

  void _backToMain() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      (route) => false,
    );
    AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 2)); 
  }

Future<void> _handleCancelAndBack() async {
  if (_navigated) return;
  if (widget.bookingId == null || widget.bookingId!.isEmpty) {
    debugPrint('[ℹ️] Không có bookingId, bỏ qua huỷ booking');
    _backToMain();
    _navigated = true;
    return;
  }

  try {
    final result = await BookingRepository().cancelBooking(widget.bookingId!);

    if (result.ok) {
      debugPrint('[✅] Booking cancelled successfully');
    } else {
      debugPrint('[⚠️] Booking cancel failed: ${result.message ?? 'unknown'}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message ?? 'Huỷ thất bại')),
        );
      }
    }
  } catch (e) {
    debugPrint('[❌] Cancel Booking Error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi huỷ: $e')),
      );
    }
  } finally {
    if (!_navigated) {
      _navigated = true;
      Future.delayed(const Duration(seconds: 2), _backToMain);
    }
  }
}

  Future<bool> _onWillPop() async {
    final confirm = await PaymentDialogs.showLeaveConfirm(context);
    if (confirm == true) _backToMain();
    return false; 
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatPrice(double v) =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(v);

  @override
  Widget build(BuildContext context) {
    final tourName = widget.tour.name ?? 'Chuyến đi';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              QrPaymentHeader(
                title: 'Thanh toán trực tuyến',
                subtitle: '$tourName – ${_formatPrice(widget.totalPrice)}',
                remaining: _remaining,
              ),
              Expanded(
                child: PaymentWebView(
                  hasController: _hasController,
                  controller: _webViewController,
                  isLoading: _isLoading,
                  gestureRecognizers: _gestureRecognizers,
                ),
              ),
              const MarqueeNoteBar(
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

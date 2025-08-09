import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';

class TourQrPaymentScreen extends StatefulWidget {
  static const routeName = '/tour-qr-payment';

  final TourModel tour;
  final TourScheduleModel schedule;
  final DateTime startTime;
  final int adults;
  final int children;
  final double totalPrice;
  final String? checkoutUrl;

  const TourQrPaymentScreen({
    super.key,
    required this.tour,
    required this.schedule,
    required this.startTime, // giữ để truyền qua nếu cần log/analytics
    required this.adults,
    required this.children,
    required this.totalPrice,
    this.checkoutUrl,
  });

  @override
  State<TourQrPaymentScreen> createState() => _TourQrPaymentScreenState();
}

class _TourQrPaymentScreenState extends State<TourQrPaymentScreen> {
  WebViewController? _webViewController;              // nullable để tránh crash khi build sớm
  bool _hasController = false;
  final _gestureRecognizers = { Factory(() => EagerGestureRecognizer()) };

  // Countdown: luôn 5 phút kể từ khi mở màn
  late DateTime _deadline;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Mốc đếm ngược độc lập với startTime
    _deadline = DateTime.now().add(const Duration(minutes: 5));
    _tick();               // cập nhật ngay lập tức
    _startCountdown();     // rồi chạy timer

    if (widget.checkoutUrl != null) {
      _loadWebViewFromUrl(widget.checkoutUrl!);
    } else {
      _createBookingAndPayment();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final diff = _deadline.difference(DateTime.now());
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
    if (_remaining == Duration.zero) {
      _timer?.cancel();
      _onCountdownFinished();
    }
  }

  Future<void> _createBookingAndPayment() async {
    try {
      final model = CreateBookingTourModel(
        tourId: widget.tour.tourId!,
        scheduledId: widget.schedule.scheduleId!,
        promotionCode: null,
        adultCount: widget.adults,
        childrenCount: widget.children,
      );

      final booking = await BookingRepository().createBooking(model);
      if (booking == null) {
        _showErrorDialog('Tạo booking thất bại. Vui lòng thử lại.');
        return;
      }

      final paymentUrl = await BookingRepository().createPaymentLink(booking.id);
      if (paymentUrl == null) {
        _showErrorDialog('Không tạo được liên kết thanh toán.');
        return;
      }

      _loadWebViewFromUrl(paymentUrl);
    } catch (e) {
      _showErrorDialog('Lỗi khi xử lý thanh toán: $e');
    }
  }

  void _loadWebViewFromUrl(String url) {
    final uri = Uri.parse(url);
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.contains('status=PAID')) {
              _completePayment();
              return NavigationDecision.prevent;
            } else if (url.contains('status=CANCELLED')) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName,
                  (route) => false,
                );
                AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 2));
              });
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }

  void _onCountdownFinished() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hết thời gian'),
        content: const Text('Thời gian thanh toán đã hết. Vui lòng quay lại.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }

  void _completePayment() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      (route) => false,
    );
    AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 2));
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn rời khỏi trang thanh toán?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rời khỏi'),
          ),
        ],
      ),
    );
    if (result == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        MainScreen.routeName,
        (route) => false,
      );
      AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 2));
    }
    return false; // chặn back mặc định
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Hiển thị mm:ss (vì chỉ 5p)
  String _formatDuration(Duration d) {
    final total = d.inSeconds.clamp(0, 5 * 60);
    final mm = (total ~/ 60).toString().padLeft(2, '0');
    final ss = (total % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final tourName = widget.tour.name ?? 'Chuyến đi';
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final price = currency.format(widget.totalPrice);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  gradient: Gradients.defaultGradientBackground,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () async {
                            final confirm = await _onWillPop();
                            if (confirm) Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                    Icon(Icons.web_rounded, size: 32.sp, color: Colors.white),
                    SizedBox(height: 1.h),
                    Text(
                      'Thanh toán trực tuyến',
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 0.6.h),
                    Text('$tourName – $price', style: TextStyle(fontSize: 15.sp, color: Colors.white70)),
                    SizedBox(height: 1.h),
                    _buildCountdownClock(),
                  ],
                ),
              ),

              // WebView
              Expanded(
                child: Stack(
                  children: [
                    if (_hasController)
                      WebViewWidget(
                        controller: _webViewController!,
                        gestureRecognizers: _gestureRecognizers,
                      )
                    else
                      const SizedBox.shrink(),
                    if (_isLoading) const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),

              // Marquee
              Container(
                height: 4.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Marquee(
                  text: '💳 Travelogue – Thanh toán bảo mật với PayOS',
                  style: TextStyle(fontSize: 13.sp, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                  velocity: 30,
                ),
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownClock() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 20),
          SizedBox(width: 2.w),
          Text(
            _formatDuration(_remaining),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

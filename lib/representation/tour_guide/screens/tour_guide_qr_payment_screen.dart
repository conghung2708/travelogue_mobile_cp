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
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/payment_success_sreen.dart';

class TourGuideQrPaymentScreen extends StatefulWidget {
  static const String routeName = '/guide-qr-payment';

  final TourGuideModel guide;
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;
  final DateTime startTime;
  final String? paymentUrl;

  const TourGuideQrPaymentScreen({
    super.key,
    required this.guide,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
    required this.startTime,
    this.paymentUrl,
  });

  @override
  State<TourGuideQrPaymentScreen> createState() =>
      _TourGuideQrPaymentScreenState();
}

class _TourGuideQrPaymentScreenState extends State<TourGuideQrPaymentScreen> {
  late final WebViewController _webViewController;
  final _gestureRecognizers = {
    Factory(() => EagerGestureRecognizer()),
  };

  Duration _remaining = const Duration(minutes: 5);
  late Timer _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final elapsed = DateTime.now().difference(widget.startTime);
    _remaining = Duration(minutes: 5) - elapsed;
    if (_remaining.isNegative) _remaining = Duration.zero;

    _startCountdown();

    if (widget.paymentUrl != null) {
      _loadWebViewFromUrl(widget.paymentUrl!);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        timer.cancel();
        _onCountdownFinished();
      }
    });
  }

  void _loadWebViewFromUrl(String url) {
    final uri = Uri.parse(url);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _isLoading = false),
        onPageStarted: (_) => setState(() => _isLoading = true),
        onNavigationRequest: (request) {
          final url = request.url;
          if (url.contains("status=PAID")) {
            _completePayment();
            return NavigationDecision.prevent;
          } else if (url.contains("status=CANCELLED")) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName,
                (route) => false,
              );
              AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 1));
            });
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ));

    if (_webViewController.platform is WebKitWebViewController) {
      (_webViewController.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    setState(() => _isLoading = true);
  }

//  void _completePayment() {
//   Navigator.of(context).pushAndRemoveUntil(
//     MaterialPageRoute(
//       builder: (_) => const PaymentSuccessScreen(fromGuide: true),
//     ),
//     (route) => false,
//   );
// }

  void _completePayment() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.routeName,
      (route) => false,
    );
    AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 1));
  }

  void _onCountdownFinished() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hết thời gian"),
        content: const Text("Thời gian thanh toán đã hết. Vui lòng quay lại."),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("Quay lại"),
          ),
        ],
      ),
    );
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
      AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: 1));
    }

    return false;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final price = widget.guide.price != null
        ? currency.format(widget.guide.price)
        : "Không rõ";
    final name = widget.guide.userName ?? "Hướng dẫn viên";

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  gradient: Gradients.defaultGradientBackground,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
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
                    Text('Thanh toán hướng dẫn viên',
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 0.6.h),
                    Text('$name – $price/ngày',
                        style:
                            TextStyle(fontSize: 15.sp, color: Colors.white70)),
                    SizedBox(height: 1.h),
                    _buildCountdownClock(),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: _webViewController,
                      gestureRecognizers: _gestureRecognizers,
                    ),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              Container(
                height: 4.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Marquee(
                  text: '💳 Travelogue – Thanh toán bảo mật với PayOS',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500),
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

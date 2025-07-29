import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';

class TourQrPaymentScreen extends StatefulWidget {
  static const routeName = '/tour-qr-payment';

  final TourModel tour;
  final TourScheduleModel schedule;
  final DateTime departureDate;
  final int adults;
  final int children;
  final double totalPrice;
    final DateTime startTime;

  const TourQrPaymentScreen({
    super.key,
    required this.tour,
    required this.schedule,
    required this.departureDate,
    required this.adults,
    required this.children,
    required this.totalPrice,
       required this.startTime, 
  });

  @override
  State<TourQrPaymentScreen> createState() => _TourQrPaymentScreenState();
}

class _TourQrPaymentScreenState extends State<TourQrPaymentScreen> {
  late Timer _timer;
  Duration _remaining = const Duration(minutes: 5);

@override
void initState() {
  super.initState();

  final elapsed = DateTime.now().difference(widget.startTime);
  final remaining = Duration(minutes: 5) - elapsed;

  _remaining = remaining > Duration.zero ? remaining : Duration.zero;
  print('[⏱] Received startTime: ${widget.startTime}');
print('[⏱] Now: ${DateTime.now()}');
print('[⏱] Elapsed: ${DateTime.now().difference(widget.startTime)}');

  _startCountdown();
}

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        _onCountdownFinished();
      }
    });
  }

  void _onCountdownFinished() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hết thời gian"),
        content: const Text("Mã QR đã hết hiệu lực. Vui lòng thử lại."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("Quay lại"),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

Future<bool> _onWillPop() async {
  final shouldLeave = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Travel
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.primaryColor.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.explore_rounded,
                size: 36,
                color: ColorPalette.primaryColor,
              ),
            ),
            SizedBox(height: 2.5.h),

            // Title
            Text(
              "Bạn muốn quay lại?",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: ColorPalette.text1Color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.2.h),

            // Subtitle
            Text(
              "Chuyến đi lý tưởng đang chờ bạn khởi hành 🌍\nChỉ còn một bước nữa để hoàn tất đặt chỗ.",
              style: TextStyle(
                fontSize: 13.5.sp,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Nút hành động
            Column(
              children: [
                // Nút Gradient – Quay lại sau
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const TourScreen(),
                            settings: RouteSettings(arguments: {
                              'pendingPayment': true,
                              'tour': widget.tour.toJson(),
                              'schedule': widget.schedule.toJson(),
                              'departureDate': widget.departureDate.toIso8601String(),
                              'adults': widget.adults,
                              'children': widget.children,
                              'totalPrice': widget.totalPrice,
                              'startTime': widget.startTime.toIso8601String(), 
                            }),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.4.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Quay lại sau"),
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),

                // Nút phụ - Ở lại
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 1.3.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Tiếp tục thanh toán"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return shouldLeave ?? false;
}



  void _completePayment() {

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const TourScreen(),
        settings: const RouteSettings(arguments: {'justBooked': true}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaUrl = widget.tour.mediaList.firstOrNull?.mediaUrl;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(currencyFormat, mediaUrl),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Column(
                    children: [
                      _buildQrCard(),
                      SizedBox(height: 1.5.h),
                      _buildCountdownClock(),
                      SizedBox(height: 2.h),
                      _buildMarquee(),
                      SizedBox(height: 3.h),
                      _buildConfirmationText(),
                      SizedBox(height: 3.h),
                      _buildSecureBox(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 3.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _completePayment,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Hoàn tất thanh toán'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(NumberFormat currencyFormat, String? mediaUrl) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 33.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: mediaUrl != null && mediaUrl.startsWith('http')
                  ? NetworkImage(mediaUrl)
                  : const AssetImage(AssetHelper.img_tay_ninh_login) as ImageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: 2.5.h, left: 4.w, right: 4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final confirmed = await _onWillPop();
                        if (confirmed) {
                          // handled inside _onWillPop
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
                Icon(Icons.qr_code_2_rounded, size: 40.sp, color: Colors.white),
                SizedBox(height: 1.h),
                Text(
                  'Quét mã để thanh toán',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 0.8.h),
                Text(widget.tour.name ?? '', style: TextStyle(fontSize: 15.sp, color: Colors.white70)),
                SizedBox(height: 0.6.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                    children: [
                      const TextSpan(text: 'Giá tour: ', style: TextStyle(color: Colors.white70)),
                      TextSpan(
                        text: currencyFormat.format(widget.totalPrice),
                        style: TextStyle(color: Colors.amber.shade100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.lightBlue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Image.asset(
        AssetHelper.img_qr_code,
        width: 60.w,
        height: 60.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCountdownClock() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_rounded, size: 20, color: Colors.blueAccent),
          SizedBox(width: 2.w),
          Text(
            _formatDuration(_remaining),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: _remaining.inMinutes < 1 ? Colors.redAccent : Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarquee() {
    return SizedBox(
      height: 4.h,
      child: Marquee(
        text: '💳 Travelogue – Hành trình an tâm & thanh toán bảo mật 💙     ',
        style: TextStyle(fontSize: 14.sp, color: Colors.blueAccent, fontWeight: FontWeight.w500),
        scrollAxis: Axis.horizontal,
        blankSpace: 20,
        velocity: 30,
      ),
    );
  }

  Widget _buildConfirmationText() {
    return Text(
      'Sau khi thanh toán thành công, bạn sẽ nhận được xác nhận từ Travelogue qua email hoặc tin nhắn.',
      style: TextStyle(fontSize: 14.sp, height: 1.6, color: Colors.blueGrey.shade700),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSecureBox() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightBlue.shade100),
        boxShadow: [
          BoxShadow(color: Colors.blue.shade50, blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Colors.green, size: 30),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Travelogue cam kết bảo mật thông tin thanh toán và hỗ trợ bạn mọi lúc.',
              style: TextStyle(fontSize: 14.sp, color: Colors.blueGrey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

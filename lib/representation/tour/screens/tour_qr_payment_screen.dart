import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';

class TourQrPaymentScreen extends StatefulWidget {
  static const routeName = '/tour-qr-payment';

  final double price;
  final String tourName;

  const TourQrPaymentScreen({
    super.key,
    required this.price,
    required this.tourName,
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
        content: const Text("Mã QR đã hết hiệu lực. Vui lòng tải lại trang."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, currencyFormat),
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
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      TourScreen.routeName,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  label: const Text('Quay về'),
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
    );
  }

  Widget _buildHeader(BuildContext context, NumberFormat currencyFormat) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 2.h, bottom: 2.5.h, left: 4.w, right: 4.w),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
          Icon(Icons.qr_code_2_rounded, size: 40.sp, color: Colors.white),
          SizedBox(height: 1.h),
          Text(
            'Quét mã để thanh toán',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 0.8.h),
          Text(
            widget.tourName,
            style: TextStyle(fontSize: 15.sp, color: Colors.white70),
          ),
          SizedBox(height: 0.6.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                    text: 'Giá tour: ',
                    style: TextStyle(color: Colors.white70)),
                TextSpan(
                  text: currencyFormat.format(widget.price),
                  style: TextStyle(color: Colors.amber.shade100),
                ),
              ],
            ),
          ),
        ],
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
            '$_formattedTimeLeft',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: _remaining.inMinutes < 1
                  ? Colors.redAccent
                  : Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  String get _formattedTimeLeft {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(_remaining.inMinutes)}:${twoDigits(_remaining.inSeconds % 60)}';
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

  Widget _buildMarquee() {
    return SizedBox(
      height: 4.h,
      child: Marquee(
        text: '💳 Travelogue – Hành trình an tâm & thanh toán bảo mật 💙     ',
        style: TextStyle(
            fontSize: 14.sp,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500),
        scrollAxis: Axis.horizontal,
        blankSpace: 20,
        velocity: 30,
      ),
    );
  }

  Widget _buildConfirmationText() {
    return Text(
      'Sau khi thanh toán thành công, bạn sẽ nhận được xác nhận từ Travelogue qua email hoặc tin nhắn.',
      style: TextStyle(
          fontSize: 14.sp, height: 1.6, color: Colors.blueGrey.shade700),
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
          BoxShadow(
              color: Colors.blue.shade50,
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Colors.green, size: 30),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Travelogue cam kết bảo mật thông tin thanh toán và hỗ trợ bạn mọi lúc.',
              style:
                  TextStyle(fontSize: 14.sp, color: Colors.blueGrey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

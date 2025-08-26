// lib/representation/tour/widgets/confirm_payment_button.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';

class ConfirmPaymentButton extends StatefulWidget {
  final bool enabled;
  final TourModel tour;
  final TourScheduleModel schedule;
  final DateTime? startTime;
  final int adults;
  final int children;
  final String? bookingId;
  final String? media;


  final ({CreateBookingTourModel? model, String? error}) Function()? payloadBuilder;

  const ConfirmPaymentButton({
    super.key,
    required this.enabled,
    required this.tour,
    required this.schedule,
    required this.startTime,
    required this.adults,
    required this.children,
    required this.bookingId,
    required this.media,
    this.payloadBuilder,
  });

  @override
  State<ConfirmPaymentButton> createState() => _ConfirmPaymentButtonState();
}

class _ConfirmPaymentButtonState extends State<ConfirmPaymentButton> {
  bool _loading = false;

  Future<void> _handleConfirm(BuildContext context) async {
    if (!widget.enabled || _loading) return;

    setState(() => _loading = true);
    try {
      String? bookingId = widget.bookingId;

      // 1) Chưa có booking → tạo mới bằng payloadBuilder
      if (bookingId == null) {
        final res = widget.payloadBuilder?.call();
        if (res == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không thể chuẩn bị dữ liệu đặt chỗ.')),
            );
          }
          return;
        }
        if (res.error != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(res.error!)),
            );
          }
          return;
        }

        final model = res.model!;
        final booking = await BookingRepository().createBooking(model);
        if (booking == null || booking.id == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo booking thất bại.')),
            );
          }
          return;
        }
        bookingId = booking.id;
      }

      // 2) Tạo link thanh toán
      final paymentUrl = await BookingRepository().createPaymentLink(bookingId);
      if (paymentUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo liên kết thanh toán thất bại.')),
          );
        }
        return;
      }

      // 3) Điều hướng sang màn QR
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TourQrPaymentScreen(
            tour: widget.tour,
            schedule: widget.schedule,
            startTime: widget.startTime ?? DateTime.now(),
            adults: widget.adults,
            children: widget.children,
            totalPrice: (widget.adults * (widget.schedule.adultPrice ?? 0)) +
                (widget.children * (widget.schedule.childrenPrice ?? 0)),
            checkoutUrl: paymentUrl,
            bookingId: bookingId,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (!widget.enabled || _loading) ? null : () => _handleConfirm(context),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          backgroundColor: ColorPalette.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _loading
            ? SizedBox(
                height: 2.4.h,
                width: 2.4.h,
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                "Xác nhận và thanh toán",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.white),
              ),
      ),
    );
  }
}

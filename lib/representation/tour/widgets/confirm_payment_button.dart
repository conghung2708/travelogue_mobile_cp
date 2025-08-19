// lib/features/tour/presentation/widgets/confirm_payment_button.dart
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
  });

  @override
  State<ConfirmPaymentButton> createState() => _ConfirmPaymentButtonState();
}

class _ConfirmPaymentButtonState extends State<ConfirmPaymentButton> {
  bool _loading = false;

  Future<void> _handleConfirm(BuildContext context) async {
    setState(() => _loading = true);

    try {
      String? bookingId = widget.bookingId;

      if (bookingId == null) {
        final booking = await BookingRepository().createBooking(
          CreateBookingTourModel(
            tourId: widget.tour.tourId!,
            scheduledId: widget.schedule.scheduleId!,
            promotionCode: null,
            adultCount: widget.adults,
            childrenCount: widget.children,
          ),
        );

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

      final paymentUrl = await BookingRepository().createPaymentLink(bookingId);
      if (paymentUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo liên kết thanh toán thất bại.')),
          );
        }
        return;
      }

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
            totalPrice: (widget.adults * (widget.schedule.adultPrice ?? 0).toDouble()) +
                (widget.children * (widget.schedule.childrenPrice ?? 0).toDouble()),
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
            ? SizedBox(height: 2.4.h, width: 2.4.h, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                "Xác nhận và thanh toán",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.white),
              ),
      ),
    );
  }
}

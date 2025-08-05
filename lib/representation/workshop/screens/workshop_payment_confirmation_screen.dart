import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_qr_payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopPaymentConfirmationScreen extends StatefulWidget {
  final WorkshopDetailModel workshop;
  final ScheduleModel schedule;
  final int adults;
  final int children;

  const WorkshopPaymentConfirmationScreen({
    super.key,
    required this.workshop,
    required this.schedule,
    this.adults = 1,
    this.children = 0,
  });

  @override
  State<WorkshopPaymentConfirmationScreen> createState() =>
      _WorkshopPaymentConfirmationScreenState();
}

class _WorkshopPaymentConfirmationScreenState
    extends State<WorkshopPaymentConfirmationScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final double adultPrice = widget.schedule.adultPrice ?? 0;
    final double childrenPrice = widget.schedule.childrenPrice ?? 0;
    final double adultTotal = widget.adults * adultPrice;
    final double childrenTotal = widget.children * childrenPrice;
    final double totalPrice = adultTotal + childrenTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWorkshopInfoCard(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: ColorPalette.dividerColor, thickness: 6.sp),
                    _buildPaymentSummary(
                        formatter, totalPrice, adultTotal, childrenTotal),
                    SizedBox(height: 2.h),
                    const Text(
                      '📘 Điều khoản & Trách nhiệm dịch vụ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildPolicyMarkdown(),
                    SizedBox(height: 1.5.h),
                    _buildAgreementCheckbox(),
                    _buildSupportButton(),
                    SizedBox(height: 2.h),
                    _buildConfirmButton(totalPrice),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              children: [
                Text('Thông tin thanh toán',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 0.5.h),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'vi_VN')
                      .format(widget.schedule.startTime ?? DateTime.now()),
                  style: TextStyle(fontSize: 15.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(width: 25.sp),
        ],
      ),
    );
  }

  Widget _buildWorkshopInfoCard() {
    final img = widget.schedule.imageUrl ??
        (widget.workshop.imageList?.isNotEmpty == true
            ? widget.workshop.imageList!.first
            : AssetHelper.img_default);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 24.w,
              height: 10.h,
              child: img.startsWith('http')
                  ? Image.network(img, fit: BoxFit.cover)
                  : Image.asset(img, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workshop.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkshopDetailScreen(
                          workshopId: widget.workshop.workshopId ?? '',
                          selectedScheduleId: widget.schedule.scheduleId,
                          readOnly: true,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Xem chi tiết",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(NumberFormat formatter, double totalPrice,
      double adultTotal, double childrenTotal) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: Colors.deepOrange),
              SizedBox(width: 2.w),
              Text('Chi tiết thanh toán',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700)),
            ],
          ),
          SizedBox(height: 1.5.h),
          _buildPriceRow(
              '👨 Người lớn', widget.adults, widget.schedule.adultPrice ?? 0),
          SizedBox(height: 0.6.h),
          _buildPriceRow(
              '🧒 Trẻ em', widget.children, widget.schedule.childrenPrice ?? 0),
          Divider(height: 2.5.h, color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('💰 Tổng cộng:',
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade900)),
              Text('${formatter.format(totalPrice)}đ',
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int quantity, double price) {
    final formatter = NumberFormat('#,###');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label x$quantity',
            style: TextStyle(fontSize: 13.5.sp, color: Colors.brown.shade800)),
        Text('${formatter.format(quantity * price)}đ',
            style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildPolicyMarkdown() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const MarkdownBody(
        data: '''
🚩 **Cam kết dịch vụ Workshop Travelogue**

✅ **Không hoàn hủy đặt chỗ** sau khi thanh toán *(trừ khi có lý do đặc biệt được xác nhận)*.

✅ Đến đúng giờ theo lịch đã chọn.

✅ **Tuân thủ tuyệt đối** hướng dẫn của nghệ nhân & nhân viên hỗ trợ.

✅ Mặc trang phục **thoải mái, lịch sự**, phù hợp với hoạt động thủ công.

✅ Giữ gìn vệ sinh, không gây ồn ào, bảo vệ môi trường làng nghề.

✨ *Travelogue hân hạnh đồng hành cùng bạn trong hành trình trải nghiệm văn hoá làng nghề.* ✨
''',
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreed,
          onChanged: (value) => setState(() => _agreed = value ?? false),
        ),
        Expanded(
          child: Text(
            'Tôi đã đọc và đồng ý với các điều khoản cam kết dịch vụ ở trên.',
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await _showCallSupportDialog(context);
          if (confirmed == true) {
            final Uri callUri = Uri(scheme: 'tel', path: '0336626193');
            if (await canLaunchUrl(callUri)) {
              await launchUrl(callUri);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
              );
            }
          }
        },
        icon: const Icon(Icons.headset_mic, color: Colors.blue),
        label: Text(
          'Liên hệ hỗ trợ',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blue),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(double totalPrice) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _agreed
            ? () async {
                String? bookingId;

                // Gọi API tạo booking workshop
                final booking = await BookingRepository().createWorkshopBooking(
                  workshopId: widget.workshop.workshopId ?? '',
                  workshopScheduleId: widget.schedule.scheduleId ?? '',
                  promotionCode: null,
                  adultCount: widget.adults,
                  childrenCount: widget.children,
                );

                if (booking == null || booking.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tạo booking thất bại.')),
                  );
                  return;
                }

                bookingId = booking.id;

                // Gọi API tạo payment link
                final paymentUrl =
                    await BookingRepository().createPaymentLink(bookingId);

                if (paymentUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkshopQrPaymentScreen(
                        workshop: widget.workshop,
                        schedule: widget.schedule,
                        adults: widget.adults,
                        children: widget.children,
                        totalPrice: totalPrice,
                        startTime: DateTime.now(),
                        checkoutUrl: paymentUrl,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tạo liên kết thanh toán thất bại.')),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          backgroundColor: ColorPalette.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          "Xác nhận và thanh toán",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool?> _showCallSupportDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.headset_mic,
                    color: Colors.blueAccent, size: 28.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                "Gọi hỗ trợ từ Travelogue?",
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.2.h),
              Text(
                "Bạn có muốn gọi ngay cho chúng tôi qua số 0336 626 193 để được tư vấn & hỗ trợ nhanh chóng?",
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        child: Text("Huỷ", style: TextStyle(fontSize: 13.5.sp)),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                      child: Text("Gọi ngay",
                          style: TextStyle(
                              fontSize: 13.5.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

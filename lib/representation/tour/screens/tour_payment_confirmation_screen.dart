import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/discount_tag.dart';
import 'package:url_launcher/url_launcher.dart';

class TourPaymentConfirmationScreen extends StatefulWidget {
  static const routeName = '/tour-payment-confirmation';

  final TourModel tour;
  final TourScheduleModel schedule;
  final String? media;
  final DateTime? departureDate;
  final int adults;
  final int children;

  const TourPaymentConfirmationScreen({
    super.key,
    required this.tour,
    required this.schedule,
    this.media,
    this.departureDate,
    this.adults = 1,
    this.children = 0,
  });

  @override
  State<TourPaymentConfirmationScreen> createState() =>
      _TourPaymentConfirmationScreenState();
}

class _TourPaymentConfirmationScreenState
    extends State<TourPaymentConfirmationScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final mediaUrl = widget.media;
    final double adultPrice = widget.schedule.adultPrice?.toDouble() ?? 0;
    final double childrenPrice = widget.schedule.childrenPrice?.toDouble() ?? 0;

    final double adultTotal = widget.adults * adultPrice;
    final double childrenTotal = widget.children * childrenPrice;
    final double totalPrice = adultTotal + childrenTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTourInfoCard(mediaUrl),
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
                    const TitleWithCustoneUnderline(
                      text: '📘 Điều khoản & ',
                      text2: 'Trách nhiệm dịch vụ',
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
                Text(
                  'Thông tin thanh toán',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'vi_VN')
                      .format(widget.departureDate ?? DateTime.now()),
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

  Widget _buildTourInfoCard(String? mediaUrl) {
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 24.w,
                  height: 10.h,
                  child: mediaUrl != null && mediaUrl.startsWith('http')
                      ? Image.network(mediaUrl, fit: BoxFit.cover)
                      : Image.asset(mediaUrl ?? AssetHelper.img_tay_ninh_login,
                          fit: BoxFit.cover),
                ),
              ),
              if (widget.tour.isDiscount == true)
                const Positioned(top: 0, left: 0, child: DiscountTag()),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🇻🇳 Tây Ninh, Việt Nam',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.shade600)),
                SizedBox(height: 0.5.h),
                Text(
                  widget.tour.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailScreen(
                          tour: widget.tour,
                          image: widget.media ?? AssetHelper.img_tay_ninh_login,
                          readOnly: true,
                          departureDate: widget.departureDate,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text('Xem chi tiết',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                      SizedBox(width: 1.w),
                      Icon(Icons.arrow_forward_ios,
                          size: 14.sp, color: Colors.green),
                    ],
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
🚩 **Cam kết dịch vụ của Travelogue**

✅ **Không hoàn hủy vé** sau khi thanh toán *(trừ khi có lý do đặc biệt được xác nhận)*.

✅ Mang theo **CMND/CCCD hoặc hộ chiếu** để xác minh danh tính.

✅ **Tuân thủ tuyệt đối** hướng dẫn trưởng đoàn và nhân viên hỗ trợ.

✅ Mặc trang phục **lịch sự, kín đáo** phù hợp văn hoá điểm đến.

✅ **Không xả rác**, giữ vệ sinh và không gây ồn ào nơi công cộng.

✅ Nếu không khoẻ, **báo ngay hướng dẫn viên** để được hỗ trợ kịp thời.

✨ *Chúng tôi vinh dự được đồng hành cùng bạn trong hành trình đầy ý nghĩa này. Cảm ơn bạn đã tin tưởng Travelogue!* ✨
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
        label: Text('Liên hệ hỗ trợ',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600)),
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
            ? () {
                print('🧪 tour: ${widget.tour}');
                print('🧪 schedule: ${widget.schedule}');
                print('🧪 departureDate: ${widget.departureDate}');
                print('🧪 adults: ${widget.adults}');
                print('🧪 children: ${widget.children}');

                Navigator.pushNamed(
                  context,
                  TourQrPaymentScreen.routeName,
                  arguments: {
                    'tour': widget.tour,
                    'schedule': widget.schedule,
                    'departureDate': widget.departureDate!,
                    'adults': widget.adults,
                    'children': widget.children,
                    'totalPrice': totalPrice,
                    'startTime': DateTime.now(),
                  },
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          backgroundColor: ColorPalette.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text("Xác nhận và thanh toán",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Colors.white)),
      ),
    );
  }
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
                  color: Colors.blue.shade50, shape: BoxShape.circle),
              child: Icon(Icons.headset_mic,
                  color: Colors.blueAccent, size: 28.sp),
            ),
            SizedBox(height: 2.h),
            Text("Gọi hỗ trợ từ Travelogue?",
                style: TextStyle(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800),
                textAlign: TextAlign.center),
            SizedBox(height: 1.2.h),
            Text(
                "Bạn có muốn gọi ngay cho chúng tôi qua số 0336 626 193 để được tư vấn & hỗ trợ nhanh chóng?",
                style: TextStyle(
                    fontSize: 13.sp, height: 1.5, color: Colors.grey.shade700),
                textAlign: TextAlign.center),
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
                        child:
                            Text("Huỷ", style: TextStyle(fontSize: 13.5.sp))),
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
                        style:
                            TextStyle(fontSize: 13.5.sp, color: Colors.white)),
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

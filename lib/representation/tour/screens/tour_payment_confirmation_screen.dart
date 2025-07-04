import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TourPaymentConfirmationScreen extends StatefulWidget {
  static const routeName = '/tour-payment-confirmation';

  final TourTestModel tour;
  final TourScheduleWithPrice schedule;
  final TourMediaTestModel? media;
  final DateTime? departureDate;

  const TourPaymentConfirmationScreen({
    super.key,
    required this.tour,
    required this.schedule,
    this.media,
    this.departureDate,
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
    final mediaUrl = widget.media?.mediaUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 2.h),
              decoration: const BoxDecoration(
                gradient: Gradients.defaultGradientBackground,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Thông tin thanh toán',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              DateFormat('EEEE, dd MMMM yyyy', 'vi_VN')
                                  .format(widget.schedule.departureDate),
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 25.sp),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
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
                      child: mediaUrl != null && mediaUrl.startsWith('http')
                          ? Image.network(mediaUrl, fit: BoxFit.cover)
                          : Image.asset(
                              mediaUrl ?? AssetHelper.img_tay_ninh_login,
                              fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🇻🇳 Tây Ninh, Việt Nam',
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.tour.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () {
                            TourPlanVersionTestModel? version;
                            try {
                              version = mockTourPlanVersions.firstWhere(
                                (v) => v.id == widget.tour.currentVersionId,
                              );
                            } catch (_) {
                              version = null;
                            }

                            TourGuideTestModel? guide;
                            try {
                              if (version?.tourGuideId != null) {
                                guide = mockTourGuides.firstWhere(
                                  (g) => g.id == version!.tourGuideId,
                                );
                              }
                            } catch (_) {
                              guide = null;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TourDetailScreen(
                                  tour: widget.tour,
                                  media: widget.media,
                                  guide: guide,
                                  readOnly: true,
                                   departureDate: widget.schedule.departureDate,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: ColorPalette.dividerColor, thickness: 6.sp),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.red),
                        SizedBox(width: 2.w),
                        Text('Giá vé hiện tại:',
                            style: TextStyle(fontSize: 14.sp)),
                        const Spacer(),
                        Text(
                          '${formatter.format(widget.schedule.price)} VND',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    const TitleWithCustoneUnderline(
                      text: '📘 Điều khoản & ',
                      text2: 'Trách nhiệm dịch vụ',
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: MarkdownBody(
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
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(Theme.of(context))
                                .copyWith(
                          p: TextStyle(fontSize: 13.sp, height: 1.6),
                          strong: const TextStyle(fontWeight: FontWeight.bold),
                          em: const TextStyle(fontStyle: FontStyle.italic),
                          blockSpacing: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (value) {
                            setState(() => _agreed = value ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Tôi đã đọc và đồng ý với các điều khoản cam kết dịch vụ ở trên.',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirmed =
                              await _showCallSupportDialog(context);
                          if (confirmed == true) {
                            final Uri callUri =
                                Uri(scheme: 'tel', path: '0336626193');
                            if (await canLaunchUrl(callUri)) {
                              await launchUrl(callUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Không thể thực hiện cuộc gọi.')),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _agreed
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  TourQrPaymentScreen.routeName,
                                  arguments: {
                                    'price': widget.schedule.price,
                                    'tourName': widget.tour.name,
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.8.h),
                          backgroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                    ),
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
}

Future<bool?> _showCallSupportDialog(BuildContext context) {
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
                  fontSize: 13.sp, height: 1.5, color: Colors.grey.shade700),
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

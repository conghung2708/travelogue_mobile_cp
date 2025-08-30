import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

class TourConfirmedActionCard extends StatelessWidget {
  final TourModel tour;
  final NumberFormat currencyFormat;
  final DateTime? startTime;

  /// Nếu muốn ghi đè giá từ ngoài; nếu null sẽ dùng tour.adultPrice / tour.childrenPrice
  final double? adultPriceOverride;
  final double? childPriceOverride;

  final VoidCallback? onConfirmed;
  final bool? readOnly;
  final bool? isBooked;

  const TourConfirmedActionCard({
    super.key,
    required this.tour,
    required this.currencyFormat,
    this.startTime,
    this.adultPriceOverride,
    this.childPriceOverride,
    this.onConfirmed,
    this.readOnly = false,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    final String tripDate =
        startTime != null ? DateFormat('dd/MM/yyyy').format(startTime!) : 'Chưa chọn ngày';

    // Lấy giá từ override hoặc từ tour
    final double? adultPrice =
        adultPriceOverride ?? (tour.adultPrice is num ? tour.adultPrice!.toDouble() : null);
    final double? childPrice =
        childPriceOverride ?? (tour.childrenPrice is num ? tour.childrenPrice!.toDouble() : null);

    final bool isViewingOnly = readOnly == true;
    final bool hasBeenBooked = isBooked == true;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.25),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 18.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  hasBeenBooked ? "Tour đã được đặt" : "Tour đã sẵn sàng để đặt",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),

          // Date
          Row(
            children: [
              Icon(Icons.event_note, size: 14.sp, color: Colors.blueGrey),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  'Khởi hành: $tripDate',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.6.h),

          // ===== HỮU ÍCH: Chỉ hiện GIÁ + CTA khi có thể đặt
          if (!isViewingOnly && !hasBeenBooked) ...[
            _priceSection(
              adultPrice: adultPrice,
              childPrice: childPrice,
              fmt: currencyFormat,
            ),
            SizedBox(height: 2.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.schedule_send, color: Colors.white),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => _buildConfirmDialog(context),
                  );
                  if (confirmed == true && onConfirmed != null) {
                    onConfirmed!();
                  }
                },
                label: Text(
                  'ĐẶT TOUR NGAY',
                  style: TextStyle(fontSize: 13.5.sp, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ] else
            _buildBookedMessage(context, hasBeenBooked),
        ],
      ),
    );
  }

  // ==================== SUB-WIDGETS ====================

  /// Chip giá: tệp màu với container ngoài của _priceSection
  Widget _priceChip({
    required String value,
    required String label,
    required bool isAdult,
  }) {
    const Color baseBg = Color(0xFFF7FAFF);
    const Color baseBorder = Color(0xFFE3F0FF);
    const Color brand = Color(0xFF1E6BFF);

    final Color textMain = isAdult ? brand : Colors.blueGrey.shade800;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: baseBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAdult ? brand.withOpacity(.28) : baseBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isAdult ? Icons.person : Icons.child_care, size: 12.5.sp, color: textMain),
          SizedBox(width: 1.4.w),
          Text(
            value,
            style: TextStyle(
              color: textMain,
              fontWeight: FontWeight.w800,
              fontSize: 13.2.sp,
              letterSpacing: .1,
            ),
          ),
          Text(
            '  / $label',
            style: TextStyle(
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 11.6.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Price section: accent bar + tiêu đề + chip giá + ghi chú
  Widget _priceSection({
    required double? adultPrice,
    required double? childPrice,
    required NumberFormat fmt,
  }) {
    final hasAdult = adultPrice != null && adultPrice > 0;
    final hasChild = childPrice != null && childPrice > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3F0FF)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent bar
          Container(
            width: 4,
            height: hasChild ? 5.0.h : 3.2.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [Color(0xFF6EA8FE), Color(0xFF1E6BFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(width: 3.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề rõ ràng: GIÁ TOUR
                Row(
                  children: [
                    Icon(Icons.price_change_rounded, size: 14.sp, color: const Color(0xFF1E6BFF)),
                    SizedBox(width: 1.6.w),
                    Text(
                      'Giá tour',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 0.8.h),

                // Chip giá
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: [
                    if (hasAdult)
                      _priceChip(
                        value: fmt.format(adultPrice),
                        label: 'người lớn',
                        isAdult: true,
                      ),
                    if (hasChild)
                      _priceChip(
                        value: fmt.format(childPrice),
                        label: 'trẻ em',
                        isAdult: false,
                      ),
                    if (!hasAdult && !hasChild)
                      Text(
                        'Giá sẽ cập nhật khi có lịch khởi hành',
                        style: TextStyle(
                          fontSize: 12.2.sp,
                          color: Colors.blueGrey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),

                // Ghi chú ngắn gọn
                if (hasAdult || hasChild) ...[
                  SizedBox(height: 0.6.h),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 11.5.sp, color: Colors.blueGrey.shade500),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          'Mức giá áp dụng trên mỗi hành khách.',
                          style: TextStyle(
                            fontSize: 10.8.sp,
                            color: Colors.blueGrey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmDialog(BuildContext context) {
    return Dialog(
      elevation: 10,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3FF),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(3.w),
              child: Icon(Icons.rocket_launch_rounded, size: 28.sp, color: Colors.blueAccent),
            ),
            SizedBox(height: 2.h),
            Text(
              "Đặt tour ngay bây giờ?",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.5.h),
            Text(
              "Tour của bạn đã sẵn sàng. Xác nhận để chọn ngày và đặt lịch trình.",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.5.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      child: Text(
                        "Để sau",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookedMessage(BuildContext context, bool hasBeenBooked) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF91C9F7), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasBeenBooked
                ? '✅ Tour của bạn đã được đặt thành công!'
                : '🌏 Hành trình của bạn đang chờ đợi!',
            style: TextStyle(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2979FF),
            ),
          ),
          SizedBox(height: 1.2.h),
          Text(
            hasBeenBooked
                ? 'Chúng tôi đã ghi nhận lịch trình của bạn. Hẹn gặp bạn trong hành trình sắp tới!'
                : 'Chỉ một bước nữa, Travelogue hân hạnh đồng hành cùng bạn trên hành trình đầy cảm xúc và khám phá.',
            style: TextStyle(
              fontSize: 12.5.sp,
              color: Colors.blueGrey.shade800,
              height: 1.45,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            hasBeenBooked
                ? '🎉 Cảm ơn bạn đã chọn Travelogue!'
                : '📌 Từ khung cảnh mê hồn đến ẩm thực đặc sắc – mọi trải nghiệm đáng nhớ đang chờ đón bạn.',
            style: TextStyle(
              fontSize: 12.5.sp,
              color: Colors.blueGrey.shade800,
              height: 1.4,
            ),
          ),
          if (!hasBeenBooked) SizedBox(height: 2.h),
          if (!hasBeenBooked)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: Gradients.defaultGradientBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: Text(
                    "Quay lại đặt tour ngay",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

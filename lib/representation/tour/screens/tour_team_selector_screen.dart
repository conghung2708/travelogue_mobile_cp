import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/discount_tag.dart';

class TourTeamSelectorScreen extends StatefulWidget {
  static const String routeName = '/tour-team-selector';

  final TourTestModel tour;
  final TourScheduleWithPrice schedule;
  final TourMediaTestModel? media;

  const TourTeamSelectorScreen({
    super.key,
    required this.tour,
    required this.schedule,
    this.media,
  });

  @override
  State<TourTeamSelectorScreen> createState() => _TourTeamSelectorScreenState();
}

class _TourTeamSelectorScreenState extends State<TourTeamSelectorScreen> {
  int adultCount = 1;
  int childrenCount = 0;
  final formatter = NumberFormat('#,###');

  double get totalPrice =>
      (adultCount * widget.schedule.price) +
      (childrenCount * widget.schedule.childrenPrice);

  int get totalPeople => adultCount + childrenCount;
  int get availableSlot => widget.schedule.availableSlot;
  int get remainingSlot => availableSlot - totalPeople;

  bool canAdd() => totalPeople < availableSlot;

  void _showLimitReachedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Bạn chỉ có thể chọn tối đa $availableSlot người.',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AssetHelper.img_tour_type_selector,
            fit: BoxFit.cover,
            height: 100.h,
            width: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Chọn số lượng người tham gia",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Giúp chúng tôi chuẩn bị tốt hơn cho nhóm của bạn.",
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: Colors.white70,
                    ),
                  ),
                  _buildTourSummaryCard(),
                  SizedBox(height: 1.5.h),
                  _buildCounter(
                    "Người lớn",
                    adultCount,
                    (v) => setState(() => adultCount = v),
                    widget.schedule.price,
                    isAdult: true,
                  ),
                  SizedBox(height: 1.5.h),
                  _buildCounter(
                    "Trẻ em",
                    childrenCount,
                    (v) => setState(() => childrenCount = v),
                    widget.schedule.childrenPrice,
                    isAdult: false,
                  ),
                  SizedBox(height: 1.5.h),
                  if (!canAdd())
                    Text(
                      '⚠️ Đã đạt giới hạn số người (${availableSlot})',
                      style: TextStyle(color: Colors.yellow, fontSize: 13.sp),
                    )
                  else
                    Text(
                      '👥 Bạn có thể thêm tối đa $remainingSlot người.',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                  const Spacer(),
                  _buildTotalAndButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(
    String label,
    int value,
    Function(int) onChanged,
    double unitPrice, {
    required bool isAdult,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label – ${formatter.format(unitPrice)}đ',
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
          Row(
            children: [
              _roundIconButton(
                Icons.remove,
                (isAdult && value > 1) || (!isAdult && value > 0)
                    ? () => onChanged(value - 1)
                    : null,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  '$value',
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
              ),
              _roundIconButton(
                Icons.add,
                canAdd()
                    ? () {
                        if (!canAdd()) {
                          _showLimitReachedMessage();
                        } else {
                          onChanged(value + 1);
                        }
                      }
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: onTap != null
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildTotalAndButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.attach_money_rounded, color: Colors.white),
                SizedBox(width: 2.w),
                Text(
                  "Tổng: ${formatter.format(totalPrice)}đ",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourPaymentConfirmationScreen(
                    tour: widget.tour,
                    schedule: widget.schedule,
                    media: widget.media,
                    departureDate: widget.schedule.departureDate,
                    adults: adultCount,
                    children: childrenCount,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              shadowColor: Colors.orangeAccent,
            ),
            child:
                const Text("Tiếp tục", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTourSummaryCard() {
    final schedule = widget.schedule;
    final mediaUrl = widget.media?.mediaUrl;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.95), Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 25.w,
                  height: 11.h,
                  child: mediaUrl != null && mediaUrl.startsWith('http')
                      ? Image.network(mediaUrl, fit: BoxFit.cover)
                      : Image.asset(
                          mediaUrl ?? AssetHelper.img_tay_ninh_login,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🌍 Tây Ninh, Việt Nam',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.tour.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '📅 ${DateFormat('dd/MM/yyyy').format(schedule.departureDate)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    if (schedule.isDiscount) ...[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: Gradients.defaultGradientBackground,
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.secondColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '${formatter.format(schedule.price)}đ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.4.h),
                      Text(
                        '💼 Giá gốc: ${formatter.format(schedule.adultPrice)}đ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red.shade700,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '💰 Giá tour: ${formatter.format(schedule.price)}đ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ColorPalette.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (schedule.isDiscount)
            const Positioned(
              top: 0,
              left: 0,
              child: DiscountTag(),
            ),
        ],
      ),
    );
  }
}

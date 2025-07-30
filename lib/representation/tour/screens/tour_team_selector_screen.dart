import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';

class TourTeamSelectorScreen extends StatefulWidget {
  static const String routeName = '/tour-team-selector';

  final TourModel tour;
  final TourScheduleModel schedule;
  final String media;

  const TourTeamSelectorScreen({
    super.key,
    required this.tour,
    required this.schedule,
    required this.media,
  });

  @override
  State<TourTeamSelectorScreen> createState() =>
      _TourTeamSelectorScreenState();
}

class _TourTeamSelectorScreenState extends State<TourTeamSelectorScreen> {
  int adultCount = 1;
  int childrenCount = 0;
  final formatter = NumberFormat('#,###');

  int get availableSlot =>
      (widget.schedule.maxParticipant ?? 0) - (widget.schedule.currentBooked ?? 0);
  int get totalPeople => adultCount + childrenCount;
  int get remainingSlot => availableSlot - totalPeople;
  double get totalPrice =>
      (adultCount * (widget.schedule.adultPrice ?? 0)) +
      (childrenCount * (widget.schedule.childrenPrice ?? 0));

  bool canAdd() => totalPeople < availableSlot;

  void _showLimitReachedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bạn chỉ có thể chọn tối đa $availableSlot người.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            width: double.infinity,
            height: 100.h,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  SizedBox(height: 3.h),
                  _buildTitle(),
                  _buildTourSummaryCard(),
                  SizedBox(height: 2.h),
                  _buildCounter("Người lớn", adultCount,
                      (v) => setState(() => adultCount = v),
                      widget.schedule.adultPrice ?? 0,
                      isAdult: true),
                  SizedBox(height: 1.5.h),
                  _buildCounter("Trẻ em", childrenCount,
                      (v) => setState(() => childrenCount = v),
                      widget.schedule.childrenPrice ?? 0,
                      isAdult: false),
                  SizedBox(height: 1.5.h),
                  Text(
                    canAdd()
                        ? '👥 Bạn có thể thêm tối đa $remainingSlot người.'
                        : '⚠️ Đã đạt giới hạn số người ($availableSlot)',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: canAdd() ? Colors.white70 : Colors.yellow,
                    ),
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

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Chọn số lượng người tham gia",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 1.h),
        Text("Giúp chúng tôi chuẩn bị tốt hơn cho nhóm của bạn.",
            style: TextStyle(fontSize: 12.5.sp, color: Colors.white70)),
      ],
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged,
      double unitPrice,
      {required bool isAdult}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$label – ${formatter.format(unitPrice)}đ',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white)),
              SizedBox(height: 0.5.h),
              Text(isAdult ? '(Từ 12 tuổi trở lên)' : '(Từ 1 đến dưới 12 tuổi)',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic)),
            ],
          ),
          Row(
            children: [
              _roundIconButton(
                  Icons.remove,
                  (isAdult && value > 1) || (!isAdult && value > 0)
                      ? () => onChanged(value - 1)
                      : null),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text('$value',
                    style: TextStyle(fontSize: 15.sp, color: Colors.white)),
              ),
              _roundIconButton(Icons.add, canAdd()
                  ? () {
                      if (canAdd()) {
                        onChanged(value + 1);
                      } else {
                        _showLimitReachedMessage();
                      }
                    }
                  : null),
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onTap != null
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildTotalAndButton() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.attach_money_rounded, color: Colors.white),
              SizedBox(width: 2.w),
              Text("Tổng: ${formatter.format(totalPrice)}đ",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
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
                  departureDate: widget.schedule.departureDate,
                  adults: adultCount,
                  children: childrenCount,
                  media: widget.media,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.8.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("Tiếp tục", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  Widget _buildTourSummaryCard() {
    final tour = widget.tour;
    final schedule = widget.schedule;
    final mediaUrl = widget.media;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            LinearGradient(colors: [Colors.white.withOpacity(0.95), Colors.white70]),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 25.w,
              height: 11.h,
              child: mediaUrl.startsWith('http')
                  ? Image.network(mediaUrl, fit: BoxFit.cover)
                  : Image.asset(mediaUrl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🌍 Việt Nam',
                    style:
                        TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
                SizedBox(height: 0.5.h),
                Text(tour.name ?? '',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(height: 0.5.h),
                Text('📅 ${DateFormat('dd/MM/yyyy').format(schedule.departureDate!)}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade800)),
                SizedBox(height: 0.5.h),
                Text(
                  '💰 Giá tour: ${formatter.format(schedule.adultPrice)}đ',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

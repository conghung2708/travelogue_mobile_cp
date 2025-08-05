import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_payment_confirmation_screen.dart';

class WorkshopBookingScreen extends StatefulWidget {
  final String workshopName;
  final ScheduleModel schedule;
    final WorkshopDetailModel workshop; 

  const WorkshopBookingScreen({
    super.key,
    required this.workshopName,
    required this.schedule,
    required this.workshop,
  });

  @override
  State<WorkshopBookingScreen> createState() => _WorkshopBookingScreenState();
}

class _WorkshopBookingScreenState extends State<WorkshopBookingScreen> {
  int adultCount = 1;
  int childrenCount = 0;

  int get maxSlot => widget.schedule.maxParticipant ?? 0;
  int get booked => widget.schedule.currentBooked ?? 0;
  int get available => maxSlot - booked;
  int get totalPeople => adultCount + childrenCount;
  int get remaining => available - totalPeople;

  final fmt = NumberFormat('#,###');

  double get totalPrice =>
      (adultCount * (widget.schedule.adultPrice ?? 0)) +
      (childrenCount * (widget.schedule.childrenPrice ?? 0));

  bool canAdd() => totalPeople < available;

  void _showLimitSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chỉ còn $available chỗ trống.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            _buildBackgroundImage(),
            Container(color: Colors.black.withOpacity(.55)),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _backBtn(context),
                    SizedBox(height: 3.h),
                    Text('Đặt chỗ Workshop',
                        style:
                            TextStyle(fontSize: 18.sp, color: Colors.white)),
                    SizedBox(height: 0.5.h),
                    Text(widget.workshopName,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    _summaryCard(),
                    SizedBox(height: 2.h),
                    _counter('Người lớn', adultCount, (v) {
                      setState(() => adultCount = v);
                    }, widget.schedule.adultPrice ?? 0, minAdult: 1),
                    SizedBox(height: 1.5.h),
                    _counter('Trẻ em', childrenCount, (v) {
                      setState(() => childrenCount = v);
                    }, widget.schedule.childrenPrice ?? 0, minAdult: 0),
                    SizedBox(height: 1.5.h),
                    Text(
                      remaining >= 0
                          ? '👥 Còn có thể thêm $remaining người.'
                          : '⚠️ Vượt quá số chỗ trống!',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: remaining >= 0
                              ? Colors.white70
                              : Colors.yellowAccent),
                    ),
                    const Spacer(),
                    _totalBar(),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildBackgroundImage() {
    final img = widget.schedule.imageUrl;
    if (img != null && img.isNotEmpty && img.startsWith('http')) {
      return Image.network(img,
          height: 100.h, width: double.infinity, fit: BoxFit.cover);
    }
    return Image.asset(AssetHelper.img_lang_nghe_04_04,
        height: 100.h, width: double.infinity, fit: BoxFit.cover);
  }

  Widget _backBtn(BuildContext ctx) => Align(
        alignment: Alignment.centerLeft,
        child: CircleAvatar(
          backgroundColor: Colors.white24,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
      );

  Widget _summaryCard() {
    final d = widget.schedule.startTime != null
        ? DateFormat('dd/MM/yyyy').format(widget.schedule.startTime!)
        : '';
    final t = (widget.schedule.startTime != null &&
            widget.schedule.endTime != null)
        ? '${DateFormat.Hm().format(widget.schedule.startTime!)} – ${DateFormat.Hm().format(widget.schedule.endTime!)}'
        : '';
    final note = widget.schedule.notes;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.85),
        border: Border.all(
          width: .4.w,
          color: ColorPalette.primaryColor.withOpacity(.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildScheduleImage(),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _iconText(Icons.location_on_rounded, 'Làng nghề'),
                    SizedBox(height: .6.h),
                    _iconText(Icons.calendar_month, d),
                    _iconText(Icons.schedule, t),
                    SizedBox(height: 0.5.h),
                    if (widget.schedule.adultPrice != null)
                      _iconText(Icons.person,
                          '${fmt.format(widget.schedule.adultPrice)}đ / người lớn',
                          color: Colors.orange),
                    if (widget.schedule.childrenPrice != null)
                      _iconText(Icons.child_care,
                          '${fmt.format(widget.schedule.childrenPrice)}đ / trẻ em',
                          color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
          if (note != null && note.isNotEmpty) ...[
            Divider(height: 3.h, color: Colors.grey.shade300),
            _iconText(Icons.sticky_note_2_outlined, note,
                color: Colors.blueGrey, multiLine: true),
          ]
        ],
      ),
    );
  }

  Widget _buildScheduleImage() {
    final img = widget.schedule.imageUrl;
    if (img != null && img.isNotEmpty && img.startsWith('http')) {
      return Image.network(img, width: 24.w, height: 11.h, fit: BoxFit.cover);
    }
    return Image.asset(AssetHelper.img_default,
        width: 24.w, height: 11.h, fit: BoxFit.cover);
  }

  Widget _iconText(IconData icon, String text,
      {Color? color, bool multiLine = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment:
            multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp, color: color ?? Colors.black87),
          SizedBox(width: 1.5.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: color ?? Colors.black87,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _counter(String label, int value, Function(int) onChanged,
      double unitPrice,
      {required int minAdult}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$label – ${fmt.format(unitPrice)}đ',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            SizedBox(height: 0.3.h),
            Text(
              label == 'Người lớn'
                  ? '(Từ 12 tuổi trở lên)'
                  : '(1 – dưới 12 tuổi)',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic),
            ),
          ]),
          Row(children: [
            _roundBtn(Icons.remove,
                (value > minAdult) ? () => onChanged(value - 1) : null),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text('$value',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            _roundBtn(Icons.add, canAdd()
                ? () => onChanged(value + 1)
                : () => _showLimitSnack()),
          ])
        ],
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback? onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(1.8.h),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onTap == null
                ? Colors.grey.withOpacity(.2)
                : Colors.white.withOpacity(.15),
            boxShadow: [
              if (onTap != null)
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 2))
            ],
          ),
          child: Icon(icon, color: Colors.white),
        ),
      );

Widget _totalBar() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Tổng: ${fmt.format(totalPrice)}đ',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
         InkWell(
  onTap: remaining >= 0
      ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkshopPaymentConfirmationScreen(
                workshop: widget.workshop,
                schedule: widget.schedule,
                adults: adultCount,
                children: childrenCount,
              ),
            ),
          );
        }
      : null,
  borderRadius: BorderRadius.circular(50),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
    decoration: BoxDecoration(
      gradient: Gradients.defaultGradientBackground,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
            color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))
      ],
    ),
    child: const Text(
      'Xác nhận',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)

        ],
      ),
    );

}

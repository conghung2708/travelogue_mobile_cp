import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_booking_screen.dart';

class WorkshopScheduleCard extends StatelessWidget {
  final WorkshopDetailModel workshop;
  final ScheduleModel schedule;
  final String workshopName;
  final bool readOnly; 

  const WorkshopScheduleCard({
    super.key,
    required this.workshop,
    required this.schedule,
    required this.workshopName,
    this.readOnly = false, 
  });

  int get _remain =>
      (schedule.maxParticipant ?? 0) - (schedule.currentBooked ?? 0);
  bool get _full => _remain <= 0;
  double get _pct =>
      (schedule.currentBooked ?? 0) / (schedule.maxParticipant ?? 1);
  DateTime? get _st => schedule.startTime;
  DateTime? get _end => schedule.endTime;

  @override
  Widget build(BuildContext context) {
    if (_st == null || _end == null) {
      return const SizedBox();
    }

    final fmt = NumberFormat("#,###");
    final dateStr = DateFormat('dd/MM/yyyy').format(_st!);
    final timeStr =
        '${DateFormat.Hm().format(_st!)} – ${DateFormat.Hm().format(_end!)}';
    final adultPriceStr = schedule.adultPrice != null
        ? '${fmt.format(schedule.adultPrice)}đ'
        : 'Liên hệ';
    final childPriceStr = schedule.childrenPrice != null
        ? '${fmt.format(schedule.childrenPrice)}đ'
        : 'Liên hệ';

    final humanMsg = _full
        ? 'Rất tiếc, ca này đã đủ người.'
        : (_remain <= 5
            ? '👐 Mỗi đôi tay thêm vào là một câu chuyện mới.\n'
                'Còn $_remain chỗ trống – bạn sẽ là phần ký ức tiếp theo?'
            : '🌾 Bạn sắp hoà mình vào nhịp sống làng nghề – '
                'chúng tôi rất háo hức được đón bạn.\n\n'
                'Bạn xác nhận tham gia ca này chứ?');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (_full || readOnly) return; 

        final ok = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _NiceDialog(
            title: 'Xác nhận Workshop',
            message: humanMsg,
            date: dateStr,
            time: timeStr,
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
        );

        if (ok ?? false) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkshopBookingScreen(
                workshop: workshop,
                schedule: schedule,
                workshopName: workshopName,
              ),
            ),
          );
        }
      },
      child: Container(
        height: 14.h,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(.08),
            )
          ],
        ),
        child: Row(
          children: [
            // Icon + line
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 14.sp, color: ColorPalette.primaryColor),
                Container(
                  width: .5.w,
                  height: 8.h,
                  margin: EdgeInsets.only(top: .3.h),
                  color: ColorPalette.primaryColor,
                ),
              ],
            ),
            SizedBox(width: 3.w),

            // Ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (schedule.imageUrl ?? '').startsWith('http')
                  ? Image.network(
                      schedule.imageUrl ?? '',
                      width: 22.w,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      (schedule.imageUrl != null &&
                              schedule.imageUrl!.isNotEmpty)
                          ? schedule.imageUrl!
                          : AssetHelper.img_default,
                      width: 22.w,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 3.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateStr,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text(workshopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      _priceTag('Người lớn', adultPriceStr, Colors.orange[700]!),
                      SizedBox(width: 2.w),
                      _priceTag('Trẻ em', childPriceStr, Colors.green[700]!),
                    ],
                  ),
                  Row(
                    children: [
                      Text(timeStr,
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        _full ? 'Hết chỗ' : 'Còn $_remain chỗ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: _full
                                  ? Colors.redAccent
                                  : Colors.green.shade700,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress
            SizedBox(
              width: 14.w,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _pct.clamp(0, 1)),
                duration: const Duration(milliseconds: 600),
                builder: (ctx, value, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 12.w,
                      height: 12.w,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 2.5,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(
                          _full
                              ? Colors.redAccent
                              : ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                    Text('${(value * 100).round()}%',
                        style: Theme.of(ctx)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceTag(String label, String price, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: color)),
          SizedBox(width: 1.w),
          Text(price,
              style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}

class _NiceDialog extends StatelessWidget {
  final String title, message, date, time;
  final VoidCallback onConfirm, onCancel;
  const _NiceDialog({
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.handshake_rounded,
                      color: ColorPalette.primaryColor, size: 22.sp),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryColor)),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              Text(message,
                  style: TextStyle(fontSize: 12.5.sp, color: Colors.black87)),
              SizedBox(height: 1.5.h),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withOpacity(.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 18, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Text('$date  •  $time',
                        style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorPalette.primaryColor,
                        side: BorderSide(color: ColorPalette.primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Để sau'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                      ),
                      child: const Text('Giữ chỗ',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

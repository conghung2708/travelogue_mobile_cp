// lib/representation/workshop/widgets/workshop_schedule_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/model/workshop/ticket_type_model.dart';

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
      (schedule.capacity ?? 0) - (schedule.currentBooked ?? 0);
  bool get _full => _remain <= 0;
  double get _pct =>
      (schedule.currentBooked ?? 0) / (schedule.capacity ?? 1);
  DateTime? get _st => schedule.startTime;
  DateTime? get _end => schedule.endTime;

  List<TicketTypeModel> get _ticketTypes =>
      (workshop.ticketTypes ?? const <TicketTypeModel>[]);

  TicketTypeModel? get _visitTT {
    try {
      return _ticketTypes.firstWhere(
        (t) => t.type == 1,
        orElse: () => throw Exception(),
      );
    } catch (_) {
      return null;
    }
  }

  TicketTypeModel? get _expTT {
    try {
      return _ticketTypes.firstWhere(
        (t) => t.type == 2 || t.isCombo == true,
        orElse: () => throw Exception(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_st == null || _end == null) return const SizedBox();

    final fmt = NumberFormat("#,###");
    final dateStr = DateFormat('dd/MM/yyyy').format(_st!);
    final timeStr =
        '${DateFormat.Hm().format(_st!)} – ${DateFormat.Hm().format(_end!)}';

    final String visitPriceStr = (_visitTT?.price != null)
        ? '${fmt.format(_visitTT!.price)}đ'
        : 'Liên hệ';
    final String expPriceStr = (_expTT?.price != null)
        ? '${fmt.format(_expTT!.price)}đ'
        : 'Liên hệ';

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (_full || readOnly) return;
        final choice = await _pickTicketType(context, dateStr, timeStr);
        if (choice == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkshopBookingScreen(
              workshop: workshop,
              schedule: schedule,
              workshopName: workshopName,
              ticketTypeId: choice.id,
              ticketTypeName: choice.name,
              ticketPrice: choice.price,
            ),
          ),
        );
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
            // Cột icon trái
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
                  Text(
                    workshopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),

      
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_visitTT != null) ...[
                          _priceTag('Tham quan', visitPriceStr,
                              Colors.orange[700]!),
                          SizedBox(width: 2.w),
                        ],
                        if (_expTT != null)
                          _priceTag(
                              'Trải nghiệm', expPriceStr, Colors.green[700]!),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Text(timeStr,
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text(
                        _full ? 'Hết chỗ' : 'Còn $_remain chỗ',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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

            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 44, maxWidth: 56),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _pct.clamp(0, 1),
                        strokeWidth: 2.5,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(
                          _full
                              ? Colors.redAccent
                              : ColorPalette.primaryColor,
                        ),
                      ),
                      Text(
                        '${(_pct.clamp(0, 1) * 100).round()}%',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<_TicketChoice?> _pickTicketType(
  BuildContext context, String dateStr, String timeStr) async {

  final List<TicketTypeModel> options = [
    if (_visitTT != null) _visitTT!,
    if (_expTT != null) _expTT!,
    if (_visitTT == null && _expTT == null) ..._ticketTypes,
  ];
  if (options.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hiện chưa có loại vé khả dụng')),
    );
    return null;
  }

  final fmt = NumberFormat("#,###");
  int? selectedIndex; 

  return await showModalBottomSheet<_TicketChoice>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModal) {
          return Padding(
            padding: EdgeInsets.only(
              left: 4.w, right: 4.w, top: 2.h,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 2.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48, height: 5,
                  margin: EdgeInsets.only(bottom: 1.2.h),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.event_available, color: ColorPalette.primaryColor),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text('$dateStr  •  $timeStr',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Chọn loại vé',
                    style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w900)),
                ),
                SizedBox(height: 1.h),

                ...List.generate(options.length, (i) {
                  final t = options[i];
                  final isVisit = t.type == 1;
                  final name = (t.name ?? '').isNotEmpty
                      ? t.name!
                      : (isVisit ? 'Vé tham quan' : 'Vé trải nghiệm');
                  final priceStr = (t.price != null)
                      ? '${fmt.format(t.price)}đ'
                      : 'Liên hệ';
                  final dur = (t.durationMinutes ?? 0) > 0 ? "${t.durationMinutes}'" : null;
                  final subtitle = [
                    if (dur != null) dur,
                    if ((t.content ?? '').isNotEmpty) t.content!.trim(),
                  ].join(' • ');

                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(
                        color: selectedIndex == i
                            ? ColorPalette.primaryColor
                            : Colors.blue.shade200,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<int>(
                      value: i,
                      groupValue: selectedIndex,
                      onChanged: (v) => setModal(() => selectedIndex = v),
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(priceStr, style: const TextStyle(fontWeight: FontWeight.w900)),
                        ],
                      ),
                      subtitle: subtitle.isEmpty ? null : Text(
                        subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  );
                }),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, null),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: ColorPalette.primaryColor),
                          foregroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Để sau'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedIndex == null ? null : () {
                          final t = options[selectedIndex!];
                          Navigator.pop(
                            ctx,
                            _TicketChoice(
                              id: t.id,
                              name: (t.name ?? '').isNotEmpty
                                  ? t.name!
                                  : (t.type == 1 ? 'Vé tham quan' : 'Vé trải nghiệm'),
                              price: t.price,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tiếp tục', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
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

class _TicketChoice {
  final String? id;
  final String name;
  final num? price;
  _TicketChoice({required this.id, required this.name, required this.price});
}

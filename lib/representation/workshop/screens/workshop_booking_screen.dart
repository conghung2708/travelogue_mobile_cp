// lib/representation/workshop/screens/workshop_booking_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';

import 'package:travelogue_mobile/representation/tour/widgets/participants_editor.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_back_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_title.dart';

import 'package:travelogue_mobile/representation/workshop/screens/workshop_payment_confirmation_screen.dart';

class WorkshopBookingScreen extends StatefulWidget {
  final String workshopName;
  final ScheduleModel schedule;
  final WorkshopDetailModel workshop;
  final String? ticketTypeId;
  final String? ticketTypeName;
  final num? ticketPrice;

  const WorkshopBookingScreen({
    super.key,
    required this.workshopName,
    required this.schedule,
    required this.workshop,
    this.ticketTypeId,
    this.ticketTypeName,
    this.ticketPrice,
  });

  @override
  State<WorkshopBookingScreen> createState() => _WorkshopBookingScreenState();
}

class _WorkshopBookingScreenState extends State<WorkshopBookingScreen> {
  final fmt = NumberFormat('#,###');
  final List<BookingParticipantModel> _rows = [];

  @override
  void initState() {
    super.initState();
    _rows.add(
      BookingParticipantModel(
        type: 1,
        fullName: '',
        gender: 1,
        dateOfBirth: DateTime(1990, 1, 1),
      ),
    );
  }

  int get adultCount => _rows.where((e) => e.type == 1).length;
  int get childrenCount => _rows.where((e) => e.type == 2).length;

  int get maxSlot => widget.schedule.capacity ?? 0;
  int get booked => widget.schedule.currentBooked ?? 0;
  int get remainingTotal =>
      (maxSlot > 0) ? (maxSlot - booked).clamp(0, 999999) : 999999;
  int get remainingAfterSelection => (maxSlot > 0)
      ? (maxSlot - booked - _rows.length).clamp(0, 999999)
      : 999999;

  bool get usingTicketType => widget.ticketPrice != null;
  double get _ticketUnitPrice => widget.ticketPrice?.toDouble() ?? 0;
  double get _adultPrice => widget.schedule.adultPrice?.toDouble() ?? 0;
  double get _childPrice => widget.schedule.childrenPrice?.toDouble() ?? 0;

  double get totalPrice => usingTicketType
      ? _rows.length * _ticketUnitPrice
      : adultCount * _adultPrice + childrenCount * _childPrice;

  bool get isOver => (maxSlot > 0) && _rows.length > remainingTotal;
  bool get confirmDisabled => isOver;

  void _limitSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> _pickDob(int index) async {
    final now = DateTime.now();
    final p = _rows[index];

    DateTime firstDate, lastDate, init;

    if (p.type == 2) {
      firstDate = DateTime(now.year - 11, now.month, now.day);
      lastDate = DateTime(now.year - 5, now.month, now.day);
      init =
          (p.dateOfBirth.isBefore(firstDate) || p.dateOfBirth.isAfter(lastDate))
              ? DateTime(now.year - 8, now.month, now.day)
              : p.dateOfBirth;
    } else {
      firstDate = DateTime(now.year - 100, 1, 1);
      lastDate = DateTime(now.year - 12, now.month, now.day);
      init =
          (p.dateOfBirth.isAfter(lastDate) || p.dateOfBirth.isBefore(firstDate))
              ? DateTime(now.year - 30, now.month, now.day)
              : p.dateOfBirth;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Chọn ngày sinh',
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() {
        _rows[index] = BookingParticipantModel(
          type: p.type,
          fullName: p.fullName,
          gender: p.gender,
          dateOfBirth: picked,
        );
      });
    }
  }

  void _addRow() {
    if (maxSlot > 0 && remainingAfterSelection <= 0) {
      _limitSnack('Đã đạt tối đa $remainingTotal chỗ cho lịch này.');
      return;
    }
    setState(() {
      _rows.add(
        BookingParticipantModel(
          type: 1,
          fullName: '',
          gender: 1,
          dateOfBirth: DateTime(1990, 1, 1),
        ),
      );
    });
  }

  void _removeRow(int i) => setState(() => _rows.removeAt(i));

  void _onConfirm() {
    if (_rows.isEmpty || _rows.any((p) => p.fullName.trim().isEmpty)) {
      _limitSnack('Vui lòng nhập đầy đủ họ tên hành khách.');
      return;
    }
    for (int i = 0; i < _rows.length; i++) {
      final p = _rows[i];
      final age = _ageFromDob(p.dateOfBirth);
      if (p.type == 2 && (age < 5 || age > 11)) {
        _limitSnack('Hành khách ${i + 1} phải trong độ tuổi Trẻ em (5–11).');
        return;
      }
      if (p.type == 1 && age < 12) {
        _limitSnack('Hành khách ${i + 1} (Người lớn) phải từ 12 tuổi trở lên.');
        return;
      }
    }
    if (maxSlot > 0 && _rows.length > remainingTotal) {
      _limitSnack('Chỉ còn $remainingTotal chỗ trống.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkshopPaymentConfirmationScreen(
          workshop: widget.workshop,
          schedule: widget.schedule,
          adults: adultCount,
          children: childrenCount,
          participants: _rows,
          ticketTypeId: widget.ticketTypeId,
          ticketTypeName: widget.ticketTypeName,
          ticketPrice: widget.ticketPrice,
        ),
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
                    const TourTeamTitle(),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.workshopName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _summaryCard(),
                    SizedBox(height: 1.2.h),
                    _capacityBanner(),
                    SizedBox(height: 1.8.h),
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: ParticipantsEditor(
                          rows: _rows,
                          onChanged: () => setState(() {}),
                          onRemove: _removeRow,
                          onAdd: _addRow,
                          onPickDob: _pickDob,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
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
                    _iconText(Icons.location_on_rounded,
                        widget.workshop.craftVillageName ?? 'Làng nghề'),
                    SizedBox(height: .6.h),
                    _iconText(Icons.calendar_month, d),
                    _iconText(Icons.schedule, t),
                    SizedBox(height: 0.5.h),
                    if (usingTicketType) ...[
                      _chipRow(
                        icon: Icons.confirmation_number_outlined,
                        label: widget.ticketTypeName ?? 'Loại vé',
                        value: '${fmt.format(_ticketUnitPrice)}đ / khách',
                        color: ColorPalette.primaryColor,
                      ),
                    ] else ...[
                      if (widget.schedule.adultPrice != null)
                        _iconText(
                          Icons.person,
                          '${fmt.format(widget.schedule.adultPrice)}đ / người lớn',
                          color: Colors.orange,
                        ),
                      if (widget.schedule.childrenPrice != null)
                        _iconText(
                          Icons.child_care,
                          '${fmt.format(widget.schedule.childrenPrice)}đ / trẻ em',
                          color: Colors.green,
                        ),
                    ],
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

  Widget _chipRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: color),
        SizedBox(width: 1.5.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .6.h),
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withOpacity(.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontSize: 11.sp)),
              SizedBox(width: 2.w),
              Text('•',
                  style: TextStyle(
                      color: color.withOpacity(.8),
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 2.w),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontSize: 11.sp)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _capacityBanner() {
    if (maxSlot <= 0) return const SizedBox.shrink();
    final remainAfter = remainingAfterSelection;
    final usedNow = (booked + _rows.length);
    final ratio = maxSlot == 0 ? 0.0 : (usedNow / maxSlot).clamp(0.0, 1.0);

    final over = isOver;
    final bg = over ? const Color(0xFFFFEBEE) : const Color(0xFFF1F8E9);
    final bd = over ? const Color(0xFFFFCDD2) : const Color(0xFFDCEDC8);
    final ic = over ? Colors.red : Colors.green;
    final txt = over
        ? 'Số khách đang vượt quá số chỗ còn lại (${remainAfter < 0 ? 0 : remainAfter}). Vui lòng giảm số lượng.'
        : 'Còn lại $remainAfter/$maxSlot chỗ cho lịch này.';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bd),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(over ? Icons.error_outline_rounded : Icons.event_available,
                  color: ic),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  txt,
                  style: TextStyle(
                    color: over ? Colors.red.shade800 : Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }

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
            IgnorePointer(
              ignoring: confirmDisabled,
              child: Opacity(
                opacity: confirmDisabled ? 0.5 : 1.0,
                child: InkWell(
                  onTap: _onConfirm,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}

int _ageFromDob(DateTime dob) {
  final now = DateTime.now();
  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

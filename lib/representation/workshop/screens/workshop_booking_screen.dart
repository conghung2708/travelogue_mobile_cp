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
  final fmt = NumberFormat('#,###');

  // ==== Participants like selector ====
  final List<BookingParticipantModel> _rows = [];

  @override
  void initState() {
    super.initState();
    // luôn có sẵn 1 người lớn để không bị trống
    _rows.add(
      BookingParticipantModel(
        type: 1,
        fullName: '',
        gender: 1,
        dateOfBirth: DateTime(1990, 1, 1),
      ),
    );
  }

  // ==== Derived values ====
  int get adultCount => _rows.where((e) => e.type == 1).length;
  int get childrenCount => _rows.where((e) => e.type == 2).length;

  int get maxSlot => widget.schedule.maxParticipant ?? 0;
  int get booked => widget.schedule.currentBooked ?? 0;
  int get available => (maxSlot > 0) ? (maxSlot - booked) : 999999;

  double get _adultPrice => widget.schedule.adultPrice?.toDouble() ?? 0;
  double get _childPrice => widget.schedule.childrenPrice?.toDouble() ?? 0;

  double get totalPrice =>
      adultCount * _adultPrice + childrenCount * _childPrice;

  // ==== Helpers ====
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
      // Trẻ em: 5–11
      firstDate = DateTime(now.year - 11, now.month, now.day);
      lastDate = DateTime(now.year - 5, now.month, now.day);
      init = (p.dateOfBirth.isBefore(firstDate) ||
              p.dateOfBirth.isAfter(lastDate))
          ? DateTime(now.year - 8, now.month, now.day)
          : p.dateOfBirth;
    } else {
      // Người lớn: ≥12
      firstDate = DateTime(now.year - 100, 1, 1);
      lastDate = DateTime(now.year - 12, now.month, now.day);
      init = (p.dateOfBirth.isAfter(lastDate) ||
              p.dateOfBirth.isBefore(firstDate))
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
    // không chặn ở đây (để user thêm thoải mái), sẽ check khi bấm xác nhận
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
    // validate tên
    if (_rows.isEmpty || _rows.any((p) => p.fullName.trim().isEmpty)) {
      _limitSnack('Vui lòng nhập đầy đủ họ tên hành khách.');
      return;
    }
    // validate tuổi theo type
    for (int i = 0; i < _rows.length; i++) {
      final p = _rows[i];
      final age = _ageFromDob(p.dateOfBirth);
      if (p.type == 2 && (age < 5 || age > 11)) {
        _limitSnack('Hành khách ${i + 1} phải trong độ tuổi Trẻ em (5–11).');
        return;
      }
      if (p.type == 1 && age < 12) {
        _limitSnack(
            'Hành khách ${i + 1} (Người lớn) phải từ 12 tuổi trở lên.');
        return;
      }
    }
    // check slot
    final totalPeople = _rows.length;
    if (totalPeople > available) {
      _limitSnack('Chỉ còn $available chỗ trống.');
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

                    // tiêu đề giống selector
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
                    SizedBox(height: 2.h),

                    // ==== ParticipantsEditor (selector style) ====
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

                    // Footer
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
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

// lib/features/tour/presentation/screens/tour_team_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/participants_editor.dart';
import 'package:travelogue_mobile/representation/tour/widgets/person_counter_row.dart';
import 'package:travelogue_mobile/representation/tour/widgets/total_price_bar.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_back_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_summary_card.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_title.dart';

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
  State<TourTeamSelectorScreen> createState() => _TourTeamSelectorScreenState();
}

class _TourTeamSelectorScreenState extends State<TourTeamSelectorScreen> {
  final formatter = NumberFormat('#,###');
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

  int get availableSlot =>
      (widget.schedule.maxParticipant ?? 0) -
      (widget.schedule.currentBooked ?? 0);

  int get totalPeople => _rows.length;
  int get remainingSlot =>
      ((availableSlot - totalPeople).clamp(0, availableSlot)).toInt();

  int get adultCount => _rows.where((e) => e.type == 1).length;
  int get childrenCount => _rows.where((e) => e.type == 2).length;

  double get totalPrice =>
      (adultCount * (widget.schedule.adultPrice ?? 0)) +
      (childrenCount * (widget.schedule.childrenPrice ?? 0));

  bool get canAdd => totalPeople < availableSlot;

  void _limitSnack() {
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

  Future<void> _pickDob(int index) async {
    final now = DateTime.now();
    final p = _rows[index];

    DateTime firstDate, lastDate, init;

    if (p.type == 2) {
  
      firstDate = DateTime(now.year - 11, now.month, now.day);
      lastDate  = DateTime(now.year - 5,  now.month, now.day);
      init = (p.dateOfBirth.isBefore(firstDate) || p.dateOfBirth.isAfter(lastDate))
          ? DateTime(now.year - 8, now.month, now.day)
          : p.dateOfBirth;
    } else {
  
      firstDate = DateTime(now.year - 100, 1, 1);
      lastDate  = DateTime(now.year - 12, now.month, now.day);
      init = (p.dateOfBirth.isAfter(lastDate) || p.dateOfBirth.isBefore(firstDate))
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
    if (!canAdd) {
      _limitSnack();
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

  void _goNext() {
    if (_rows.isEmpty || _rows.any((p) => p.fullName.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ họ tên hành khách.')),
      );
      return;
    }

    for (int i = 0; i < _rows.length; i++) {
      final p = _rows[i];
      final age = _ageFromDob(p.dateOfBirth);

      if (p.type == 2 && (age < 5 || age > 11)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hành khách ${i + 1} phải trong độ tuổi Trẻ em (5–11).')),
        );
        return;
      }
      if (p.type == 1 && age < 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hành khách ${i + 1} (Người lớn) phải từ 12 tuổi trở lên.')),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TourPaymentConfirmationScreen(
          tour: widget.tour,
          schedule: widget.schedule,
          startTime: widget.schedule.startTime,
          adults: adultCount,
          children: childrenCount,
          media: widget.media,
          participants: _rows,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom  = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), 
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : safeBottom),
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: TotalPriceBar(
                totalPriceText: "Tổng: ${formatter.format(totalPrice)}đ",
                buttonText: "Tiếp tục",
                onPressed: _goNext,
                color: ColorPalette.primaryColor,
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            const TourTeamBackground(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),

                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(bottom: 2.h + 72), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TourBackButton(),
                      SizedBox(height: 3.h),

                      const TourTeamTitle(),
                      SizedBox(height: 2.h),

                      TourTeamSummaryCard(
                        tour: widget.tour,
                        schedule: widget.schedule,
                        mediaUrl: widget.media,
                        formatter: formatter,
                      ),
                      SizedBox(height: 2.h),

            
                      // PersonCounterRow(...),

                      ParticipantsEditor(
                        rows: _rows,
                        onChanged: () => setState(() {}),
                        onRemove: _removeRow,
                        onAdd: _addRow,
                        onPickDob: _pickDob,
                      ),
                      SizedBox(height: 1.2.h),

                      Text(
                        canAdd
                            ? '👥 Bạn có thể thêm tối đa $remainingSlot người.'
                            : '⚠️ Đã đạt giới hạn số người ($availableSlot)',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: canAdd ? Colors.white70 : Colors.yellow,
                        ),
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
}

int _ageFromDob(DateTime dob) {
  final now = DateTime.now();
  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

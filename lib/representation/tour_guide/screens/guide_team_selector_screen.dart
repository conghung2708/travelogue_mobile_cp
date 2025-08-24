import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/participants_editor.dart';
import 'package:travelogue_mobile/representation/tour/widgets/total_price_bar.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_back_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_team_title.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_booking_confirmation_screen.dart';

class GuideTeamSelectorScreen extends StatefulWidget {
  static const String routeName = '/guide-team-selector';

  final TourGuideModel guide;
  final DateTime startDate;
  final DateTime endDate;
  final double unitPrice;
  final String? tripPlanId;
  final int? maxPeople;

  const GuideTeamSelectorScreen({
    super.key,
    required this.guide,
    required this.startDate,
    required this.endDate,
    required this.unitPrice,
    this.tripPlanId,
    this.maxPeople,
  });

  @override
  State<GuideTeamSelectorScreen> createState() =>
      _GuideTeamSelectorScreenState();
}

class _GuideTeamSelectorScreenState extends State<GuideTeamSelectorScreen> {
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

  int get totalPeople => _rows.length;
  int get adultCount => _rows.where((e) => e.type == 1).length;
  int get childrenCount => _rows.where((e) => e.type == 2).length;

  bool get hasLimit => widget.maxPeople != null && widget.maxPeople! > 0;
  int get remainingSlot => hasLimit
      ? (widget.maxPeople! - totalPeople).clamp(0, widget.maxPeople!).toInt()
      : 9999;
  bool get canAdd => !hasLimit || totalPeople < widget.maxPeople!;

  double get totalPrice =>
      widget.unitPrice *
      (widget.endDate.difference(widget.startDate).inDays + 1);

  void _limitSnack() {
    if (!hasLimit) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bạn chỉ có thể chọn tối đa ${widget.maxPeople} người.'),
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
    if (!canAdd) {
      _limitSnack();
      return;
    }
    setState(() {
      _rows.add(BookingParticipantModel(
        type: 1,
        fullName: '',
        gender: 1,
        dateOfBirth: DateTime(1990, 1, 1),
      ));
    });
  }

  void _removeRow(int i) {
    setState(() => _rows.removeAt(i));
  }

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
          SnackBar(
              content:
                  Text('Hành khách ${i + 1} phải trong độ tuổi Trẻ em (5–11).')),
        );
        return;
      }
      if (p.type == 1 && age < 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Hành khách ${i + 1} (Người lớn) phải từ 12 tuổi trở lên.')),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuideBookingConfirmationScreen(
          guide: widget.guide,
          tripPlanId:
              (widget.tripPlanId != null && widget.tripPlanId!.isNotEmpty)
                  ? widget.tripPlanId
                  : null,
          startDate: widget.startDate,
          endDate: widget.endDate,
          adults: adultCount,
          children: childrenCount,
          participants: _rows,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
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
        totalPriceText:
            "Tổng ${widget.endDate.difference(widget.startDate).inDays + 1} ngày: ${formatter.format(totalPrice)}đ",
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

              // 🔥 Toàn bộ nội dung cuộn 1 lần, không dùng Column+Expanded
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: 2.h + 72, // chừa chỗ cho footer
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TourBackButton(),
                    SizedBox(height: 3.h),

                    const TourTeamTitle(),
                    SizedBox(height: 3.h),

                    GuideTeamSummaryCard(
                      guide: widget.guide,
                      start: widget.startDate,
                      end: widget.endDate,
                      unitPrice: widget.unitPrice,
                      formatter: formatter,
                    ),
                    SizedBox(height: 2.h),

                    ParticipantsEditor(
                      rows: _rows,
                      onChanged: () => setState(() {}),
                      onRemove: _removeRow,
                      onAdd: _addRow,
                      onPickDob: _pickDob,
                    ),
                    SizedBox(height: 1.2.h),

                    Text(
                      hasLimit
                          ? (canAdd
                              ? '👥 Bạn có thể thêm tối đa $remainingSlot người.'
                              : '⚠️ Đã đạt giới hạn số người (${widget.maxPeople})')
                          : '👥 Bạn có thể thêm nhiều hành khách.',
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

class GuideTeamSummaryCard extends StatelessWidget {
  final TourGuideModel guide;
  final DateTime start;
  final DateTime end;
  final double unitPrice;
  final NumberFormat formatter;

  const GuideTeamSummaryCard({
    super.key,
    required this.guide,
    required this.start,
    required this.end,
    required this.unitPrice,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');
    final name =
        (guide.userName?.trim().isNotEmpty ?? false) ? guide.userName! : 'Hướng dẫn viên';
    final rating = guide.averageRating;
    final reviewCount = guide.totalReviews;
    final address = guide.address?.trim();

    final avatar = CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 30,
        backgroundImage:
            (guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty)
                ? NetworkImage(guide.avatarUrl!)
                : null,
        backgroundColor: Colors.grey.shade400,
        child: (guide.avatarUrl == null || guide.avatarUrl!.isEmpty)
            ? const Icon(Icons.person, size: 28, color: Colors.white)
            : null,
      ),
    );

    Widget ratingRow() {
      if (rating == null || rating <= 0) return const SizedBox.shrink();
      return Row(
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1),
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          if (reviewCount != null && reviewCount > 0) ...[
            const SizedBox(width: 6),
            Text('($reviewCount)', style: const TextStyle(color: Colors.white70)),
          ],
        ],
      );
    }

    final priceBox = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Giá', style: TextStyle(color: Colors.white70, fontSize: 11)),
          Text(
            '${formatter.format(unitPrice)}đ',
            style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatar,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ratingRow(),
                  ],
                ),
              ),
              priceBox,
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                '${df.format(start)} → ${df.format(end)}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (address != null && address.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(address, style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

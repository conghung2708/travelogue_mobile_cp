// lib/representation/booking/screens/booking_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';

// HDV
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

// Nhận DisplayBookingArgs để lấy displayTitle (được push từ MyBookingScreen)
import 'package:travelogue_mobile/representation/booking/screens/my_booking_screen.dart'
    show DisplayBookingArgs;

class BookingDetailScreen extends StatefulWidget {
  static const routeName = '/booking_detail';

  final BookingModel? booking;
  const BookingDetailScreen({super.key, this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  static const _supportPhone = '0336626193';

  final _guideRepo = TourGuideRepository();
  Future<TourGuideModel?>? _guideFuture;

  // 🆕 Lưu lại HDV & avatar để update header image khi fetch xong
  TourGuideModel? _guide;
  String? _guideAvatarUrl;

  // ---------- Helpers đọc args ----------
  BookingModel get _booking {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (widget.booking != null) return widget.booking!;
    if (args is DisplayBookingArgs) return args.booking;
    if (args is BookingModel) return args;
    throw Exception("BookingDetailScreen requires BookingModel or DisplayBookingArgs");
  }

  String? get _displayTitle {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DisplayBookingArgs) return args.displayTitle;
    return null;
  }

  // ---------- Lifecycle ----------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final b = _booking;
    // Chỉ fetch avatar HDV nếu là booking type = 3 và có tourGuideId
    if (_bookingTypeOf(b) == 3 && (b.tourGuideId?.isNotEmpty ?? false) && _guideFuture == null) {
      _guideFuture = _guideRepo.getTourGuideById(b.tourGuideId!).then((g) {
        // Lưu lại để header có thể setState đổi ảnh
        _guide = g;
        if ((g?.avatarUrl?.startsWith('http') ?? false)) {
          setState(() => _guideAvatarUrl = g!.avatarUrl);
        }
        return g;
      });
    }
  }

  // ---------- Formatters ----------
  NumberFormat get _currency =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  String _fmtDate(DateTime? d, {String pattern = 'dd/MM/yyyy'}) {
    if (d == null) return '-';
    if (d.year < 1900) return '-';
    return DateFormat(pattern).format(d);
  }

  String _fmtDateTime(DateTime? d) {
    if (d == null) return '-';
    if (d.year < 1900) return '-';
    return DateFormat('dd/MM/yyyy • HH:mm').format(d);
  }

  // ---------- Business ----------
  int _bookingTypeOf(BookingModel b) {
    final t = b.bookingType.trim();
    final parsed = int.tryParse(t);
    if (parsed != null) return parsed;
    final up = t.toUpperCase();
    if (up.contains('TOUR')) return 1;
    if (up.contains('WORKSHOP')) return 2;
    if (up.contains('GUIDE') || up.contains('HƯỚNG')) return 3;
    return -1;
  }

  bool _isPersonalTrip(BookingModel b) =>
      _bookingTypeOf(b) == 3 && b.tripPlanId != null;

  String _typeLabelVi(BookingModel b) {
    final type = _bookingTypeOf(b);
    if (type == 1) return 'Tour';
    if (type == 2) return 'Workshop';
    if (type == 3) return _isPersonalTrip(b) ? 'Chuyến đi cá nhân' : 'Hướng dẫn viên';
    return b.bookingTypeText ?? 'Khác';
  }

  // ---------- Header image logic ----------
  ImageProvider _headerImage(BookingModel b) {
    // 1) Tour: lấy ảnh tour
    if (b.tour?.medias.isNotEmpty == true) {
      final url = b.tour!.medias.first.mediaUrl;
      if (url != null && url.startsWith('http')) return NetworkImage(url);
    }
    // 2) Hướng dẫn viên: nếu đã fetch avatar -> dùng avatar
    if ((_bookingTypeOf(b) == 3) && (_guideAvatarUrl?.startsWith('http') ?? false)) {
      return NetworkImage(_guideAvatarUrl!);
    }
    // 3) Fallback
    return const AssetImage(AssetHelper.img_tay_ninh_login);
  }

  ({Color fg, Color bg, Color border, IconData icon}) _statusStyle(BookingModel b) {
    switch (b.rawStatus) {
      case BookingModel.kPending:
      case BookingModel.kExpired:
        return (fg: const Color(0xFFB46900), bg: const Color(0xFFFFEDD5),
                border: const Color(0xFFB46900).withOpacity(.38),
                icon: Icons.hourglass_bottom_rounded);
      case BookingModel.kConfirmed:
        return (fg: const Color(0xFF0B6EEF), bg: const Color(0xFFE6F0FF),
                border: const Color(0xFF0B6EEF).withOpacity(.38),
                icon: Icons.verified_rounded);
      case BookingModel.kCompleted:
        return (fg: Colors.white, bg: Colors.green.shade600,
                border: Colors.green.shade700, icon: Icons.check_circle_rounded);
      case BookingModel.kCancelledUnpaid:
        return (fg: Colors.orange.shade900, bg: const Color(0xFFFFF3E0),
                border: Colors.orange.shade400,
                icon: Icons.cancel_schedule_send_rounded);
      case BookingModel.kCancelledPaid:
        return (fg: Colors.red.shade700, bg: const Color(0xFFFFE6E6),
                border: Colors.red.shade400, icon: Icons.cancel_rounded);
      case BookingModel.kCancelledByProvider:
        return (fg: Colors.purple.shade700, bg: const Color(0xFFF3E5F5),
                border: Colors.purple.shade300,
                icon: Icons.report_gmailerrorred_rounded);
      default:
        return (fg: Colors.white, bg: Colors.teal.shade600,
                border: Colors.teal.shade700, icon: Icons.info_rounded);
    }
  }

  Widget _statusChip(BookingModel b) {
    final style = _statusStyle(b);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: b.rawStatus == BookingModel.kCompleted ? style.bg : style.border,
          width: 1,
        ),
        boxShadow: [
          if (b.rawStatus == BookingModel.kCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 16.sp, color: style.fg),
          SizedBox(width: 2.4.w),
          Text(
            b.statusTextUi,
            style: TextStyle(
              color: style.fg,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18.sp, color: Colors.black87),
        if (icon != null) SizedBox(width: 2.4.w),
        Text(title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, letterSpacing: .2)),
      ],
    );
  }

  Widget _kv(String label, String value, {IconData? icon, TextAlign align = TextAlign.right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 16.sp, color: Colors.grey[700]),
        if (icon != null) SizedBox(width: 2.4.w),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]))),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: align,
            style: TextStyle(fontSize: 13.2.sp, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool strong = false, Color? color}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]))),
        Text(
          value,
          style: TextStyle(
            fontSize: strong ? 15.sp : 13.5.sp,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            color: color ?? Colors.black,
            letterSpacing: strong ? .2 : 0,
          ),
        ),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x13000000), blurRadius: 14, offset: Offset(0, 6)),
        ],
        border: Border.all(color: Colors.grey.withOpacity(.08)),
      ),
      child: child,
    );
  }

  Future<void> _confirmAndCall(BuildContext context) async {
    final ok = await _showCallDialog(context);
    if (ok == true) {
      final uri = Uri(scheme: 'tel', path: _supportPhone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
        );
      }
    }
  }

  Future<bool?> _showCallDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.4.h),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.support_agent_rounded,
                          color: Colors.white, size: 30),
                    ),
                    SizedBox(height: 1.2.h),
                    const Text('Gọi hỗ trợ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 1.2.h),
                child: Column(
                  children: [
                    Text(
                      'Bạn có muốn liên hệ qua số điện thoại sau?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87, height: 1.4),
                    ),
                    SizedBox(height: 1.2.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone_rounded, color: Colors.blue),
                          SizedBox(width: 2.w),
                          Text(_supportPhone,
                              style: TextStyle(
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .3,
                                  color: Colors.blue.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.4.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.6.h),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Huỷ'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        icon: const Icon(Icons.call_rounded),
                        label: const Text('Gọi ngay'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.6.h),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _genderLabel(int g, String? text) {
    if (text != null && text.trim().isNotEmpty) return text;
    switch (g) {
      case 1:
        return 'Nam';
      case 2:
        return 'Nữ';
      default:
        return 'Khác';
    }
  }

  String _participantTypeLabel(int t) {
    switch (t) {
      case 1:
        return 'Người lớn';
      case 2:
        return 'Trẻ em';
      case 3:
        return 'Em bé';
      default:
        return 'Khác';
    }
  }

  // ---------- Participants ----------
  Widget _participantsCard(List<BookingParticipantModel> list) {
    if (list.isEmpty) return const SizedBox.shrink();

    final totalQty = list.fold<int>(0, (sum, p) => sum + p.quantity);
    final totalAmount =
        list.fold<double>(0.0, (sum, p) => sum + p.pricePerParticipant * p.quantity);

    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Hành khách', icon: Icons.groups_2_rounded),
          SizedBox(height: 1.2.h),
          ...List.generate(list.length, (i) {
            final p = list[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 1.0.h),
              child: _ParticipantTile(
                index: i + 1,
                fullName: p.fullName,
                typeText: _participantTypeLabel(p.type),
                genderText: _genderLabel(p.gender, p.genderText),
                dobText: _fmtDate(p.dateOfBirth),
                quantity: p.quantity,
                priceText: _currency.format(p.pricePerParticipant),
              ),
            );
          }),
          Divider(height: 2.2.h),
          Row(
            children: [
              Expanded(child: Text('Tổng khách', style: TextStyle(color: Colors.grey[700]))),
              Text('$totalQty', style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(height: 0.6.h),
          Row(
            children: [
              Expanded(child: Text('Tổng theo danh sách', style: TextStyle(color: Colors.grey[700]))),
              Text(_currency.format(totalAmount),
                  style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ---------- Guide card ----------
  Widget _guideCardBasic({required String name}) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Hướng dẫn viên', icon: Icons.person_pin_circle_rounded),
          SizedBox(height: 1.6.h),
          Row(
            children: [
              const CircleAvatar(radius: 26, child: Icon(Icons.person)),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _guideCardFull(TourGuideModel g) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Hướng dẫn viên', icon: Icons.person_pin_circle_rounded),
          SizedBox(height: 1.6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: (g.avatarUrl?.startsWith('http') ?? false)
                    ? NetworkImage(g.avatarUrl!)
                    : null,
                child: (g.avatarUrl?.isEmpty ?? true)
                    ? const Icon(Icons.person, size: 26)
                    : null,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.userName ?? 'Hướng dẫn viên',
                        style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w900)),
                    SizedBox(height: .3.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        if (g.averageRating != null)
                          _miniChip(Icons.star_rounded, '${g.averageRating!.toStringAsFixed(1)}★ (${g.totalReviews ?? 0})'),
                        // if (g.price != null)
                        //   _miniChip(Icons.sell_rounded, _currency.format(g.price)),
                        if ((g.address ?? '').isNotEmpty)
                          _miniChip(Icons.place_rounded, g.address!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((g.introduction ?? '').isNotEmpty) ...[
            SizedBox(height: 1.2.h),
            Text(
              g.introduction!,
              style: TextStyle(fontSize: 12.5.sp, color: Colors.black87, height: 1.35),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = _booking;
    final headerImg = _headerImage(b); // ảnh header đã tính theo logic trên

    int? totalDays;
    if (b.startDate != null && b.endDate != null) {
      totalDays = b.endDate!.difference(b.startDate!).inDays + 1;
      if (totalDays < 1) totalDays = null;
    }

    final double fabGap = MediaQuery.of(context).padding.bottom + 100;

    final showGuide = _bookingTypeOf(b) == 3;

    // Tiêu đề ưu tiên tên truyền vào, fallback loại đơn
    final headerTitle = _displayTitle ?? _typeLabelVi(b);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 32.h,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: headerImg, fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.8.h,
                      left: 4.w,
                      right: 4.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _roundIcon(
                            context,
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          _roundIcon(
                            context,
                            icon: Icons.more_horiz_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 4.w,
                      right: 4.w,
                      bottom: 2.8.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headerTitle,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: .3,
                            ),
                          ),
                          SizedBox(height: 1.2.h),
                          _statusChip(b),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin đơn
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Thông tin đơn', icon: Icons.receipt_long_outlined),
                          SizedBox(height: 1.8.h),
                          // Nếu muốn ẩn luôn mã đơn, xoá dòng dưới
                          _kv('Mã đơn', b.id, icon: Icons.qr_code_2_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Loại đơn', _typeLabelVi(b), icon: Icons.category_outlined),
                          SizedBox(height: 1.4.h),
                          _kv('Tên người đặt', b.userName ?? '-', icon: Icons.person_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Ngày đặt', _fmtDateTime(b.bookingDate), icon: Icons.calendar_month_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Trạng thái', b.statusTextUi, icon: Icons.payments_outlined),
                          if (b.cancelledAt != null) ...[
                            SizedBox(height: 1.4.h),
                            _kv('Thời điểm huỷ', _fmtDateTime(b.cancelledAt),
                                icon: Icons.cancel_schedule_send_rounded),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Hướng dẫn viên (nếu là type 3)
                    if (showGuide)
                      FutureBuilder<TourGuideModel?>(
                        future: _guideFuture,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return _card(
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Đang tải thông tin hướng dẫn viên...'),
                                ],
                              ),
                            );
                          }
                          if (snap.hasError) {
                            final showName = b.tourGuideName ?? 'Hướng dẫn viên';
                            return _guideCardBasic(name: showName);
                          }
                          final g = snap.data ?? _guide;
                          if (g == null) {
                            final showName = b.tourGuideName ?? 'Hướng dẫn viên';
                            return _guideCardBasic(name: showName);
                          }
                          return _guideCardFull(g);
                        },
                      ),
                    if (showGuide) SizedBox(height: 2.h),

                    // Lịch & thời gian
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Lịch & thời gian', icon: Icons.event_rounded),
                          SizedBox(height: 1.8.h),
                          _kv('Ngày khởi hành', _fmtDate(b.departureDate),
                              icon: Icons.flight_takeoff_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Bắt đầu', _fmtDate(b.startDate),
                              icon: Icons.play_circle_fill_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Kết thúc', _fmtDate(b.endDate),
                              icon: Icons.flag_rounded),
                          if (totalDays != null) ...[
                            SizedBox(height: 1.4.h),
                            _kv('Số ngày', '$totalDays ngày',
                                icon: Icons.timeline_rounded),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Thông tin liên hệ
                    if ((b.contactName ?? b.contactEmail ?? b.contactPhone ?? b.contactAddress) != null)
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Thông tin liên hệ', icon: Icons.contact_phone_rounded),
                            SizedBox(height: 1.8.h),
                            _kv('Họ tên', b.contactName ?? '-', icon: Icons.badge_rounded),
                            SizedBox(height: 1.4.h),
                            _kv('Email', b.contactEmail ?? '-', icon: Icons.alternate_email_rounded),
                            SizedBox(height: 1.4.h),
                            _kv('Số điện thoại', b.contactPhone ?? '-', icon: Icons.phone_rounded),
                            SizedBox(height: 1.4.h),
                            _kv('Địa chỉ', b.contactAddress ?? '-', icon: Icons.location_on_rounded),
                          ],
                        ),
                      ),
                    if ((b.contactName ?? b.contactEmail ?? b.contactPhone ?? b.contactAddress) != null)
                      SizedBox(height: 2.h),

                    // Hành khách
                    _participantsCard(b.participants),
                    if (b.participants.isNotEmpty) SizedBox(height: 2.h),

                    // Thanh toán
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Thanh toán', icon: Icons.credit_card_rounded),
                          SizedBox(height: 1.8.h),
                          _priceRow('Giá gốc', _currency.format(b.originalPrice)),
                          SizedBox(height: 1.0.h),
                          _priceRow('Khuyến mãi',
                              '- ${_currency.format(b.discountAmount)}',
                              color: Colors.teal),
                          Divider(height: 3.2.h, thickness: 1),
                          _priceRow('Tổng thanh toán',
                              _currency.format(b.finalPrice),
                              strong: true,
                              color: Colors.black),
                        ],
                      ),
                    ),

                    SizedBox(height: fabGap),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundIcon(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: EdgeInsets.all(1.2.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18.sp, color: Colors.black87),
      ),
    );
  }
}

// ====== Ô hành khách ======
class _ParticipantTile extends StatelessWidget {
  final int index;
  final String fullName;
  final String typeText;
  final String genderText;
  final String dobText;
  final int quantity;
  final String priceText;

  const _ParticipantTile({
    required this.index,
    required this.fullName,
    required this.typeText,
    required this.genderText,
    required this.dobText,
    required this.quantity,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Hành khách $index',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.8.sp)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.2.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _miniChip(Icons.badge_rounded, typeText),
              _miniChip(Icons.wc_rounded, genderText),
              _miniChip(Icons.cake_rounded, dobText),
              _miniChip(Icons.reduce_capacity_rounded, 'SL: $quantity'),
              _miniChip(Icons.sell_rounded, priceText),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class BookingDetailScreen extends StatelessWidget {
  static const routeName = '/booking_detail';

  final BookingModel? booking;
  const BookingDetailScreen({super.key, this.booking});

  static const _supportPhone = '0336626193';

  NumberFormat get _currency =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

int _statusCodeOf(BookingModel b) {
  final textUp = (b.statusText ?? '').trim().toUpperCase();

  // Đọc status thô
  final dynamic s = b.status;
  int? raw;
  if (s is int) raw = s;
  if (s is String) raw = int.tryParse(s.trim());

  // Ưu tiên số từ server
  if (raw != null) {
    // 3/4 mới là hủy; KHÔNG dựa vào cancelledAt
    if (raw == 3 || raw == 4) return 3;
    if (raw == 5) return 2; // BE của bạn: 5 = ĐÃ HOÀN THÀNH
    if (raw == 2) return 2; // Hoàn tất
    if (raw == 1) return 1; // Đã thanh toán/Confirmed
    if (raw == 0) return 0; // Hết hạn/Pending/Unpaid
  }

  // Fallback theo chữ
  final text = textUp.toLowerCase();
  if (text.contains('đã hủy') || text.contains('bị hủy') || text.contains('hủy') ||
      text.contains('canceled') || text.contains('cancelled')) return 3;
  if (text.contains('đã hoàn tất') || text.contains('đã hoàn thành') || text.contains('completed')) return 2;
  if (text.contains('đã thanh toán') || text.contains('confirmed') || text.contains('paid')) return 1;
  if (text.contains('hết hạn') || text.contains('pending') || text.contains('unpaid')) return 0;

  return 0;
}


String _statusLabelVi(BookingModel b) {
  switch (_statusCodeOf(b)) {
    case 0: return 'Hết hạn thanh toán';
    case 1: return 'Đã thanh toán';
    case 2: return 'Đã hoàn thành';
    case 3: return 'Đã hủy';
    default: return b.statusText ?? 'Không rõ';
  }
}

Color _statusColor(BookingModel b) {
  switch (_statusCodeOf(b)) {
    case 0: return Colors.orange;
    case 1: return Colors.blue;
    case 2: return Colors.green;
    case 3: return Colors.red;        // màu đỏ cho bị hủy
    default: return Colors.grey;
  }
}

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

  bool _isPersonalTrip(BookingModel b) {
    return _bookingTypeOf(b) == 3 && b.tripPlanId != null;
  }

  String _typeLabelVi(BookingModel b) {
    final type = _bookingTypeOf(b);
    if (type == 1) return 'Tour';
    if (type == 2) return 'Workshop';
    if (type == 3) {
      return _isPersonalTrip(b) ? 'Chuyến đi cá nhân' : 'Hướng dẫn viên';
    }
    return b.bookingTypeText ?? 'Khác';
  }

  String _subInfoLabel(BookingModel b) {
    final type = _bookingTypeOf(b);
    if (type == 1) return 'Mã tour: ${b.tourId ?? '-'}';
    if (type == 2) return 'Mã workshop: ${b.workshopId ?? '-'}';
    if (type == 3) {
      if (_isPersonalTrip(b)) {
        return 'Mã kế hoạch cá nhân: ${b.tripPlanId ?? '-'}';
      }
      return 'Mã hướng dẫn viên: ${b.tourGuideId ?? '-'}';
    }
    return 'Mã đặt chỗ: ${b.id}';
  }

  ImageProvider _headerImage(BookingModel b) {
    if (b.tour?.mediaList.isNotEmpty == true) {
      final url = b.tour!.mediaList.first.mediaUrl;
      if (url != null && url.startsWith('http')) return NetworkImage(url);
    }
    return const AssetImage(AssetHelper.img_tay_ninh_login);
  }

  Widget _statusChip(BookingModel b) {
  final code  = _statusCodeOf(b);
  final label = _statusLabelVi(b);

  late Color fg;       
  late Color bg;      
  late Color border;   
  late IconData icon;

  switch (code) {
    case 0: 
      fg = const Color(0xFFB46900);
      bg = const Color(0xFFFFEDD5);
      border = const Color(0xFFB46900).withOpacity(.38);
      icon = Icons.hourglass_bottom_rounded;
      break;
    case 1: 
      fg = const Color(0xFF0B6EEF);
      bg = const Color(0xFFE6F0FF);
      border = const Color(0xFF0B6EEF).withOpacity(.38);
      icon = Icons.verified_rounded;
      break;
    case 2: 
      fg = Colors.white;
      bg = Colors.green.shade600;
      border = Colors.green.shade700;
      icon = Icons.check_circle_rounded;
      break;
    case 3: 
      fg = Colors.red.shade700;
      bg = const Color(0xFFFFE6E6);
      border = Colors.red.shade400;
      icon = Icons.cancel_rounded;
      break;
    default:
      fg = Colors.white;
      bg = Colors.teal.shade600;
      border = Colors.teal.shade700;
      icon = Icons.info_rounded;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 0.9.h),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(40),

      border: Border.all(color: code == 2 ? bg : border, width: 1),
      boxShadow: [
        if (code == 2)
          BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: fg),
        SizedBox(width: 2.4.w),
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

IconData _statusIcon(int code) {
  switch (code) {
    case 0: return Icons.hourglass_bottom_rounded;
    case 1: return Icons.verified_rounded;
    case 2: return Icons.check_circle_rounded;
    case 3: return Icons.cancel_rounded;   // icon hủy
    default: return Icons.help_outline_rounded;
  }
}

  Widget _sectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18.sp, color: Colors.black87),
        if (icon != null) SizedBox(width: 2.4.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
          ),
        ),
      ],
    );
  }

  Widget _kv(String label, String value, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 16.sp, color: Colors.grey[700]),
        if (icon != null) SizedBox(width: 2.4.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.2.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value,
      {bool strong = false, Color? color}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
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
          BoxShadow(
            color: Color(0x13000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
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
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
          );
        }
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.4.h),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                    Text(
                      'Gọi hỗ trợ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 1.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .2,
                      ),
                    ),
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
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.2.h),
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
                          Text(
                            _supportPhone,
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .3,
                              color: Colors.blue.shade700,
                            ),
                          ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
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

  @override
  Widget build(BuildContext context) {
    final BookingModel b =
        booking ?? (ModalRoute.of(context)?.settings.arguments as BookingModel);

    final headerImg = _headerImage(b);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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
                            _typeLabelVi(b),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: .3,
                            ),
                          ),
                          SizedBox(height: 0.6.h),
                          Text(
                            'Mã đơn • ${b.id}',
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
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
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Thông tin đơn',
                              icon: Icons.receipt_long_outlined),
                          SizedBox(height: 1.8.h),
                          _kv('Mã đơn', b.id, icon: Icons.qr_code_2_rounded),
                          SizedBox(height: 1.4.h),
                          _kv('Loại đơn', _typeLabelVi(b),
                              icon: Icons.category_outlined),
                          SizedBox(height: 1.4.h),
                          _kv(
                            'Ngày đặt',
                            DateFormat('dd/MM/yyyy • HH:mm')
                                .format(b.bookingDate),
                            icon: Icons.calendar_month_rounded,
                          ),
                          SizedBox(height: 1.4.h),
                          _kv('Thanh toán', _statusLabelVi(b),
                              icon: Icons.payments_outlined),
                          SizedBox(height: 1.4.h),
                          _kv('Thông tin liên quan', _subInfoLabel(b),
                              icon: Icons.info_outline_rounded),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Thanh toán',
                              icon: Icons.credit_card_rounded),
                          SizedBox(height: 1.8.h),
                          _priceRow(
                              'Giá gốc', _currency.format(b.originalPrice)),
                          SizedBox(height: 1.0.h),
                          _priceRow(
                            'Khuyến mãi',
                            '- ${_currency.format(b.discountAmount)}',
                            color: Colors.teal,
                          ),
                          Divider(height: 3.2.h, thickness: 1),
                          _priceRow(
                            'Tổng thanh toán',
                            _currency.format(b.finalPrice),
                            strong: true,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (b.paymentLinkId != null && b.paymentLinkId!.isNotEmpty)
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Liên kết thanh toán',
                                icon: Icons.link_rounded),
                            SizedBox(height: 1.2.h),
                            Text(
                              'Mã liên kết: ${b.paymentLinkId}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              'Bạn có thể dùng để tra cứu thông tin thanh toán nếu cần.',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => _confirmAndCall(context),
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            decoration: BoxDecoration(
              gradient: Gradients.defaultGradientBackground,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.support_agent_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Hỗ trợ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_event.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_state.dart';
import 'package:travelogue_mobile/core/repository/refund_request_repository.dart';
import 'package:travelogue_mobile/model/refund_request/refund_request_model.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class RefundDetailScreen extends StatelessWidget {
  static const routeName = '/refund_detail';

  const RefundDetailScreen({super.key});

  NumberFormat get _currency =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

  String _fmtDateTime(DateTime? d) {
    if (d == null) return '-';
    return DateFormat('dd/MM/yyyy • HH:mm').format(d.toLocal());
  }

  ({Color fg, Color bg, Color border, IconData icon}) _statusStyle(int status) {
    switch (status) {
      case 2:
        return (
          fg: const Color(0xFF0B6EEF),
          bg: const Color(0xFFE6F0FF),
          border: const Color(0xFF0B6EEF).withOpacity(.38),
          icon: Icons.verified_rounded
        );
      case 3:
        return (
          fg: const Color(0xFFEF4444),
          bg: const Color(0xFFFFE6E6),
          border: const Color(0xFFEF4444).withOpacity(.35),
          icon: Icons.report_gmailerrorred_rounded
        );
      case 1:
      default:
        return (
          fg: const Color(0xFFB46900),
          bg: const Color(0xFFFFEDD5),
          border: const Color(0xFFB46900).withOpacity(.38),
          icon: Icons.hourglass_bottom_rounded
        );
    }
  }

  Widget _statusChip(RefundRequestModel r) {
    final s = _statusStyle(r.status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: .9.h),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: s.border, width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(s.icon, size: 16.sp, color: s.fg),
        SizedBox(width: 2.4.w),
        Text(r.statusText,
            style: TextStyle(
              color: s.fg,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            )),
      ]),
    );
  }

  Widget _sectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18.sp, color: Colors.black87),
        if (icon != null) SizedBox(width: 2.4.w),
        Text(title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _kv(String label, String value,
      {IconData? icon, TextAlign align = TextAlign.right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 16.sp, color: Colors.grey[700]),
        if (icon != null) SizedBox(width: 2.4.w),
        Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]))),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(value.isEmpty ? '-' : value,
              textAlign: align,
              style: TextStyle(
                  fontSize: 13.2.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
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
              color: Color(0x13000000), blurRadius: 14, offset: Offset(0, 6)),
        ],
        border: Border.all(color: Colors.grey.withOpacity(.08)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
  
    final args = ModalRoute.of(context)?.settings.arguments;
    String refundRequestId;
    String? bookingTitle;

    if (args is Map) {
      refundRequestId = (args['refundId'] as String?) ?? '';
      bookingTitle = args['bookingTitle'] as String?;
    } else {
      refundRequestId = args as String;
    }

    return BlocProvider(
      create: (_) => RefundBloc(RefundRepository())
        ..add(LoadRefundRequestDetailEvent(refundRequestId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<RefundBloc, RefundState>(
            builder: (context, state) {
              if (state is RefundLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RefundDetailLoadFailure) {
                return Center(child: Text('Lỗi: ${state.error}'));
              }
              if (state is! RefundDetailLoaded) {
                return const SizedBox.shrink();
              }

              final r = state.refund;

      
              final safeDisplayTitle =
                  bookingTitle?.trim().isNotEmpty == true
                      ? bookingTitle!.trim()
                      : 'Đơn #${r.bookingId}';

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 28.h,
                    pinned: true,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                    
                          const Image(
                            image: AssetImage(AssetHelper.img_tay_ninh_login),
                            fit: BoxFit.cover,
                          ),
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
                            top: 2.h,
                            left: 4.w,
                            right: 4.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _roundIcon(context,
                                    icon: Icons.arrow_back_ios_new_rounded,
                                    onTap: () => Navigator.pop(context)),
                                _roundIcon(context,
                                    icon: Icons.more_horiz_rounded,
                                    onTap: () {}),
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
                                  safeDisplayTitle,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.6.h),
                                Text('Chi tiết hoàn tiền',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.2.h),
                                _statusChip(r),
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
                          _card(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle('Thông tin',
                                  icon: Icons.receipt_long),
                              SizedBox(height: 1.6.h),

                       
                              _kv('Đơn / tiêu đề', safeDisplayTitle,
                                  icon: Icons.confirmation_number),

                              SizedBox(height: 1.4.h),
                              _kv('Người yêu cầu', r.userName,
                                  icon: Icons.person),
                              SizedBox(height: 1.4.h),
                              _kv('Số tiền hoàn',
                                  _currency.format(r.refundAmount),
                                  icon: Icons.payments_rounded),

                              if ((r.rejectionReason ?? '').isNotEmpty) ...[
                                SizedBox(height: 1.4.h),
                                _kv('Lý do từ chối', r.rejectionReason!,
                                    icon: Icons.report_gmailerrorred_outlined,
                                    align: TextAlign.left),
                              ],
                              if ((r.note ?? '').isNotEmpty) ...[
                                SizedBox(height: 1.4.h),
                                _kv('Ghi chú', r.note!,
                                    icon: Icons.sticky_note_2_outlined,
                                    align: TextAlign.left),
                              ],
                            ],
                          )),

                          SizedBox(height: 2.h),

                          // (Giữ nguyên nhóm thời gian nếu cần hiển thị)
                          // _card(Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     _sectionTitle('Thời gian', icon: Icons.schedule),
                          //     SizedBox(height: 1.6.h),
                          //     _kv('Ngày tạo', _fmtDateTime(r.createdTime),
                          //         icon: Icons.event_available_outlined),
                          //     SizedBox(height: 1.4.h),
                          //     _kv('Cập nhật', _fmtDateTime(r.lastUpdatedTime),
                          //         icon: Icons.update),
                          //     SizedBox(height: 1.4.h),
                          //     _kv('Requested', _fmtDateTime(r.requestedAt),
                          //         icon: Icons.outgoing_mail),
                          //     SizedBox(height: 1.4.h),
                          //     _kv('Responded', _fmtDateTime(r.respondedAt),
                          //         icon: Icons.mark_email_read_outlined),
                          //   ],
                          // )),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 24),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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

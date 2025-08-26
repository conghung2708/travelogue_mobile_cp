import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_bloc.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_event.dart';
import 'package:travelogue_mobile/core/blocs/request_refund/request_refund_state.dart';
import 'package:travelogue_mobile/model/refund_request/refund_request_model.dart';
import 'package:travelogue_mobile/representation/booking/screens/refund_detail_screen.dart';

class _AppColors {
  static const Color scaffold = Colors.white;
  static const Color primary = Color(0xFF4F8EF7);
  static const Color primarySoft = Color(0xFFE9F2FF);
  static const Color primaryBorder = Color(0xFFD4E6FF);
  static const Color textStrong = Color(0xFF0F172A);
  static const Color text = Color(0xFF334155);
  static const Color textMute = Color(0xFF64748B);
}

class RefundListScreen extends StatefulWidget {
  final Map<String, String> bookingTitleLookup;


  final String? focusBookingId;

  const RefundListScreen({
    super.key,
    this.bookingTitleLookup = const {},
    this.focusBookingId,
  });

  @override
  State<RefundListScreen> createState() => _RefundListScreenState();
}

enum RefundStatusFilter { all, pending, approved, rejected }

class _RefundListScreenState extends State<RefundListScreen> {
  final _currency =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
  final _searchCtrl = TextEditingController();

  RefundStatusFilter _statusFilter = RefundStatusFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    
      final focusId = widget.focusBookingId;
      if (focusId != null && focusId.isNotEmpty) {
        final focusTitle = widget.bookingTitleLookup[focusId];
        if (focusTitle != null && focusTitle.isNotEmpty) {
          _searchCtrl.text = focusTitle;
        }
      }
      _reload();
    });
  }

  void _reload() {
    context.read<RefundBloc>().add(const LoadUserRefundRequestsEvent());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appbarTitleStyle = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w800,
      color: _AppColors.textStrong,
    );

    return Scaffold(
      backgroundColor: _AppColors.scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _AppColors.scaffold,
        title: Text('Yêu cầu hoàn tiền', style: appbarTitleStyle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh, color: _AppColors.textStrong),
            tooltip: 'Tải lại',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
         
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.2.h),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                    fontSize: 12.5.sp,
                    color: _AppColors.textStrong,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: _AppColors.text),
                  hintText: 'Tìm theo tên đơn/tiêu đề…',
                  hintStyle:
                      TextStyle(fontSize: 12.sp, color: _AppColors.textMute),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1.6.h, horizontal: 4.w),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: _AppColors.primaryBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: _AppColors.primary, width: 1.2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('Tất cả', RefundStatusFilter.all),
                    SizedBox(width: 2.2.w),
                    _filterChip('Chờ xử lý', RefundStatusFilter.pending),
                    SizedBox(width: 2.2.w),
                    _filterChip('Đã duyệt', RefundStatusFilter.approved),
                    SizedBox(width: 2.2.w),
                    _filterChip('Từ chối', RefundStatusFilter.rejected),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.2.h),
            Expanded(
              child: BlocBuilder<RefundBloc, RefundState>(
                builder: (context, state) {
                  if (state is RefundLoading) {
                    return _LoadingListSkeleton();
                  }
                  if (state is RefundListLoadFailure) {
                    return _ErrorView(message: state.error, onRetry: _reload);
                  }
                  if (state is RefundListLoaded) {
               
                    List<RefundRequestModel> refunds = state.refunds;

                    final q = _searchCtrl.text.trim().toLowerCase();
              
                    if (q.isNotEmpty) {
                      refunds = refunds.where((r) {
                        final title = widget.bookingTitleLookup[r.bookingId] ??
                            'Đơn #${r.bookingId}';
                        return title.toLowerCase().contains(q);
                      }).toList();
                    }

                    refunds = refunds.where((r) {
                      switch (_statusFilter) {
                        case RefundStatusFilter.pending:
                          return r.status == 1;
                        case RefundStatusFilter.approved:
                          return r.status == 2;
                        case RefundStatusFilter.rejected:
                          return r.status == 3;
                        case RefundStatusFilter.all:
                          return true;
                      }
                    }).toList();

                    if (refunds.isEmpty) {
                      return _EmptyView(onCreate: () {});
                    }

                    final total =
                        refunds.fold<int>(0, (sum, e) => sum + e.refundAmount);

                    return RefreshIndicator(
                      onRefresh: () async => _reload(),
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.6.h),
                        children: [
                          _SummaryHeader(
                            count: refunds.length,
                            totalAmountText: _currency.format(total),
                          ),
                          SizedBox(height: 1.6.h),
                          ...refunds.map((r) {
                            final displayTitle =
                                widget.bookingTitleLookup[r.bookingId] ??
                                    'Đơn #${r.bookingId}';
                            return _RefundCard(
                              data: r,
                              currency: _currency,
                              displayTitle: displayTitle, 
                              onCancel: r.status == 1
                                  ? () => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Tính năng hủy sẽ được cập nhật.')),
                                      )
                                  : null,
                              onWithdraw: r.status == 2
                                  ? () async {
                                      final ok = await showDialog<bool>(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text('Rút tiền về ví'),
                                              content: Text(
                                                  'Bạn muốn rút ${_currency.format(r.refundAmount)} về ví chứ?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: const Text('Hủy')),
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: const Text('Rút')),
                                              ],
                                            ),
                                          ) ??
                                          false;
                                      if (!ok) {
                                        return;
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Đã gửi yêu cầu rút tiền (FE-only).')),
                                      );

                                      // _reload();
                                    }
                                  : null,
                              onViewDetail: () {
                        
                                Navigator.of(context).pushNamed(
                                  RefundDetailScreen.routeName,
                                  arguments: {
                                    'refundId': r.id,
                                    'bookingTitle': displayTitle,
                                  },
                                );
                              },
                            );
                          }),
                          SizedBox(height: 2.4.h),
                        ],
                      ),
                    );
                  }
                  return _EmptyView(onCreate: () {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, RefundStatusFilter value) {
    final selected = _statusFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
          color: selected ? Colors.white : _AppColors.textStrong,
        ),
      ),
      selected: selected,
      onSelected: (_) => setState(() => _statusFilter = value),
      selectedColor: _AppColors.primary,
      backgroundColor: _AppColors.primarySoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
            color: selected ? _AppColors.primary : _AppColors.primaryBorder),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(horizontal: 3.4.w, vertical: .8.h),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int count;
  final String totalAmountText;

  const _SummaryHeader({required this.count, required this.totalAmountText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.2.h),
        border: Border.all(color: _AppColors.primaryBorder),
        boxShadow: [
          BoxShadow(
            color: _AppColors.primary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _Pill(icon: Icons.receipt_long, label: '$count yêu cầu'),
          SizedBox(width: 3.4.w),
          _Pill(icon: Icons.payments_outlined, label: 'Tổng: $totalAmountText'),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.1.h, horizontal: 3.4.w),
      decoration: BoxDecoration(
        color: _AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _AppColors.primaryBorder),
      ),
      child: Row(children: [
        Icon(icon, size: 17.sp, color: _AppColors.primary),
        SizedBox(width: 2.2.w),
        Text(label,
            style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: _AppColors.textStrong)),
      ]),
    );
  }
}

class _RefundCard extends StatelessWidget {
  final RefundRequestModel data;
  final NumberFormat currency;

  final String displayTitle;

  final VoidCallback? onCancel;
  final VoidCallback? onWithdraw;


  final VoidCallback? onViewDetail;

  const _RefundCard({
    required this.data,
    required this.currency,
    required this.displayTitle,
    this.onCancel,
    this.onWithdraw,
    this.onViewDetail,
  });

  Color _statusColor(int status) {
    switch (status) {
      case 2:
        return const Color(0xFF16A34A); // approved
      case 3:
        return const Color(0xFFEF4444); // rejected
      case 1:
      default:
        return const Color(0xFFF59E0B); // pending
    }
  }

  String _formatDate(DateTime dt) =>
      DateFormat('dd/MM/yyyy HH:mm').format(dt.toLocal());

  @override
  Widget build(BuildContext context) {
    final amountText = currency.format(data.refundAmount);

    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.2.h),
        border: Border.all(color: _AppColors.primaryBorder),
        boxShadow: [
          BoxShadow(
            color: _AppColors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Title (thay vì mã) + Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.confirmation_number_outlined,
                  size: 20.sp, color: _AppColors.textStrong),
              SizedBox(width: 2.8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                    Text('Tên Đơn',
                        style: TextStyle(
                            fontSize: 10.5.sp,
                            color: _AppColors.textMute,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: .4.h),
                
                    Text(
                      displayTitle,
                      style: TextStyle(
                          fontSize: 13.2.sp,
                          fontWeight: FontWeight.w900,
                          color: _AppColors.textStrong),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _StatusChip(
                  text: data.statusText, color: _statusColor(data.status)),
            ],
          ),
          SizedBox(height: 1.8.h),

         
          Row(
            children: [
              Expanded(
                  child: _FieldTile(
                      icon: Icons.person_outline,
                      title: 'Người yêu cầu',
                      value: data.userName)),
              SizedBox(width: 3.2.w),
              Expanded(
                  child: _FieldTile(
                      icon: Icons.payments_outlined,
                      title: 'Số tiền hoàn',
                      value: amountText)),
            ],
          ),
          SizedBox(height: 1.2.h),

       
          Row(
            children: [
              Expanded(
                  child: _FieldTile(
                      icon: Icons.event_available_outlined,
                      title: 'Ngày tạo',
                      value: _formatDate(data.createdTime))),
              SizedBox(width: 3.2.w),
              Expanded(
                  child: _FieldTile(
                      icon: Icons.update,
                      title: 'Cập nhật',
                      value: _formatDate(data.lastUpdatedTime))),
            ],
          ),

          if ((data.rejectionReason ?? '').isNotEmpty) ...[
            SizedBox(height: 1.2.h),
            _FieldTile(
                icon: Icons.report_gmailerrorred_outlined,
                title: 'Lý do từ chối',
                value: data.rejectionReason!,
                isMultiline: true),
          ],

          SizedBox(height: 1.4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetail,
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text('Xem chi tiết',
                      style: TextStyle(
                          fontSize: 11.5.sp, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _AppColors.primary,
                    side: const BorderSide(color: _AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 1.4.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.6.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isMultiline;

  const _FieldTile(
      {required this.icon,
      required this.title,
      required this.value,
      this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18.sp, color: _AppColors.textStrong),
        SizedBox(width: 2.6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      color: _AppColors.textMute,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: .4.h),
              Text(
                value,
                style: TextStyle(
                    fontSize: 12.8.sp,
                    fontWeight: FontWeight.w800,
                    color: _AppColors.textStrong),
                maxLines: isMultiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: .7.h, horizontal: 3.2.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 10.8.sp, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class _LoadingListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 1.6.h),
      itemBuilder: (_, __) => Container(
        height: 16.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.2.h),
          border: Border.all(color: _AppColors.primaryBorder),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyView({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 30.sp, color: _AppColors.primary.withOpacity(.5)),
            SizedBox(height: 1.8.h),
            Text('Chưa có yêu cầu hoàn tiền',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: _AppColors.textStrong)),
            SizedBox(height: 1.0.h),
            Text(
              'Tạo yêu cầu hoàn tiền cho booking của bạn để hiển thị tại đây.',
              style: TextStyle(fontSize: 12.sp, color: _AppColors.text),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.2.h),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text('Tạo yêu cầu',
                  style: TextStyle(
                      fontSize: 12.2.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 6.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.6.h)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 30.sp, color: const Color(0xffEF4444)),
            SizedBox(height: 1.8.h),
            Text('Không tải được dữ liệu',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: _AppColors.textStrong)),
            SizedBox(height: .8.h),
            Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: _AppColors.text),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.2.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('Thử lại',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: _AppColors.primary)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _AppColors.primary,
                side: const BorderSide(color: _AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 6.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.6.h)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

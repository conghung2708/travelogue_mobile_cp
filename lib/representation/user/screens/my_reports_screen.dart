// lib/representation/report/screens/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/report/report_bloc.dart';
import 'package:travelogue_mobile/core/blocs/report/report_event.dart';
import 'package:travelogue_mobile/core/blocs/report/report_state.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/report/report_model.dart';
import 'package:travelogue_mobile/representation/widgets/glass_app_bar.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  static const routeName = '/my_reports';

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

enum _Filter { all, pending, accepted, rejected }

class _MyReportsScreenState extends State<MyReportsScreen> {
  _Filter _filter = _Filter.all;

  @override
  void initState() {
    super.initState();
    AppBloc.reportBloc.add(const FetchMyReportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bg = ColorPalette.backgroundScaffoldColor;

    return Scaffold(
      backgroundColor: bg,
      // ✅ Dùng GlassAppBar thay cho AppBar mặc định
      appBar: const GlassAppBar(
        title: 'Quản lý báo cáo',
        subtitle: 'Theo dõi & quản lý báo cáo của bạn',
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        bloc: AppBloc.reportBloc,
        listener: (context, state) {
          if (state is MyReportsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Thành công')),
            );
          } else if (state is ReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is MyReportsLoading) return const _LoadingView();
          if (state is ReportFailure) {
            return _ErrorView(
              message: state.error,
              onRetry: () => AppBloc.reportBloc.add(const FetchMyReportsEvent()),
            );
          }
          if (state is! MyReportsLoaded) return const SizedBox.shrink();

          final all = state.reports;
          final pending = all.where((e) => e.status == 1).toList();
          final accepted = all.where((e) => e.status == 2).toList();
          final rejected = all.where((e) => e.status == 3).toList();

          final list = switch (_filter) {
            _Filter.all => all,
            _Filter.pending => pending,
            _Filter.accepted => accepted,
            _Filter.rejected => rejected,
          };

          return RefreshIndicator(
            onRefresh: () async =>
                AppBloc.reportBloc.add(const FetchMyReportsEvent()),
            color: ColorPalette.primaryColor,
            child: ListView(
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
              children: [
                _SummaryHeader(
                  total: all.length,
                  pending: pending.length,
                  accepted: accepted.length,
                  rejected: rejected.length,
                  onRefresh: () =>
                      AppBloc.reportBloc.add(const FetchMyReportsEvent()),
                ),
                SizedBox(height: 1.8.h),
                _FilterBar(
                  value: _filter,
                  onChanged: (v) => setState(() => _filter = v),
                ),
                SizedBox(height: 1.2.h),
                if (list.isEmpty)
                  _EmptySection(
                    title: switch (_filter) {
                      _Filter.pending => 'Không có báo cáo đang chờ',
                      _Filter.accepted => 'Chưa có báo cáo được chấp nhận',
                      _Filter.rejected => 'Chưa có báo cáo bị từ chối',
                      _ => 'Bạn chưa có báo cáo nào',
                    },
                    subtitle:
                        'Báo cáo các đánh giá không phù hợp và quản lý tại đây.',
                    onRefresh: () =>
                        AppBloc.reportBloc.add(const FetchMyReportsEvent()),
                  )
                else
                  ...list.map((r) => _ReportItem(
                        report: r,
                        isPending: r.status == 1,
                        onEdit:
                            r.status == 1 ? () => _openEditSheet(context, r) : null,
                        onDelete: r.status == 1
                            ? () => _confirmDelete(context, r.id)
                            : null,
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String reportId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xoá báo cáo'),
        content: const Text('Bạn chắc chắn muốn xoá báo cáo này?'),
        actionsPadding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorPalette.dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete_outline),
            onPressed: () => Navigator.pop(context, true),
            label: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok == true) AppBloc.reportBloc.add(DeleteMyReportEvent(reportId));
  }

  void _openEditSheet(BuildContext context, ReportModel r) {
    final controller = TextEditingController(text: r.reason);
    final suggestions = const [
      'Spam / Quảng cáo',
      'Ngôn ngữ xúc phạm',
      'Sai sự thật',
      'Nội dung không phù hợp',
    ];
    String? selected;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 2.h,
            top: 1.6.h,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              final note = controller.text.trim();
              final canSave = (selected != null) || note.isNotEmpty;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 12.w,
                      height: .7.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    'Cập nhật lý do báo cáo',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    'Chọn lý do nhanh',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.subTitleColor,
                    ),
                  ),
                  SizedBox(height: .8.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: suggestions.map((s) {
                      final sel = selected == s;
                      return ChoiceChip(
                        label: Text(
                          s,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: sel ? ColorPalette.primaryColor : Colors.black87,
                          ),
                        ),
                        selected: sel,
                        selectedColor: ColorPalette.primaryColor.withOpacity(.15),
                        backgroundColor: Colors.grey[100],
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: sel
                                ? ColorPalette.primaryColor.withOpacity(.45)
                                : ColorPalette.dividerColor,
                          ),
                        ),
                        onSelected: (_) => setState(() => selected = s),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 1.6.h),
                  Text(
                    'Mô tả chi tiết (tuỳ chọn)',
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: .6.h),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(fontSize: 12.5.sp),
                    decoration: InputDecoration(
                      hintText: 'Bạn có thể mô tả thêm…',
                      hintStyle: TextStyle(fontSize: 12.5.sp, color: Colors.black45),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.6.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: ColorPalette.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: ColorPalette.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.6.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ColorPalette.dividerColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Huỷ'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _GradientButton(
                          label: 'Lưu',
                          icon: Icons.save_outlined,
                          onTap: canSave
                              ? () {
                                  final text = controller.text.trim();
                                  late final String reason;
                                  if (selected != null && text.isNotEmpty) {
                                    reason = 'Lý do: $selected. Mô tả: $text';
                                  } else {
                                    reason = selected ?? text;
                                  }
                                  AppBloc.reportBloc.add(UpdateMyReportEvent(
                                    reportId: r.id,
                                    reason: reason,
                                  ));
                                  Navigator.pop(ctx);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/* ====================== Header tóm tắt (gradient) ====================== */
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.total,
    required this.pending,
    required this.accepted,
    required this.rejected,
    required this.onRefresh,
  });

  final int total;
  final int pending;
  final int accepted;
  final int rejected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.6.w),
      decoration: BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryColor.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Metric(number: total, label: 'Tổng'),
            _MetricDivider(),
            _Metric(number: pending, label: 'Đang chờ'),
            _MetricDivider(),
            _Metric(number: accepted, label: 'Đã chấp nhận'),
            _MetricDivider(),
            _Metric(number: rejected, label: 'Đã từ chối'),
            SizedBox(width: 2.w),
            InkWell(
              onTap: onRefresh,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: EdgeInsets.all(2.2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(.35)),
                ),
                child: const Icon(Icons.refresh, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.number, required this.label});
  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              '$number',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.05,
              ),
            ),
            SizedBox(height: .3.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0.w,
      height: 5.2.h,
      margin: EdgeInsets.symmetric(horizontal: 2.0.w),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

/* ====================== Filter bar ====================== */
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.value, required this.onChanged});
  final _Filter value;
  final ValueChanged<_Filter> onChanged;

  @override
  Widget build(BuildContext context) {
    final chips = [
      (_Filter.all, 'Tất cả'),
      (_Filter.pending, 'Đang chờ'),
      (_Filter.accepted, 'Đã chấp nhận'),
      (_Filter.rejected, 'Đã từ chối'),
    ];

    return Wrap(
      spacing: 2.6.w,
      runSpacing: 1.w,
      children: chips.map((e) {
        final sel = value == e.$1;
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onChanged(e.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
            decoration: BoxDecoration(
              gradient: sel ? Gradients.defaultGradientBackground : null,
              color: sel ? null : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: sel ? Colors.transparent : ColorPalette.dividerColor,
              ),
              boxShadow: sel
                  ? [
                      BoxShadow(
                        color: ColorPalette.primaryColor.withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (sel) ...[
                  const Icon(Icons.check, size: 16, color: Colors.white),
                  SizedBox(width: 1.6.w),
                ],
                Text(
                  e.$2,
                  style: TextStyle(
                    fontSize: 11.8.sp,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/* ====================== Item ====================== */
class _ReportItem extends StatelessWidget {
  const _ReportItem({
    required this.report,
    required this.isPending,
    this.onEdit,
    this.onDelete,
  });

  final ReportModel report;
  final bool isPending;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(3.6.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorPalette.yellowColor.withOpacity(.25),
              child: const Icon(Icons.outlined_flag, color: Colors.orange),
            ),
            SizedBox(width: 3.6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusChip(status: report.status),
                      const Spacer(),
                      Text(
                        _fmtTime(report.reportedAt ?? report.createdTime),
                        style: TextStyle(fontSize: 10.5.sp, color: Colors.black54),
                      ),
                      if (isPending) _ItemMenu(onEdit: onEdit, onDelete: onDelete),
                    ],
                  ),
                  SizedBox(height: .8.h),
                  Text(
                    report.reason,
                    style: TextStyle(fontSize: 12.8.sp, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: .4.h),
                  Text(
                    'Review ID: ${_short(report.reviewId)}',
                    style: TextStyle(fontSize: 10.5.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!isPending || onDelete == null) return card;

    return Dismissible(
      key: ValueKey(report.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 5.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        onDelete!.call();
        return false;
      },
      child: card,
    );
  }

  static String _fmtTime(DateTime? t) {
    if (t == null) return '';
    final d = t.toLocal();
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  static String _short(String s) {
    if (s.length <= 10) return s;
    return '${s.substring(0, 6)}…${s.substring(s.length - 4)}';
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({this.onEdit, this.onDelete});
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Tùy chọn',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (v) {
        if (v == 'edit') onEdit?.call();
        if (v == 'delete') onDelete?.call();
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, size: 18),
            title: Text('Sửa lý do'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline, size: 18),
            title: Text('Xoá'),
          ),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: const Icon(Icons.more_horiz, color: Colors.black45),
      ),
    );
  }
}

/* ====================== Status chip ====================== */
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final int status; // 1 pending, 2 accepted, 3 rejected

  @override
  Widget build(BuildContext context) {
    final isPending = status == 1;
    final isAccepted = status == 2;
    final isRejected = status == 3;

    late final Color bg;
    late final Color fg;
    late final String text;

    if (isPending) {
      bg = ColorPalette.yellowColor.withOpacity(.22);
      fg = const Color(0xFFB36A00);
      text = 'Đang chờ duyệt';
    } else if (isAccepted) {
      bg = Colors.green.withOpacity(.16);
      fg = Colors.green[800]!;
      text = 'Đã chấp nhận';
    } else {
      bg = Colors.red.withOpacity(.16);
      fg = Colors.red[800]!;
      text = 'Đã từ chối';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.4.w, vertical: .6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(.35)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.8.sp, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

/* ====================== States ====================== */
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
      itemBuilder: (_, __) => Container(
        height: 10.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorPalette.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorPalette.dividerColor),
      ),
      child: Column(
        children: [
          Icon(Icons.outlined_flag, size: 40.sp, color: Colors.black26),
          SizedBox(height: 1.2.h),
          Text(title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: .4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.3.sp, color: Colors.black54),
          ),
          SizedBox(height: 1.2.h),
          _GradientButton(
            label: 'Tải lại',
            icon: Icons.refresh,
            onTap: onRefresh,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red[400]),
            SizedBox(height: 1.2.h),
            Text('Đã có lỗi xảy ra',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: .4.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.3.sp, color: Colors.black54),
            ),
            SizedBox(height: 1.2.h),
            _GradientButton(
              label: 'Thử lại',
              icon: Icons.refresh,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/* ====================== Buttons dùng gradient ====================== */
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onTap != null;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isEnabled ? Gradients.defaultGradientBackground : null,
          color: isEnabled ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isEnabled ? onTap : null,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

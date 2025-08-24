import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/wallet/wallet_bloc.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_event.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_state.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_model.dart';

class WithdrawHistoryScreen extends StatefulWidget {
  const WithdrawHistoryScreen({super.key});

  @override
  State<WithdrawHistoryScreen> createState() => _WithdrawHistoryScreenState();
}

class _WithdrawHistoryScreenState extends State<WithdrawHistoryScreen> {
  int? _statusFilter; // null: tất cả, 1/2/3 theo API

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<WalletBloc>().add(
          LoadMyWithdrawalRequestsEvent(status: _statusFilter),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lịch sử rút tiền',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 1.h),
          _StatusChips(
            current: _statusFilter,
            onChanged: (val) {
              setState(() => _statusFilter = val);
              _load();
            },
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WalletFailure) {
                  return _ErrorView(
                    message: state.error,
                    onRetry: _load,
                  );
                }
                if (state is WalletListLoaded) {
                  final items = state.items;
                  if (items.isEmpty) {
                    return _EmptyView(onRefresh: _load);
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _load(),
                    color: const Color(0xFF3A7DFF),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
                      itemBuilder: (_, i) => _WithdrawCard(
                        item: items[i],
                        onTap: () => _showWithdrawDetail(context, items[i]),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDetail(BuildContext context, WithdrawalRequestModel m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            4.w,
            1.h,
            4.w,
            MediaQuery.of(context).viewInsets.bottom + 2.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: Color(0xFF3A7DFF)),
                  SizedBox(width: 2.w),
                  Text('Chi tiết yêu cầu rút',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
                ],
              ),
              SizedBox(height: 1.2.h),
              _kv('Mã yêu cầu', m.id),
              _kv('Số tiền', '${m.amount.vnd()} đ'),
              _kv('Trạng thái', m.statusText.isNotEmpty ? m.statusText : _fallbackStatusText(m.status)),
              _kv('Thời gian tạo', _fmtDate(m.requestTime)),
              if (m.bankAccount != null) ...[
                SizedBox(height: .6.h),
                const Divider(),
                SizedBox(height: .6.h),
                Row(
                  children: [
                    const Icon(Icons.account_balance_rounded, color: Color(0xFF3A7DFF)),
                    SizedBox(width: 2.w),
                    Text('Ngân hàng', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp)),
                  ],
                ),
                SizedBox(height: .6.h),
                _kv('Tên NH', m.bankAccount!.bankName ?? '-'),
                _kv('Số TK', m.bankAccount!.bankAccountNumber ?? '-'),
                _kv('Chủ TK', m.bankAccount!.bankOwnerName ?? '-'),
              ],
              SizedBox(height: 1.4.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Đóng'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: EdgeInsets.symmetric(vertical: .6.h),
        child: Row(
          children: [
            Expanded(child: Text(k, style: TextStyle(color: Colors.grey[700], fontSize: 11.8.sp))),
            Text(v, style: TextStyle(fontSize: 12.8.sp, fontWeight: FontWeight.w800)),
          ],
        ),
      );

  String _fmtDate(DateTime dt) {
    final two = (int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  String _fallbackStatusText(int s) {
    switch (s) {
      case 1:
        return 'Đang chờ';
      case 2:
        return 'Đã duyệt';
      case 3:
        return 'Từ chối';
      default:
        return 'Không rõ';
    }
  }
}

/// ================== Filter Chips (đẹp, có icon, hiệu ứng) ==================
class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.current, required this.onChanged});
  final int? current;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    // Dùng map để tương thích Dart < 3 (không dùng record type)
    final items = <Map<String, dynamic>>[
      {'label': 'Tất cả', 'icon': Icons.all_inbox_rounded, 'value': null},
      {'label': 'Đang chờ', 'icon': Icons.schedule_rounded, 'value': 1},
      {'label': 'Đã duyệt', 'icon': Icons.verified_rounded, 'value': 2},
      {'label': 'Từ chối', 'icon': Icons.cancel_rounded, 'value': 3},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final it in items)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(it['value'] as int?),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: .9.h),
                  decoration: BoxDecoration(
                    color: current == it['value'] ? const Color(0xFF3A7DFF) : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: current == it['value'] ? const Color(0xFF3A7DFF) : Colors.grey.shade300,
                    ),
                    boxShadow: current == it['value']
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3A7DFF).withOpacity(.18),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : const [],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        it['icon'] as IconData,
                        size: 16,
                        color: current == it['value'] ? Colors.white : Colors.black87,
                      ),
                      SizedBox(width: 1.2.w),
                      Text(
                        it['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5.sp,
                          color: current == it['value'] ? Colors.white : Colors.black87,
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

/// ================== Withdrawal Card (mềm, gradient, animation) ==================
class _WithdrawCard extends StatelessWidget {
  const _WithdrawCard({required this.item, this.onTap});
  final WithdrawalRequestModel item;
  final VoidCallback? onTap;

  (Color bg, Color fg, IconData icon) _statusStyle(int s) {
    switch (s) {
      case 1:
        return (const Color(0xFFFFF3CD), const Color(0xFFB46900), Icons.schedule_rounded);
      case 2:
        return (const Color(0xFFD1E7DD), const Color(0xFF0F5132), Icons.verified_rounded);
      case 3:
        return (const Color(0xFFF8D7DA), const Color(0xFF842029), Icons.cancel_rounded);
      default:
        return (Colors.grey.shade200, Colors.black87, Icons.help_outline_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tuple = _statusStyle(item.status);
    final Color bg = tuple.$1;
    final Color fg = tuple.$2;
    final IconData ic = tuple.$3;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(3.8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF3A7DFF).withOpacity(.12)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 14, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // leading avatar gradient
              Container(
                height: 6.6.h,
                width: 6.6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6EA5FF), Color(0xFF3A7DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.payments_rounded, color: Colors.white),
              ),
              SizedBox(width: 3.w),

              // content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // amount + status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.amount.vnd()} đ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .6.h),
                          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(ic, size: 16, color: fg),
                              SizedBox(width: 1.w),
                              Text(
                                (item.statusText.isNotEmpty ? item.statusText : _fallbackStatusText(item.status)),
                                style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 10.5.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: .8.h),

                    // meta line
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2.w,
                      runSpacing: .8.h,
                      children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.schedule_rounded, size: 16, color: Colors.grey),
                          SizedBox(width: 1.w),
                          Text(_fmtDate(item.requestTime),
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5.sp)),
                        ]),
                        Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.tag_rounded, size: 16, color: Colors.grey),
                          SizedBox(width: 1.w),
                          Text(item.id.length > 8 ? '#${item.id.substring(0, 8)}' : '#${item.id}',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5.sp)),
                        ]),
                        if (item.bankAccount != null) ...[
                          Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle)),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.account_balance_rounded, size: 16, color: Colors.grey),
                            SizedBox(width: 1.w),
                            Text(
                              '${item.bankAccount!.bankName ?? '-'} • ${item.bankAccount!.bankAccountNumber ?? ''}',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2.w),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _fallbackStatusText(int s) {
    switch (s) {
      case 1:
        return 'Đang chờ';
      case 2:
        return 'Đã duyệt';
      case 3:
        return 'Từ chối';
      default:
        return 'Không rõ';
    }
  }

  String _fmtDate(DateTime dt) {
    final two = (int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }
}

/// ================== Empty / Error Views (bóng bẩy) ==================
class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: const Color(0xFF3A7DFF),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 18.h),
          Container(
            height: 12.h,
            width: 12.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF6EA5FF), Color(0xFF3A7DFF)]),
              boxShadow: [BoxShadow(color: const Color(0xFF3A7DFF).withOpacity(.18), blurRadius: 18)],
            ),
            child: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 42),
          ),
          SizedBox(height: 1.2.h),
          Text('Chưa có yêu cầu rút',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: .6.h),
          Text(
            'Khi bạn gửi yêu cầu rút tiền, lịch sử sẽ hiển thị ở đây.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 3.h),
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
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 36.sp, color: Colors.redAccent),
            SizedBox(height: 1.h),
            Text('Không tải được dữ liệu',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: .6.h),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 1.2.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A7DFF)),
            )
          ],
        ),
      ),
    );
  }
}

/// ================== Helpers ==================
extension _VndView on num {
  String vnd() {
    final s = toStringAsFixed(0);
    final rev = s.split('').reversed.join();
    final chunks = <String>[];
    for (var i = 0; i < rev.length; i += 3) {
      chunks.add(rev.substring(i, (i + 3).clamp(0, rev.length)));
    }
    final joined = chunks.join('.');
    return joined.split('').reversed.join();
  }
}

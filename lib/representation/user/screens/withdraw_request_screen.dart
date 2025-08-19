// lib/features/withdraw/presentation/withdraw_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_bloc.dart';
import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_event.dart';
import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_state.dart';
import 'package:travelogue_mobile/core/blocs/bank_lookup/bank_lookup_cubit.dart';
import 'package:travelogue_mobile/model/bank_account/bank_account_model.dart';
import 'package:travelogue_mobile/model/bank_account/bank_lookup_models.dart';

// Wallet
import 'package:travelogue_mobile/core/blocs/wallet/wallet_bloc.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_event.dart';
import 'package:travelogue_mobile/core/blocs/wallet/wallet_state.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_create_model.dart';

// Update bank account model
import 'package:travelogue_mobile/model/bank_account/bank_account_model.dart'
    show UpdateBankAccountModel;

/// === Args nhận từ màn profile
class WithdrawRequestArgs {
  final num balance;
  const WithdrawRequestArgs({required this.balance});
}

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({super.key});
  static const routeName = '/withdraw-request';

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  // keys
  final _formKeyWithdraw = GlobalKey<FormState>();
  final _formKeyCreate = GlobalKey<FormState>();

  // controllers
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  BankLookupItem? _selectedBank;

  static const double _maxContentWidth = 680; // căn giữa & giới hạn bề rộng

  // nhận số dư từ args
  num _availableBalance = 0;
  static const int _minAmount = 10000; // yêu cầu tối thiểu 10 đ

  // giữ tk mặc định để gửi kèm yêu cầu rút
  BankAccountModel? _defaultAcc;

  @override
  void initState() {
    super.initState();
    context.read<BankAccountBloc>().add(const GetBankAccountsEvent());
    context.read<BankLookupCubit>().loadBanks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is WithdrawRequestArgs) {
      _availableBalance = args.balance;
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bankLookup = context.watch<BankLookupCubit>().state;
    final isSubmitting = context.watch<WalletBloc>().state is WalletLoading;

    return Scaffold(
      backgroundColor: _P.bg,
      body: Stack(
        children: [
          _Header(),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 17.h, 4.w, 2.h),
                  child: MultiBlocListener(
                    listeners: [
                      // lắng nghe tạo/cập nhật tài khoản ngân hàng
                      BlocListener<BankAccountBloc, BankAccountState>(
                        listener: (context, state) {
                          if (state is BankAccountFailure) {
                            _snack(context, state.message);
                          }
                          if (state is BankAccountCreateSuccess) {
                            _snack(context, 'Tạo tài khoản thành công');
                            context
                                .read<BankAccountBloc>()
                                .add(const GetBankAccountsEvent());
                          }
                          if (state is BankAccountUpdateSuccess) {
                            _snack(context, 'Cập nhật tài khoản thành công');
                            context
                                .read<BankAccountBloc>()
                                .add(const GetBankAccountsEvent());
                          }
                        },
                      ),
                      // lắng nghe gửi yêu cầu rút
                      BlocListener<WalletBloc, WalletState>(
                        listener: (context, wState) {
                          if (wState is WalletFailure) {
                            _snack(context, wState.error);
                          }
                          if (wState is WalletSuccess) {
                            _snack(context, 'Gửi yêu cầu rút tiền thành công');
                            _amountController.clear();
                            _noteController.clear();
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<BankAccountBloc, BankAccountState>(
                      builder: (context, state) {
                        final loading = state is BankAccountLoading;
                        BankAccountModel? defaultAcc;
                        if (state is BankAccountListSuccess &&
                            state.accounts.isNotEmpty) {
                          defaultAcc = state.accounts.firstWhere(
                            (e) => e.isDefault == true,
                            orElse: () => state.accounts.first,
                          );
                        }
                        _defaultAcc = defaultAcc; // lưu lại để submit rút

                        return AbsorbPointer(
                          absorbing: loading,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: loading ? .6 : 1,
                            child: RefreshIndicator(
                              color: _P.primary,
                              onRefresh: () async {
                                context
                                    .read<BankAccountBloc>()
                                    .add(const GetBankAccountsEvent());
                                context.read<BankLookupCubit>().loadBanks();
                              },
                              child: SingleChildScrollView(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // --- Số dư ví ---
                                    _SectionCard(
                                      title: 'Số dư ví',
                                      child: _ReadOnlyInfo(
                                        label: 'Số dư khả dụng',
                                        value: '${_availableBalance.vnd()} đ',
                                      ),
                                    ),

                                    if (defaultAcc != null) ...[
                                      _SectionCard(
                                        title: 'Tài khoản mặc định',
                                        child: _AccountCard(
                                          acc: defaultAcc,
                                          onEdit: () => _showEditBankSheet(
                                              context, defaultAcc!),
                                          onSetDefault:
                                              defaultAcc.isDefault == true
                                                  ? null
                                                  : () => _setDefaultBank(
                                                      defaultAcc!),
                                        ),
                                      ),
                                      SizedBox(height: 1.6.h),
                                      _SectionCard(
                                        title: 'Thông tin rút tiền',
                                        child: _WithdrawForm(
                                          formKey: _formKeyWithdraw,
                                          amountController: _amountController,
                                          noteController: _noteController,
                                          onSubmit: _handleSubmitWithdraw,
                                          minAmount: _minAmount,
                                          maxAmount: _availableBalance,
                                          isSubmitting: isSubmitting,
                                        ),
                                      ),
                                    ] else ...[
                                      _InfoBanner(
                                        text:
                                            'Chưa có tài khoản ngân hàng mặc định. Vui lòng nhập thông tin tài khoản.',
                                      ),
                                      SizedBox(height: 1.6.h),
                                      _SectionCard(
                                        title: 'Tài khoản ngân hàng',
                                        child: _CreateAccountForm(
                                          formKey: _formKeyCreate,
                                          state: bankLookup,
                                          selectedBank: _selectedBank,
                                          onBankChanged: (b) {
                                            setState(() => _selectedBank = b);
                                            context
                                                .read<BankLookupCubit>()
                                                .clearVerify();
                                          },
                                          accountController:
                                              _accountController,
                                          onLookup: () {
                                            final code =
                                                _selectedBank?.code;
                                            final acc =
                                                _accountController.text
                                                    .trim();
                                            if (code == null ||
                                                acc.isEmpty) {
                                              _snack(context,
                                                  'Chọn ngân hàng và nhập số tài khoản');
                                              return;
                                            }
                                            context
                                                .read<BankLookupCubit>()
                                                .verify(
                                                  bankCode: code,
                                                  account: acc,
                                                );
                                          },
                                          onCreate: (ownerName) {
                                            final model =
                                                CreateBankAccountModel(
                                              bankName:
                                                  _selectedBank!.name,
                                              bankAccountNumber:
                                                  _accountController.text
                                                      .trim(),
                                              bankOwnerName: ownerName,
                                              isDefault: true,
                                            );
                                            context
                                                .read<BankAccountBloc>()
                                                .add(CreateBankAccountEvent(
                                                    model));
                                          },
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 2.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // overlay loading khi BankAccountBloc loading
          BlocBuilder<BankAccountBloc, BankAccountState>(
            builder: (context, state) => state is BankAccountLoading
                ? const _BlockingLoading()
                : const SizedBox.shrink(),
          ),

          // overlay loading khi WalletBloc loading (gửi rút)
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, wState) => wState is WalletLoading
                ? const _BlockingLoading()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ======== ACTIONS =========

  void _handleSubmitWithdraw() {
    final ok = _formKeyWithdraw.currentState?.validate() ?? false;
    if (!ok) return;

    // đảm bảo có tk mặc định
    if (_defaultAcc == null || _defaultAcc?.id == null) {
      _snack(context,
          'Vui lòng thêm tài khoản ngân hàng mặc định trước khi rút');
      return;
    }

    final amount = _amountController.text.toNumeric();
    final note = _noteController.text.trim();

    final req = WithdrawalRequestCreateModel(
      amount: amount.toDouble(),
      bankAccountId: _defaultAcc!.id!, // đảm bảo non-null
      note: note.isEmpty ? null : note,
    );

    context.read<WalletBloc>().add(SendWithdrawalRequestEvent(req));
  }

  void _setDefaultBank(BankAccountModel acc) {
    if (acc.id == null) {
      _snack(context, 'Không tìm thấy ID tài khoản để đặt mặc định');
      return;
    }
    context.read<BankAccountBloc>().add(
          UpdateBankAccountEvent(
            bankAccountId: acc.id!,
            model: UpdateBankAccountModel(isDefault: true),
          ),
        );
  }

  /// Bottom sheet chỉnh sửa tài khoản dùng lại UI tra cứu giống tạo mới
  void _showEditBankSheet(BuildContext context, BankAccountModel acc) {
    // reset trạng thái verify để tránh hiển thị kết quả cũ
    context.read<BankLookupCubit>().clearVerify();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 2.h,
            top: 1.h,
          ),
          child: _EditAccountSheet(acc: acc),
        );
      },
    );
  }

  void _snack(BuildContext c, String msg) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

/// ================== STYLE / PALETTE ==================
class _P {
  static const primary = Color(0xFF3A7DFF);
  static const primarySoft = Color(0xFF6EA5FF);
  static const bg = Color(0xFFF6F9FF);
  static const card = Colors.white;
  static final stroke = const Color(0xFF3A7DFF).withOpacity(.16);
  static final subtle = const Color(0xFF0B1B3F).withOpacity(.70);
  static final fill = const Color(0xFF3A7DFF).withOpacity(.06);
}

/// ================== HEADER ==================
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6EA5FF), Color(0xFF3A7DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  // 🔹 Nút Back
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 6.6.h,
                      width: 6.6.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(.28)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Icon ví
                  Container(
                    height: 6.6.h,
                    width: 6.6.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(.28)),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 3.w),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Yêu cầu rút tiền',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp)),
                      SizedBox(height: .6.h),
                      Text('Rút về tài khoản ngân hàng của bạn',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.95),
                              fontSize: 13.sp)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================== WRAPPERS ==================
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _P.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _P.stroke),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: _P.subtle)),
        SizedBox(height: 1.2.h),
        child,
      ]),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: _P.fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _P.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: _P.primary),
          SizedBox(width: 3.w),
          Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 14.sp, color: _P.subtle))),
        ],
      ),
    );
  }
}

/// ================== ACCOUNT CARD ==================
class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.acc,
    this.onEdit,
    this.onSetDefault,
  });
  final BankAccountModel acc;
  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: _P.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _P.stroke),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(Icons.account_balance_rounded, color: _P.primary),
            SizedBox(width: 2.4.w),
            Text('Tài khoản ngân hàng',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _P.subtle)),
            const Spacer(),
            if (acc.isDefault == true) const _Tag('Mặc định'),
            if (acc.isDefault != true && onSetDefault != null) ...[
              TextButton(onPressed: onSetDefault, child: const Text('Đặt mặc định')),
            ],
            if (onEdit != null) ...[
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
            ],
          ],
        ),
        SizedBox(height: 1.2.h),
        _kv('Ngân hàng', acc.bankName ?? '-'),
        _kv('Số tài khoản', acc.bankAccountNumber ?? '-'),
        _kv('Chủ tài khoản', acc.bankOwnerName ?? '-'),
      ]),
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: EdgeInsets.symmetric(vertical: .5.h),
        child: Row(
          children: [
            Expanded(
                child: Text(k,
                    style: TextStyle(fontSize: 11.5.sp, color: _P.subtle))),
            Text(v,
                style:
                    TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: .5.h),
      decoration: BoxDecoration(
        color: _P.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _P.primary.withOpacity(.22)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10.sp, color: _P.primary, fontWeight: FontWeight.w800)),
    );
  }
}

/// ================== CREATE ACCOUNT FORM ==================
class _CreateAccountForm extends StatelessWidget {
  const _CreateAccountForm({
    required this.formKey,
    required this.state,
    required this.selectedBank,
    required this.onBankChanged,
    required this.accountController,
    required this.onLookup,
    required this.onCreate,
  });

  final GlobalKey<FormState> formKey;
  final BankLookupState state;
  final BankLookupItem? selectedBank;
  final ValueChanged<BankLookupItem?> onBankChanged;
  final TextEditingController accountController;
  final VoidCallback onLookup;
  final ValueChanged<String> onCreate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _FieldLabel('Ngân hàng'),
          DropdownButtonFormField<BankLookupItem>(
            isExpanded: true,
            value: selectedBank,
            decoration: _inputDecoration(),
            items: state.banks
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Image.network(
                            e.logoUrl ?? '',
                            width: 28,
                            height: 28,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.account_balance, size: 24),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${e.name} (${e.code})',
                              style: TextStyle(fontSize: 12.5.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: onBankChanged,
          ),
          SizedBox(height: 1.2.h),
          _FieldLabel('Số tài khoản'),
          TextFormField(
            controller: accountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration(hint: 'Ví dụ: 123456789'),
            validator: (v) {
              final t = (v ?? '').trim();
              if (t.isEmpty) return 'Vui lòng nhập số tài khoản';
              if (t.length < 6) return 'Số tài khoản chưa hợp lệ';
              return null;
            },
            onChanged: (_) => context.read<BankLookupCubit>().clearVerify(),
          ),
          SizedBox(height: 1.4.h),
          Row(
            children: [
              Expanded(
                child: _OutlineBtn(
                  label: state.isVerifying
                      ? 'Đang xác thực...'
                      : 'Tra cứu tên chủ TK',
                  icon: Icons.search_rounded,
                  onPressed: state.isVerifying ? null : onLookup,
                ),
              ),
              SizedBox(width: 3.w),
              if (state.ownerName != null)
                Expanded(
                  child: _PrimaryBtn(
                    label: 'Tạo & Tiếp tục',
                    icon: Icons.check_circle_rounded,
                    onPressed: () => onCreate(state.ownerName!),
                  ),
                ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: state.verifyError != null
                ? Padding(
                    key: const ValueKey('err'),
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(state.verifyError!,
                        style: const TextStyle(color: Colors.red)),
                  )
                : const SizedBox.shrink(key: ValueKey('ok')),
          ),
          if (state.ownerName != null) ...[
            SizedBox(height: 1.2.h),
            _ReadOnlyInfo(label: 'Tên chủ tài khoản', value: state.ownerName!),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        filled: true,
        fillColor: _P.fill,
        hintStyle: TextStyle(fontSize: 12.5.sp),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _P.stroke),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _P.primary, width: 1.4),
          borderRadius: BorderRadius.circular(14),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}

/// ================== EDIT ACCOUNT SHEET (re-use UI lookup) ==================
class _EditAccountSheet extends StatefulWidget {
  const _EditAccountSheet({required this.acc});
  final BankAccountModel acc;

  @override
  State<_EditAccountSheet> createState() => _EditAccountSheetState();
}

class _EditAccountSheetState extends State<_EditAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _accNumberCtl;
  BankLookupItem? _pickedBank;

@override
void initState() {
  super.initState();
  _accNumberCtl = TextEditingController(
    text: widget.acc.bankAccountNumber ?? '',
  );
  final banks = context.read<BankLookupCubit>().state.banks;

  if (banks.isEmpty) {
    _pickedBank = null;
  } else {
    _pickedBank = banks.firstWhere(
      (b) => b.name == (widget.acc.bankName ?? ''),
      orElse: () => banks.first,
    );
  }
}


  @override
  void dispose() {
    _accNumberCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BankLookupCubit>().state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Chỉnh sửa tài khoản', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp)),
        SizedBox(height: 1.2.h),

        // Form giống tạo mới
        Form(
          key: _formKey,
          child: Column(
            children: [
              _FieldLabel('Ngân hàng'),
              DropdownButtonFormField<BankLookupItem>(
                isExpanded: true,
                value: _pickedBank,
                decoration: _editInputDecoration(),
                items: state.banks
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Image.network(
                                e.logoUrl ?? '',
                                width: 45,
                                height: 45,
                                errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, size: 24),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${e.name} (${e.code})',
                                  style: TextStyle(fontSize: 12.5.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (b) {
                  setState(() => _pickedBank = b);
                  context.read<BankLookupCubit>().clearVerify();
                },
              ),
              SizedBox(height: 1.2.h),
              _FieldLabel('Số tài khoản'),
              TextFormField(
                controller: _accNumberCtl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _editInputDecoration(hint: 'Ví dụ: 123456789'),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Vui lòng nhập số tài khoản';
                  if (t.length < 6) return 'Số tài khoản chưa hợp lệ';
                  return null;
                },
                onChanged: (_) => context.read<BankLookupCubit>().clearVerify(),
              ),
              SizedBox(height: 1.4.h),

              Row(
                children: [
                  Expanded(
                    child: _OutlineBtn(
                      label: state.isVerifying ? 'Đang xác thực...' : 'Tra cứu tên chủ TK',
                      icon: Icons.search_rounded,
                      onPressed: state.isVerifying
                          ? null
                          : () {
                              final code = _pickedBank?.code;
                              final accNo = _accNumberCtl.text.trim();
                              if (code == null || accNo.isEmpty) {
                                _snack(context, 'Chọn ngân hàng và nhập số tài khoản');
                                return;
                              }
                              if (!(_formKey.currentState?.validate() ?? false)) return;
                              context.read<BankLookupCubit>().verify(bankCode: code, account: accNo);
                            },
                    ),
                  ),
                  SizedBox(width: 3.w),
                  if (state.ownerName != null)
                    Expanded(
                      child: _PrimaryBtn(
                        label: 'Lưu thay đổi',
                        icon: Icons.save_rounded,
                        onPressed: () {
                          // gửi PUT update sau khi đã verify OK
                          if (_pickedBank == null) {
                            _snack(context, 'Vui lòng chọn ngân hàng');
                            return;
                          }
                          if (!(_formKey.currentState?.validate() ?? false)) return;
                          final id = widget.acc.id;
                          if (id == null) {
                            _snack(context, 'Không tìm thấy ID tài khoản');
                            return;
                          }
                          context.read<BankAccountBloc>().add(
                                UpdateBankAccountEvent(
                                  bankAccountId: id,
                                  model: UpdateBankAccountModel(
                                    bankName: _pickedBank!.name,
                                    bankAccountNumber: _accNumberCtl.text.trim(),
                                    bankOwnerName: state.ownerName!, // dùng tên đã tra cứu
                                  ),
                                ),
                              );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: state.verifyError != null
                    ? Padding(
                        key: const ValueKey('err'),
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(state.verifyError!, style: const TextStyle(color: Colors.red)),
                      )
                    : const SizedBox.shrink(key: ValueKey('ok')),
              ),

              if (state.ownerName != null) ...[
                SizedBox(height: 1.2.h),
                _ReadOnlyInfo(label: 'Tên chủ tài khoản', value: state.ownerName!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _editInputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        filled: true,
        fillColor: _P.fill,
        hintStyle: TextStyle(fontSize: 12.5.sp),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _P.stroke),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _P.primary, width: 1.4),
          borderRadius: BorderRadius.circular(14),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );

  void _snack(BuildContext c, String msg) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

/// ================== WITHDRAW FORM ==================
class _WithdrawForm extends StatelessWidget {
  const _WithdrawForm({
    required this.formKey,
    required this.amountController,
    required this.noteController,
    required this.onSubmit,
    required this.minAmount,
    required this.maxAmount,
    this.isSubmitting = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final VoidCallback onSubmit;
  final num minAmount;
  final num maxAmount;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel('Số tiền rút'),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _VndThousandsFormatter()
            ],
            decoration: _inputDecoration(suffix: 'đ').copyWith(
                helperText:
                    'Tối thiểu ${minAmount.vnd()} đ • Tối đa ${maxAmount.vnd()} đ'),
            validator: (v) {
              final value = (v ?? '').toNumeric();
              if (value < minAmount) {
                return 'Tối thiểu ${minAmount.vnd()} đ';
              }
              if (value > maxAmount) {
                return 'Vượt quá số dư (${maxAmount.vnd()} đ)';
              }
              return null;
            },
          ),
          SizedBox(height: 1.4.h),
          _FieldLabel('Ghi chú (tuỳ chọn)'),
          TextFormField(
            controller: noteController,
            maxLines: 3,
            decoration: _inputDecoration(),
          ),
          SizedBox(height: 1.6.h),
          _PrimaryBtn(
            label: isSubmitting ? 'Đang gửi...' : 'Gửi yêu cầu rút',
            icon: Icons.send_rounded,
            onPressed: isSubmitting ? null : onSubmit,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? suffix}) => InputDecoration(
        suffixText: suffix,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        filled: true,
        fillColor: _P.fill,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _P.stroke),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _P.primary, width: 1.4),
          borderRadius: BorderRadius.circular(14),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}

/// ================== COMMON ==================
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: .6.h),
      child: Text(text,
          style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: _P.subtle)),
    );
  }
}

class _ReadOnlyInfo extends StatelessWidget {
  const _ReadOnlyInfo({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.2.w),
      decoration: BoxDecoration(
        color: _P.fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _P.stroke),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: _P.subtle)),
        SizedBox(height: .5.h),
        Text(value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.6.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
        label: Text(label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _P.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  const _OutlineBtn({required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.6.h,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, size: 20, color: _P.primary)
            : const SizedBox.shrink(),
        label: Text(label,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: _P.primary)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: _P.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _P.card,
        ),
      ),
    );
  }
}

class _BlockingLoading extends StatelessWidget {
  const _BlockingLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.08),
      child: const Center(child: CircularProgressIndicator(color: _P.primary)),
    );
  }
}

/// ================== FORMATTER & EXT ==================
class _VndThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String raw = newValue.text.replaceAll('.', '');
    if (raw.isEmpty) return newValue.copyWith(text: '');
    raw = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i != 0 && (raw.length - i) % 3 == 0) buf.write('.');
      buf.write(raw[i]);
    }
    final formatted = buf.toString();
    return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length));
  }
}

extension _NumExt on String {
  int toNumeric() => int.tryParse(replaceAll('.', '').replaceAll(',', '')) ?? 0;
}

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

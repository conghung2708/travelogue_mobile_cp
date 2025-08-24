// lib/representation/tour_guide/screens/guide_booking_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';

import 'package:travelogue_mobile/core/repository/authenication_repository.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_qr_payment_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/confirm_total_bar.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/exit_confirm_dialog.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/guide_info_card.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/guide_policy_card.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/guide_top_banner.dart';

class GuideBookingConfirmationScreen extends StatefulWidget {
  static const String routeName = '/guide-booking-confirmation';

  final TourGuideModel guide;
  final String? tripPlanId;
  final DateTime startDate;
  final DateTime endDate;

  /// Chỉ dùng để hiển thị/tính giá (không gửi lên API)
  final int adults;
  final int children;

  /// Tuỳ chọn: nếu truyền, sẽ map thành `participants` trong payload.
  final List<BookingParticipantModel>? participants;

  const GuideBookingConfirmationScreen({
    super.key,
    required this.guide,
    this.tripPlanId,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
    this.participants,
  });

  @override
  State<GuideBookingConfirmationScreen> createState() =>
      _GuideBookingConfirmationScreenState();
}

class _GuideBookingConfirmationScreenState
    extends State<GuideBookingConfirmationScreen> {
  late DateTime _startDate;
  late DateTime _endDate;

  // Đồng ý điều khoản
  final hasAcceptedTerms = ValueNotifier<bool>(false);

  // Prefill contact info
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _addrCtl = TextEditingController();

  // Form key để autovalidate realtime
  final _formKey = GlobalKey<FormState>();

  bool _loadingUser = true;
  String? _loadError;

  bool isLoading = false;
  String? bookingId;

  String get _tripPlanId => widget.tripPlanId ?? '';
  bool get _lockedByTripPlan => _tripPlanId.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _prefillCurrentUser();
  }

  Future<void> _prefillCurrentUser() async {
    try {
      final user = await AuthenicationRepository().fetchCurrentUser();
      _nameCtl.text = user.fullName ?? user.username ?? '';
      _emailCtl.text = user.email ?? '';
      _phoneCtl.text = user.phoneNumber ?? '';
      _addrCtl.text = user.address ?? '';
      setState(() {
        _loadingUser = false;
        _loadError = null;
      });
    } catch (e) {
      setState(() {
        _loadingUser = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _addrCtl.dispose();
    super.dispose();
  }

  // ===== Validators =====
  bool _isValidVietnamPhone(String phone) {
    // Hợp lệ: +84xxxxxxxxx (9 số sau +84) hoặc 0xxxxxxxxx (9 số sau 0) => tổng 10 số nội địa
    final pattern = r'^(?:\+84|0)\d{9}$';
    return RegExp(pattern).hasMatch(phone);
  }

  bool _isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  void _showInfo(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _changeDateRange() async {
    if (_lockedByTripPlan) {
      _showInfo('Bạn không thể đổi ngày vì đang liên kết với Trip Plan.');
      return;
    }
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _onConfirmBooking() {
    // Validate form trước
    if (!(_formKey.currentState?.validate() ?? false)) {
      _showInfo('Vui lòng nhập đúng và đầy đủ thông tin liên hệ.');
      return;
    }
    if (!hasAcceptedTerms.value) {
      _showInfo('Vui lòng đồng ý điều khoản dịch vụ trước khi tiếp tục.');
      return;
    }

    // Map participants nếu có
    final mappedParticipants = widget.participants == null
        ? null
        : widget.participants!
            .map((p) => BookingParticipantModel(
                  type: p.type,
                  fullName: p.fullName,
                  gender: p.gender,
                  dateOfBirth: p.dateOfBirth,
                ))
            .toList();

    // Payload theo API (KHÔNG có promotionCode ở UI)
    final model = CreateBookingTourGuideModel(
      tourGuideId: widget.guide.id!,
      startDate: _startDate,
      endDate: _endDate,
      tripPlanId: _tripPlanIdOrNull,
      contactName: _nameCtl.text.trim(),
      contactEmail: _emailCtl.text.trim(),
      contactPhone: _phoneCtl.text.trim(),
      contactAddress: _addrCtl.text.trim(),
      participants: mappedParticipants,
    );

    context.read<BookingBloc>().add(CreateTourGuideBookingEvent(model));
    setState(() => isLoading = true);
  }

  void _onBookingSuccess(String id) {
    bookingId = id;
    context.read<BookingBloc>().add(CreatePaymentLinkEvent(id, fromGuide: true));
  }

  void _onPaymentSuccess(String paymentUrl) {
    setState(() => isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TourGuideQrPaymentScreen(
          guide: widget.guide,
          startDate: _startDate,
          endDate: _endDate,
          adults: widget.adults,
          children: widget.children,
          startTime: DateTime.now(),
          paymentUrl: paymentUrl,
          tripPlanId: _tripPlanId,
          bookingId: bookingId,
        ),
      ),
    );
  }

  String? get _tripPlanIdOrNull =>
      (widget.tripPlanId != null && widget.tripPlanId!.isNotEmpty)
          ? widget.tripPlanId
          : null;

  void _showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEEE, dd MMM yyyy', 'vi_VN');
    final currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

    final VoidCallback? editDatesCallback =
        _lockedByTripPlan ? null : _changeDateRange;

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingGuideSuccess) {
          bookingId = state.booking.id;
          _onBookingSuccess(state.booking.id);
        } else if (state is PaymentLinkGuideSuccess) {
          _onPaymentSuccess(state.paymentUrl);
        } else if (state is BookingFailure) {
          _showError(state.error);
        }
      },
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async => await ExitConfirmDialog.show(context) ?? false,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9FAFC),
              body: SafeArea(
                child: Column(
                  children: [
                    GuideTopBanner(
                      guide: widget.guide,
                      onBackPressed: () async {
                        final ok = await ExitConfirmDialog.show(context);
                        if (ok == true && mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GuideInfoCard(
                              guide: widget.guide,
                              startDate: _startDate,
                              endDate: _endDate,
                              adults: widget.adults,
                              children: widget.children,
                              onEditDates: editDatesCallback,
                              dateFormatter: formatter,
                              currencyFormat: currencyFormat,
                            ),
                            SizedBox(height: 2.h),

                            const TitleWithCustoneUnderline(
                              text: '👤 Thông tin ',
                              text2: 'liên hệ',
                            ),
                            SizedBox(height: 1.h),

                            // 🔥 Bọc trong Form để autovalidate realtime
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: _GuideContactCard(
                                nameCtl: _nameCtl,
                                emailCtl: _emailCtl,
                                phoneCtl: _phoneCtl,
                                addrCtl: _addrCtl,
                                loading: _loadingUser,
                                error: _loadError,
                                // truyền validators
                                validatorName: (v) => (v == null ||
                                        v.trim().isEmpty)
                                    ? 'Vui lòng nhập họ tên'
                                    : null,
                                validatorEmail: (v) {
                                  final t = v?.trim() ?? '';
                                  if (t.isEmpty) return 'Vui lòng nhập email';
                                  if (!_isValidEmail(t)) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                                validatorPhone: (v) {
                                  final t = v?.trim() ?? '';
                                  if (t.isEmpty) {
                                    return 'Vui lòng nhập số điện thoại';
                                  }
                                  if (!_isValidVietnamPhone(t)) {
                                    return 'Số điện thoại không hợp lệ';
                                  }
                                  return null;
                                },
                                validatorAddress: (v) => (v == null ||
                                        v.trim().isEmpty)
                                    ? 'Vui lòng nhập địa chỉ'
                                    : null,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            GuidePolicyCard(hasAcceptedTerms: hasAcceptedTerms),
                            SizedBox(height: 3.h),

                            ConfirmTotalBar(
                              startDate: _startDate,
                              endDate: _endDate,
                              guideDailyPrice: widget.guide.price ?? 0,
                              currencyFormat: currencyFormat,
                              acceptedListenable: hasAcceptedTerms,
                              onConfirm: _onConfirmBooking,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

/* ===== Contact UI ===== */

class _GuideContactCard extends StatelessWidget {
  final TextEditingController nameCtl;
  final TextEditingController emailCtl;
  final TextEditingController phoneCtl;
  final TextEditingController addrCtl;
  final bool loading;
  final String? error;

  // Validators được truyền từ trên xuống để tái sử dụng
  final String? Function(String?)? validatorName;
  final String? Function(String?)? validatorEmail;
  final String? Function(String?)? validatorPhone;
  final String? Function(String?)? validatorAddress;

  const _GuideContactCard({
    required this.nameCtl,
    required this.emailCtl,
    required this.phoneCtl,
    required this.addrCtl,
    required this.loading,
    required this.error,
    required this.validatorName,
    required this.validatorEmail,
    required this.validatorPhone,
    required this.validatorAddress,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _GlassCard(
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 3.w),
            Text(
              'Đang lấy thông tin tài khoản...',
              style: TextStyle(fontSize: 11.5.sp, color: Colors.black87),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return _GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Text(
                'Không lấy được thông tin tài khoản:\n$error',
                style: TextStyle(fontSize: 11.5.sp, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.contact_page_rounded, color: Colors.blueGrey),
              SizedBox(width: 2.w),
              Text(
                'Thông tin liên hệ',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.6.h),

          _LabeledField(
            label: 'Họ và tên',
            controller: nameCtl,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            prefixIcon: Icons.person_outline_rounded,
            hintText: 'VD: Nguyễn Văn A',
            validator: validatorName,
          ),
          SizedBox(height: 1.2.h),

          LayoutBuilder(
            builder: (context, c) {
              final twoCols = c.maxWidth > 600;
              if (twoCols) {
                return Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Email',
                        controller: emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.alternate_email_rounded,
                        hintText: 'name@example.com',
                        validator: validatorEmail,
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: _LabeledField(
                        label: 'Số điện thoại',
                        controller: phoneCtl,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        hintText: 'VD: 09xx xxx xxx',
                        validator: validatorPhone,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _LabeledField(
                    label: 'Email',
                    controller: emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email_rounded,
                    hintText: 'name@example.com',
                    validator: validatorEmail,
                  ),
                  SizedBox(height: 1.2.h),
                  _LabeledField(
                    label: 'Số điện thoại',
                    controller: phoneCtl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    hintText: 'VD: 09xx xxx xxx',
                    validator: validatorPhone,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 1.2.h),

          _LabeledField(
            label: 'Địa chỉ',
            controller: addrCtl,
            keyboardType: TextInputType.streetAddress,
            prefixIcon: Icons.location_on_outlined,
            hintText: 'Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành',
            maxLines: 2,
            validator: validatorAddress,
          ),
        ],
      ),
    );
  }
}

/* ===== Shared UI ===== */

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.black.withOpacity(0.78),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 0.6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon:
                prefixIcon == null ? null : Icon(prefixIcon, color: Colors.blueGrey),
            contentPadding: EdgeInsets.symmetric(
              vertical: 1.6.h,
              horizontal: 3.2.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
          ),
        ),
      ],
    );
  }
}

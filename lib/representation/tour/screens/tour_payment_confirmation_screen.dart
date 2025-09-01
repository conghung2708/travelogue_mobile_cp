// lib/representation/tour/screens/tour_payment_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/core/repository/authenication_repository.dart';

import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/widgets/agreement_checkbox.dart';
import 'package:travelogue_mobile/representation/tour/widgets/confirm_payment_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/payment_summary_card.dart';
import 'package:travelogue_mobile/representation/tour/widgets/policy_markdown_box.dart';
import 'package:travelogue_mobile/representation/tour/widgets/support_button.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_info_card.dart';

class TourPaymentConfirmationScreen extends StatefulWidget {
  static const routeName = '/tour-payment-confirmation';

  final TourModel tour;
  final TourScheduleModel schedule;
  final String? media;
  final DateTime? startTime;
  final int adults;
  final int children;
  final String? bookingId;
  final List<BookingParticipantModel>? participants;
   final String? contactAddress;

  const TourPaymentConfirmationScreen({
    super.key,
    required this.tour,
    required this.schedule,
    this.media,
    this.startTime,
    this.adults = 1,
    this.children = 0,
    this.bookingId,
    this.participants,
     this.contactAddress,
  });

  @override
  State<TourPaymentConfirmationScreen> createState() =>
      _TourPaymentConfirmationScreenState();
}

class _TourPaymentConfirmationScreenState
    extends State<TourPaymentConfirmationScreen> {
  bool _agreed = false;

  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _addrCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loadingUser = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _prefillCurrentUser();
  }

  Future<void> _prefillCurrentUser() async {
  try {
    final user = await AuthenicationRepository().fetchCurrentUser();

    _nameCtl.text  = user.fullName ?? user.username ?? '';
    _emailCtl.text = user.email ?? '';
    _phoneCtl.text = user.phoneNumber ?? '';

    
    String? passedAddr = widget.contactAddress?.trim();


    if ((passedAddr == null || passedAddr.isEmpty)) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['contactAddress'] is String) {
        final a = (args['contactAddress'] as String).trim();
        if (a.isNotEmpty) passedAddr = a;
      }
    }

    _addrCtl.text = (passedAddr?.isNotEmpty == true)
        ? passedAddr!
        : (user.address ?? '');

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

  bool isValidVietnamPhone(String phone) {
    final pattern = r'^(?:\+84|0)(?:\d{9})$';
    return RegExp(pattern).hasMatch(phone);
  }


  ({CreateBookingTourModel? model, String? error}) _buildPayload() {
    final participants = widget.participants ?? [];

    if (participants.isEmpty) {
      return (
        model: null,
        error: 'Thiếu danh sách hành khách. Quay lại bước trước để thêm.'
      );
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return (model: null, error: 'Vui lòng nhập đầy đủ thông tin liên hệ.');
    }

    final model = CreateBookingTourModel(
      tourId: widget.tour.tourId!,
      scheduledId: widget.schedule.scheduleId!,
      promotionCode: null,
      contactName: _nameCtl.text.trim(),
      contactEmail: _emailCtl.text.trim(),
      contactPhone: _phoneCtl.text.trim(),
      contactAddress: _addrCtl.text.trim(),
      participants: participants,
    );
    return (model: model, error: null);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final double adultTotal = widget.adults * (widget.schedule.adultPrice ?? 0);
    final double childrenTotal =
        widget.children * (widget.schedule.childrenPrice ?? 0);
    final double totalPrice = adultTotal + childrenTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            PaymentHeader(startTime: widget.startTime),
            TourInfoCard(
              tour: widget.tour,
              mediaUrl: widget.media,
              startTime: widget.startTime,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentSummaryCard(
                      adults: widget.adults,
                      children: widget.children,
                      schedule: widget.schedule,
                      totalPrice: totalPrice,
                      formatter: formatter,
                    ),
                    SizedBox(height: 2.h),
                    const TitleWithCustoneUnderline(
                      text: '👤 Thông tin ',
                      text2: 'liên hệ',
                    ),
                    SizedBox(height: 1.h),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: _ContactCard(
                        nameCtl: _nameCtl,
                        emailCtl: _emailCtl,
                        phoneCtl: _phoneCtl,
                        addrCtl: _addrCtl,
                        loading: _loadingUser,
                        error: _loadError,
                        validatorPhone: (v) {
                          final text = v?.trim() ?? '';
                          if (text.isEmpty) return 'Vui lòng nhập số điện thoại';
                          if (!isValidVietnamPhone(text)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                    const TitleWithCustoneUnderline(
                      text: '📘 Điều khoản & ',
                      text2: 'Trách nhiệm dịch vụ',
                    ),
                    SizedBox(height: 1.h),
                    const PolicyMarkdownBox(),
                    SizedBox(height: 1.5.h),
                    AgreementCheckbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                    ),
                    const SupportButton(),
                    SizedBox(height: 2.h),
                    ConfirmPaymentButton(
                      enabled: _agreed && !_loadingUser,
                      tour: widget.tour,
                      schedule: widget.schedule,
                      startTime: widget.startTime,
                      adults: widget.adults,
                      children: widget.children,
                      bookingId: widget.bookingId,
                      media: widget.media,
                      payloadBuilder: _buildPayload,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final TextEditingController nameCtl;
  final TextEditingController emailCtl;
  final TextEditingController phoneCtl;
  final TextEditingController addrCtl;
  final bool loading;
  final String? error;
  final String? Function(String?)? validatorPhone;

  const _ContactCard({
    required this.nameCtl,
    required this.emailCtl,
    required this.phoneCtl,
    required this.addrCtl,
    required this.loading,
    required this.error,
    required this.validatorPhone,
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
          // Header
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

          // Full name
          _LabeledField(
            label: 'Họ và tên',
            controller: nameCtl,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            prefixIcon: Icons.person_outline_rounded,
            hintText: 'VD: Nguyễn Văn A',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
          ),
          SizedBox(height: 1.2.h),

          // Email + Phone 
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
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Vui lòng nhập email'
                            : null,
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
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Vui lòng nhập email'
                        : null,
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

          // Address
          _LabeledField(
            label: 'Địa chỉ',
            controller: addrCtl,
            keyboardType: TextInputType.streetAddress,
            prefixIcon: Icons.location_on_outlined,
            hintText: 'Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành',
            maxLines: 2,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Vui lòng nhập địa chỉ'
                : null,
          ),
        ],
      ),
    );
  }
}



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
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: Colors.blueGrey),
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

// lib/representation/workshop/screens/workshop_payment_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/repository/authenication_repository.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';

import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/workshop/create_booking_workshop_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/model/workshop/schedule_model.dart';

import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_qr_payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopPaymentConfirmationScreen extends StatefulWidget {
  final WorkshopDetailModel workshop;
  final ScheduleModel schedule;
  final int adults;
  final int children;

  
  final List<BookingParticipantModel>? participants;

 
  final String? ticketTypeId;
  final String? ticketTypeName; 
  final num? ticketPrice;     

  const WorkshopPaymentConfirmationScreen({
    super.key,
    required this.workshop,
    required this.schedule,
    this.adults = 1,
    this.children = 0,
    this.participants,
    this.ticketTypeId,
    this.ticketTypeName,
    this.ticketPrice,
  });

  @override
  State<WorkshopPaymentConfirmationScreen> createState() =>
      _WorkshopPaymentConfirmationScreenState();
}

class _WorkshopPaymentConfirmationScreenState
    extends State<WorkshopPaymentConfirmationScreen> {
  bool _agreed = false;


  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _addrCtl = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  bool _loadingUser = true;
  String? _loadError;


  NumberFormat get _fmt => NumberFormat('#,###');
  bool get _usingTicketType => widget.ticketPrice != null;

  int get _peopleCount => (widget.participants?.length ?? 0);

  double get _adultPrice => widget.schedule.adultPrice?.toDouble() ?? 0;
  double get _childPrice => widget.schedule.childrenPrice?.toDouble() ?? 0;

  double get _totalPrice => _usingTicketType
      ? (_peopleCount * (widget.ticketPrice?.toDouble() ?? 0))
      : (widget.adults * _adultPrice + widget.children * _childPrice);

  @override
  void initState() {
    super.initState();
    _prefillCurrentUser();
  }

  Future<void> _prefillCurrentUser() async {
    try {
      final user = await AuthenicationRepository().fetchCurrentUser();
      _nameCtl.text = user.fullName ?? user.username ?? '';
      _emailCtl.text = user.email ?? '';
      _phoneCtl.text = user.phoneNumber ?? '';
      _addrCtl.text = user.address ?? '';
      if (mounted) {
        setState(() {
          _loadingUser = false;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingUser = false;
          _loadError = e.toString();
        });
      }
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


  bool _isValidVietnamPhone(String phone) {
    final pattern = r'^(?:\+84|0)\d{9}$';
    return RegExp(pattern).hasMatch(phone);
  }

  bool _isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }


  ({CreateBookingWorkshopModel? model, String? error}) _buildPayload() {
    final participants = widget.participants ?? [];

    if (participants.isEmpty) {
      return (
        model: null,
        error:
            'Thiếu danh sách hành khách. Quay lại bước trước để thêm hành khách.'
      );
    }


    if (!(_formKey.currentState?.validate() ?? false)) {
      return (model: null, error: 'Vui lòng nhập đúng và đầy đủ thông tin liên hệ.');
    }

    final model = CreateBookingWorkshopModel(
      workshopId: widget.workshop.workshopId ?? '',
      workshopScheduleId: widget.schedule.scheduleId ?? '',
      promotionCode: null,
      contactName: _nameCtl.text.trim(),
      contactEmail: _emailCtl.text.trim(),
      contactPhone: _phoneCtl.text.trim(),
      contactAddress: _addrCtl.text.trim(),
      participants: participants,


      // ticketTypeId: widget.ticketTypeId,
      // ticketUnitPrice: widget.ticketPrice, // hoặc để BE tự tính từ ticketTypeId
    );

    return (model: model, error: null);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = _fmt;
    final totalPrice = _totalPrice;


    final double adultTotal = widget.adults * _adultPrice;
    final double childrenTotal = widget.children * _childPrice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWorkshopInfoCard(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: ColorPalette.dividerColor, thickness: 6.sp),

                   
                    _buildPaymentSummary(
                      formatter: formatter,
                      totalPrice: totalPrice,
                      adultTotal: adultTotal,
                      childrenTotal: childrenTotal,
                    ),
                    SizedBox(height: 2.h),

          
                    Text(
                      '👤 Thông tin liên hệ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                        validatorName: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Vui lòng nhập họ tên'
                                : null,
                        validatorEmail: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Vui lòng nhập email';
                          if (!_isValidEmail(t)) return 'Email không hợp lệ';
                          return null;
                        },
                        validatorPhone: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Vui lòng nhập số điện thoại';
                          if (!_isValidVietnamPhone(t)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                        validatorAddress: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Vui lòng nhập địa chỉ'
                                : null,
                      ),
                    ),

                    SizedBox(height: 2.h),


                    const Text(
                      '📘 Điều khoản & Trách nhiệm dịch vụ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const _PolicyMarkdownBox(),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'Tôi đã đọc và đồng ý với các điều khoản cam kết dịch vụ ở trên.',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),

                    const _SupportButton(),
                    SizedBox(height: 2.h),

                    _buildConfirmButton(totalPrice),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              children: [
                Text('Thông tin thanh toán',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 0.5.h),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'vi_VN')
                      .format(widget.schedule.startTime ?? DateTime.now()),
                  style: TextStyle(fontSize: 15.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(width: 25.sp),
        ],
      ),
    );
  }

  Widget _buildWorkshopInfoCard() {
    final img = widget.schedule.imageUrl ??
        (widget.workshop.imageList.isNotEmpty
            ? widget.workshop.imageList.first
            : AssetHelper.img_default);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 24.w,
              height: 10.h,
              child: img.startsWith('http')
                  ? Image.network(img, fit: BoxFit.cover)
                  : Image.asset(img, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workshop.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkshopDetailScreen(
                          workshopId: widget.workshop.workshopId ?? '',
                          selectedScheduleId: widget.schedule.scheduleId,
                          readOnly: true,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Xem chi tiết",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary({
    required NumberFormat formatter,
    required double totalPrice,
    required double adultTotal,
    required double childrenTotal,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: Colors.deepOrange),
              SizedBox(width: 2.w),
              Text('Chi tiết thanh toán',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700)),
            ],
          ),
          SizedBox(height: 1.5.h),
          if (_usingTicketType) ...[
            _buildPriceRow(
              '🎟️ ${widget.ticketTypeName ?? 'Loại vé'}',
              _peopleCount,
              widget.ticketPrice?.toDouble() ?? 0,
            ),
          ] else ...[
            _buildPriceRow('👨 Người lớn', widget.adults, _adultPrice),
            SizedBox(height: 0.6.h),
            _buildPriceRow('🧒 Trẻ em', widget.children, _childPrice),
          ],

          Divider(height: 2.5.h, color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('💰 Tổng cộng:',
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade900)),
              Text('${formatter.format(totalPrice)}đ',
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int quantity, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label x$quantity',
            style: TextStyle(fontSize: 13.5.sp, color: Colors.brown.shade800)),
        Text('${_fmt.format(quantity * price)}đ',
            style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildConfirmButton(double totalPrice) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_agreed && !_loadingUser)
            ? () async {
                final payload = _buildPayload();
                if (payload.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(payload.error!)),
                  );
                  return;
                }

                final model = payload.model!;
                final booking =
                    await BookingRepository().createWorkshopBooking(model);

                if (booking == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tạo booking thất bại.')),
                  );
                  return;
                }

                final bookingId = booking.id;
                final paymentUrl =
                    await BookingRepository().createPaymentLink(bookingId);

                if (paymentUrl != null) {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkshopQrPaymentScreen(
                        workshop: widget.workshop,
                        schedule: widget.schedule,
                        adults: widget.adults,
                        children: widget.children,
                        totalPrice: totalPrice,
                        startTime: DateTime.now(),
                        checkoutUrl: paymentUrl,

                        // NEW: truyền sang QR screen nếu bạn muốn hiển thị
                        // ticketTypeId: widget.ticketTypeId,
                        // ticketTypeName: widget.ticketTypeName,
                        // ticketPrice: widget.ticketPrice,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tạo liên kết thanh toán thất bại.')),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          backgroundColor: ColorPalette.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          "Xác nhận và thanh toán",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PolicyMarkdownBox extends StatelessWidget {
  const _PolicyMarkdownBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const MarkdownBody(
        data: '''
🚩 **Cam kết dịch vụ Workshop Travelogue**

✅ Đến đúng giờ theo lịch đã chọn.

✅ **Tuân thủ tuyệt đối** hướng dẫn của nghệ nhân & nhân viên hỗ trợ.

✅ Mặc trang phục **thoải mái, lịch sự**, phù hợp với hoạt động thủ công.

✅ Giữ gìn vệ sinh, không gây ồn ào, bảo vệ môi trường làng nghề.

✅ Bạn có thể **huỷ đặt chỗ trong vòng 24 giờ** kể từ khi đặt (nếu quá thời hạn, vui lòng liên hệ để được hỗ trợ tuỳ trường hợp).

✨ *Travelogue hân hạnh đồng hành cùng bạn trong hành trình trải nghiệm văn hoá làng nghề.* ✨
''',
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await _showCallSupportDialog(context);
          if (confirmed == true) {
            final Uri callUri = Uri(scheme: 'tel', path: '0336626193');
            if (await canLaunchUrl(callUri)) {
              await launchUrl(callUri);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
              );
            }
          }
        },
        icon: const Icon(Icons.headset_mic, color: Colors.blue),
        label: Text(
          'Liên hệ hỗ trợ',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blue),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }

  static Future<bool?> _showCallSupportDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.headset_mic, color: Colors.blueAccent),
              ),
              SizedBox(height: 2.h),
              Text(
                "Gọi hỗ trợ từ Travelogue?",
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.2.h),
              Text(
                "Bạn có muốn gọi ngay cho chúng tôi qua số 0336 626 193 để được tư vấn & hỗ trợ nhanh chóng?",
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        child: Text("Huỷ", style: TextStyle(fontSize: 13.5.sp)),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                      child: Text("Gọi ngay",
                          style: TextStyle(
                              fontSize: 13.5.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
  final String? Function(String?)? validatorName;
  final String? Function(String?)? validatorEmail;
  final String? Function(String?)? validatorPhone;
  final String? Function(String?)? validatorAddress;

  const _ContactCard({
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

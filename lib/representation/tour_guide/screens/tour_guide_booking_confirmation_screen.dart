import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_qr_payment_screen.dart';

class GuideBookingConfirmationScreen extends StatefulWidget {
  static const String routeName = '/guide-booking-confirmation';

  final TourGuideModel guide;
  final DateTime startDate;
  final DateTime endDate;
  final int adults;
  final int children;

  const GuideBookingConfirmationScreen({
    super.key,
    required this.guide,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
  });

  @override
  State<GuideBookingConfirmationScreen> createState() =>
      _GuideBookingConfirmationScreenState();
}

class _GuideBookingConfirmationScreenState
    extends State<GuideBookingConfirmationScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  final hasAcceptedTerms = ValueNotifier<bool>(false);
  bool isLoading = false;
  String? bookingId;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  Future<void> _changeDateRange() async {
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
    final model = CreateBookingTourGuideModel(
      tripPlanId: null,
      tourGuideId: widget.guide.id!,
      startDate: widget.startDate!,
      endDate: _endDate,
      adultCount: widget.adults,
      childrenCount: widget.children,
    );

    context.read<BookingBloc>().add(CreateTourGuideBookingEvent(model));
    setState(() => isLoading = true);
  }

  void _onBookingSuccess(String bookingId) {
    context
        .read<BookingBloc>()
        .add(CreatePaymentLinkEvent(bookingId, fromGuide: true));
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
        ),
      ),
    );
  }

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
      child: WillPopScope(
        onWillPop: () async => await _showExitConfirmDialog(context) ?? false,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9FAFC),
              body: SafeArea(
                child: Column(
                  children: [
                    _buildTopBanner(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard(formatter, currencyFormat),
                            SizedBox(height: 2.h),
                            _buildPolicyCard(hasAcceptedTerms),
                            SizedBox(height: 3.h),
                            _buildConfirmSection(currencyFormat),
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

  Widget _buildTopBanner(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.guide.avatarUrl != null &&
                      widget.guide.avatarUrl!.isNotEmpty
                  ? NetworkImage(widget.guide.avatarUrl!)
                  : const AssetImage(AssetHelper.avatar) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.35), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          left: 3.w,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87),
              onPressed: () async {
                final shouldLeave = await _showExitConfirmDialog(context);
                if (shouldLeave == true) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: -6.h,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 6.h,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 5.5.h,
                backgroundImage: widget.guide.avatarUrl != null
                    ? NetworkImage(widget.guide.avatarUrl!)
                    : const AssetImage(AssetHelper.avatar) as ImageProvider,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(DateFormat formatter, NumberFormat currencyFormat) {
    final price = widget.guide.price != null
        ? "${currencyFormat.format(widget.guide.price)}/ngày"
        : "Không rõ";

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.guide.userName ?? "Hướng dẫn viên",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.orange, size: 16.sp),
              SizedBox(width: 2.w),
              Text(price,
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade800)),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBDEFB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('📅 Ngày đặt:',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)),
                    GestureDetector(
                      onTap: _changeDateRange,
                      child: Icon(Icons.edit_calendar_outlined,
                          color: Colors.blue, size: 18.sp),
                    )
                  ],
                ),
                SizedBox(height: 0.8.h),
                Text(
                    '${formatter.format(_startDate)} → ${formatter.format(_endDate)}',
                    style: TextStyle(fontSize: 13.5.sp)),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(Icons.group, color: Colors.indigo, size: 16.sp),
                    SizedBox(width: 2.w),
                    Text(
                      'Người lớn: ${widget.adults}, Trẻ em: ${widget.children}',
                      style: TextStyle(
                          fontSize: 13.5.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(ValueNotifier<bool> hasAcceptedTerms) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.2.h),
            child: TitleWithCustoneUnderline(
              text: 'Điều khoản ',
              text2: '& Trách nhiệm',
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Vui lòng đọc kỹ trước khi xác nhận:',
                  style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade700),
                ),
                SizedBox(height: 1.h),
                _buildPolicyLine(
                    '📞 Hướng dẫn viên sẽ liên hệ trước ngày đi để xác nhận.'),
                _buildPolicyLine(
                    '🪪 Vui lòng mang theo giấy tờ tùy thân hợp lệ khi tham gia tour.'),
                _buildPolicyLine(
                    '⏰ Quý khách cần có mặt đúng giờ theo lịch trình.'),
                _buildPolicyLine(
                    '🔁 Mọi thay đổi cần thông báo ít nhất 24h trước giờ khởi hành.'),
                _buildPolicyLine(
                    '📄 Sau khi xác nhận đặt, mọi yêu cầu hoàn/hủy sẽ được xử lý theo chính sách của Travelogue.'),
                SizedBox(height: 1.5.h),
                Center(
                  child: Text(
                    '💙 Cảm ơn bạn đã tin tưởng Travelogue!',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: hasAcceptedTerms,
                builder: (context, value, _) => Checkbox(
                  value: value,
                  activeColor: ColorPalette.primaryColor,
                  onChanged: (val) => hasAcceptedTerms.value = val ?? false,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => hasAcceptedTerms.value = !hasAcceptedTerms.value,
                  child: Text(
                    'Tôi đã đọc và đồng ý với các điều khoản & trách nhiệm.',
                    style: TextStyle(
                        fontSize: 12.5.sp, color: Colors.blueGrey.shade900),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPolicyLine(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.blueGrey.shade800,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }

Widget _buildConfirmSection(NumberFormat currencyFormat) {
  final totalDays = _endDate.difference(_startDate).inDays + 1;
  final guidePricePerDay = widget.guide.price ?? 0;
  final totalPrice = totalDays * guidePricePerDay;

  return ValueListenableBuilder<bool>(
    valueListenable: hasAcceptedTerms,
    builder: (context, accepted, _) => Row(
      children: [
        Expanded(
          child: Text(
            "Tổng $totalDays ngày: ${currencyFormat.format(totalPrice)}",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: accepted ? _onConfirmBooking : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.4.h),
            backgroundColor: ColorPalette.primaryColor,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            elevation: 5,
          ),
          child: Text(
            "Xác nhận",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5.sp,
                color: Colors.white),
          ),
        ),
      ],
    ),
  );
}


  Future<bool?> _showExitConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Huỷ đặt hướng dẫn viên?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            "Bạn có chắc chắn muốn quay lại và huỷ đặt hướng dẫn viên này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đồng ý", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

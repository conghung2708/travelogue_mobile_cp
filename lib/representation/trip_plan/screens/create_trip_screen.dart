import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_trip_day_screen.dart';

class CreateTripScreen extends StatefulWidget {
  static const routeName = '/create-trip';

  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isFocused = false;
  DateTime? _startDate;
  DateTime? _endDate;

  void _handleNext() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy nhập tên hành trình của bạn.')),
      );
      return;
    }

    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      // ✅ Dùng pushNamed thay vì pushReplacementNamed
      final result = await Navigator.pushNamed(
        context,
        SelectTripDayScreen.routeName,
        arguments: {
          'name': name,
          'startDate': picked.start,
          'endDate': picked.end,
        },
      );

      if (result != null) {
        Navigator.pop(context, result); // ✅ Gửi kết quả về lại MyTripPlansScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.w),
              bottomRight: Radius.circular(6.w),
            ),
            child: Stack(
              children: [
                Container(
                  height: 38.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetHelper.img_ex_ba_den_5),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2.h,
                  left: 6.w,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 18.sp),
                      SizedBox(width: 1.w),
                      Text(
                        'Tây Ninh',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: const BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_location_alt_rounded,
                            color: Colors.blueAccent),
                        SizedBox(width: 2.w),
                        Text(
                          "✍️ Đặt tên hành trình để dễ nhớ hơn",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Nhập tên hành trình bạn mơ ước...',
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          speed: const Duration(milliseconds: 70),
                        ),
                      ],
                      totalRepeatCount: 1,
                      pause: const Duration(milliseconds: 500),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    SizedBox(height: 2.5.h),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() => _isFocused = hasFocus);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F3F7),
                          borderRadius: BorderRadius.circular(3.w),
                          border: Border.all(
                            color: _isFocused
                                ? Colors.blueAccent
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.title_rounded,
                                color: Colors.blueAccent),
                            hintText: 'Ví dụ: Tây Ninh – Ẩm thực & Văn hóa',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 4.w),
                          ),
                          style: TextStyle(fontSize: 13.5.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        icon: const Icon(Icons.calendar_month_outlined,
                            color: Colors.white),
                        label: Text(
                          "Tiếp tục",
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (_startDate != null && _endDate != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          "📅 ${DateFormat('dd/MM/yyyy').format(_startDate!)} → ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                          style: TextStyle(
                              fontSize: 12.5.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700]),
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

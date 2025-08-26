import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_trip_day_screen.dart';

import 'package:travelogue_mobile/core/blocs/media/media_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_event.dart';
import 'package:travelogue_mobile/core/blocs/media/media_state.dart';

class CreateTripScreen extends StatefulWidget {
  static const routeName = '/create-trip';
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isFocused = false;
  bool _isDescFocused = false;
  DateTime? _startDate;
  DateTime? _endDate;

  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  String? _coverUrl;
  bool _isUploadingImage = false;

  bool _loadingShown = false;

  ImageProvider<Object> _buildHeaderImage() {
    if (_selectedFile != null) {
      return FileImage(_selectedFile!);
    }
    return const AssetImage(AssetHelper.img_ex_ba_den_5);
  }

  void _showLoading() {
    if (_loadingShown) return;
    _loadingShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    if (_loadingShown && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    _loadingShown = false;
  }

  DateTime _atStartOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pickImageAndUpload() async {
    final x = await _picker.pickImage(
      imageQuality: 90,
      source: ImageSource.gallery,
    );
    if (x == null) return;

    setState(() {
      _selectedFile = File(x.path);
      _isUploadingImage = true;
    });

    context.read<MediaBloc>().add(UploadMultipleImagesEvent([_selectedFile!]));
  }

  Future<void> _handleNext() async {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();

    final now = DateTime.now();
    final minStart = _atStartOfDay(now.add(const Duration(days: 2)));

    final picked = await showDateRangePicker(
      context: context,
      firstDate: minStart,
      lastDate: DateTime(now.year + 2),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(
              start: _startDate!.isBefore(minStart) ? minStart : _startDate!,
              end: _endDate!.isBefore(minStart) ? minStart : _endDate!,
            )
          : null,
      locale: const Locale('vi', 'VN'),
    );

    if (picked == null) return;

    final normalizedStart = _atStartOfDay(picked.start);
    final normalizedEnd = _atStartOfDay(picked.end);

    if (normalizedStart.isBefore(minStart)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Chỉ được chọn từ ${DateFormat('dd/MM/yyyy').format(minStart)} trở đi.')),
      );
      return;
    }

    setState(() {
      _startDate = normalizedStart;
      _endDate = normalizedEnd;
    });

    context.read<TripPlanBloc>().add(
          CreateTripPlanEvent(
            name: name,
            description: description,
            startDate: normalizedStart,
            endDate: normalizedEnd,
            imageUrl: _coverUrl,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TripPlanBloc, TripPlanState>(
          listener: (context, state) async {
            if (state is TripPlanLoading) {
              _showLoading();
            } else {
              _hideLoading();
            }

            if (state is CreateTripPlanSuccess) {
              final detail = state.tripPlanDetail;
              if (!mounted) return;

              Navigator.pushReplacementNamed(
                context,
                SelectTripDayScreen.routeName,
                arguments: {'detail': detail},
              );
            } else if (state is TripPlanError) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<MediaBloc, MediaState>(
          listener: (context, state) {
            if (state is MediaUploading) {
              setState(() => _isUploadingImage = true);
            } else if (state is MediaUploadSuccess) {
              setState(() {
                _isUploadingImage = false;
                _coverUrl = state.urls.isNotEmpty ? state.urls.first : null;
                // _selectedFile = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tải ảnh lên thành công.')),
              );
            } else if (state is MediaUploadFailure) {
              setState(() => _isUploadingImage = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi upload: ${state.error}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _buildHeaderImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    left: 6.w,
                    right: 6.w,
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.white, size: 18.sp),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            'Tây Ninh',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              shadows: const [
                                Shadow(color: Colors.black45, blurRadius: 6)
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              _isUploadingImage ? null : _pickImageAndUpload,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.blueAccent,
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: Text(
                              _coverUrl == null ? 'Chọn ảnh bìa' : 'Đổi ảnh'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Form =====
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.2.h),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🖼️ Ảnh bìa",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 1.2.h),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FC),
                          borderRadius: BorderRadius.circular(3.w),
                          border: Border.all(color: const Color(0xFFE6E8F0)),
                        ),
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isUploadingImage)
                              const LinearProgressIndicator(minHeight: 4),
                            SizedBox(height: 1.2.h),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (_selectedFile != null)
                                      Image.file(_selectedFile!,
                                          fit: BoxFit.cover)
                                    else
                                      Image.asset(AssetHelper.img_ex_ba_den_5,
                                          fit: BoxFit.cover),
                                    if (_isUploadingImage)
                                      Container(
                                        color: Colors.black26,
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (_coverUrl != null)
                              Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        'Ảnh bìa đã được lưu thành công.',
                                        style:
                                            TextStyle(color: Colors.green[800]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.8.h),
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
                                color: Colors.black87),
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
                        onFocusChange: (hasFocus) =>
                            setState(() => _isFocused = hasFocus),
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
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2)),
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
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          const Icon(Icons.notes_rounded,
                              color: Colors.blueAccent),
                          SizedBox(width: 2.w),
                          Text(
                            "📝 Mô tả ngắn cho hành trình",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.2.h),
                      Focus(
                        onFocusChange: (hasFocus) =>
                            setState(() => _isDescFocused = hasFocus),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3F7),
                            borderRadius: BorderRadius.circular(3.w),
                            border: Border.all(
                              color: _isDescFocused
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _descController,
                            maxLines: 3,
                            minLines: 2,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.short_text_rounded,
                                  color: Colors.blueAccent),
                              hintText:
                                  'Ví dụ: Lịch trình 2N1Đ khám phá văn hóa & ẩm thực.',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 1.6.h, horizontal: 4.w),
                            ),
                            style: TextStyle(fontSize: 13.5.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Chỉ đặt từ ${DateFormat('dd/MM/yyyy').format(_atStartOfDay(DateTime.now().add(const Duration(days: 2))))} trở đi.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
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
                                color: Colors.white),
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
      ),
    );
  }
}

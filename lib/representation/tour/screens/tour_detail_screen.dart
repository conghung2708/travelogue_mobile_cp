// lib/representation/tour/tour_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_detail_content.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';

class TourDetailScreen extends StatefulWidget {
  static const routeName = '/tour_detail';

  final TourModel tour;
  final String image;
  final bool readOnly;
  final DateTime? startTime; // thời điểm user chọn (nếu có)
  final bool? isBooked;
  final bool showGuideTab;

  const TourDetailScreen({
    super.key,
    required this.tour,
    required this.image,
    this.readOnly = false,
    this.startTime,
    this.isBooked = false,
    this.showGuideTab = true,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<TourModel?> _futureDetail;

  // xoay liên tục cho FAB (chỉ hộp xoay, icon đứng yên)
  late final AnimationController _spinCtrl;

  // số hỗ trợ; nếu lấy được số guide thì mình sẽ cập nhật
  String _supportPhone = '0336626193';

  @override
  void initState() {
    super.initState();
    _futureDetail = TourRepository().getTourById(widget.tour.tourId!);

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // xoay liên tục
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    super.dispose();
  }

  // ===== Helper chọn schedule/guide =====

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  TourScheduleModel? _pickSchedule(
      List<TourScheduleModel> schedules, DateTime? desired) {
    if (schedules.isEmpty) return null;

    if (desired != null) {
      for (final s in schedules) {
        final st = s.startTime;
        final et = s.endTime;
        if (st != null && et != null) {
          if (!desired.isBefore(st) && desired.isBefore(et)) return s;
        }
      }
      for (final s in schedules) {
        final st = s.startTime;
        if (st != null && _isSameDate(st, desired)) return s;
      }
    }

    final now = DateTime.now();
    final futureSorted = schedules
        .where((s) => s.startTime != null && !s.startTime!.isBefore(now))
        .toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));
    if (futureSorted.isNotEmpty) return futureSorted.first;

    final firstWithGuide = schedules.firstWhere(
      (s) => s.tourGuide != null,
      orElse: () => schedules.first,
    );
    return firstWithGuide;
  }

  TourGuideModel? _pickGuideFromSchedules(
      List<TourScheduleModel> schedules, DateTime? desired) {
    final sch = _pickSchedule(schedules, desired);
    return sch?.tourGuide;
  }

  // Dialog support đẹp
  Future<bool> _confirmSupportDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        'Hỗ trợ từ Travelogue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: Column(
                      children: [
                        const Text(
                          'Bạn có muốn nhận sự hỗ trợ từ đội ngũ Travelogue?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Đội ngũ hoạt động từ 8:00 – 22:00 hằng ngày.',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone_in_talk_rounded,
                                  color: Color(0xFF1976D2)),
                              const SizedBox(width: 10),
                              Text(
                                _supportPhone,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1976D2)),
                              foregroundColor: const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Để sau'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Gọi ngay'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final isAsset = widget.image.startsWith('assets/');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                isAsset
                    ? Image.asset(
                        widget.image,
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.image,
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  top: 2.h,
                  left: 4.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<TourModel?>(
                future: _futureDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi tải tour chi tiết: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('Không tìm thấy tour.'));
                  }

                  final tour = snapshot.data!;

                  final guideFromSchedules =
                      _pickGuideFromSchedules(tour.schedules, widget.startTime);
                  final guideToShow = guideFromSchedules ?? tour.tourGuide;

                  final phoneFromGuide = "0336626193";
                  if (phoneFromGuide != null &&
                      phoneFromGuide.trim().isNotEmpty) {
                    _supportPhone = phoneFromGuide.trim();
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: TourDetailContent(
                      tour: tour,
                      guide: guideToShow,
                      readOnly: widget.readOnly,
                      startTime: widget.startTime,
                      isBooked: widget.isBooked,
                      showGuideTab: widget.showGuideTab,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.readOnly
          ? null
          : GestureDetector(
              onTap: () async {
                final confirm = await _confirmSupportDialog(context);
                if (confirm == true) {
                  final phoneUri = Uri(scheme: 'tel', path: _supportPhone);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Không thể thực hiện cuộc gọi.')),
                    );
                  }
                }
              },
              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(parent: _spinCtrl, curve: Curves.linear),
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  // icon KHÔNG xoay (chỉ hộp xoay)
                  child: const Center(
                    child: Icon(Icons.support_agent,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tay_ninh_location.dart';
import 'package:travelogue_mobile/representation/user/widgets/tay_ninh_timeline_screen.dart';

class TayNinhPredictorScreen extends StatefulWidget {
  const TayNinhPredictorScreen({super.key});
  static const routeName = '/tayninh_predictor';

  @override
  State<TayNinhPredictorScreen> createState() => _TayNinhPredictorScreenState();
}

class _TayNinhPredictorScreenState extends State<TayNinhPredictorScreen> {
  String? _style;
  String? _group;
  String? _duration;
  String? _season;

  final _styles = [
    'Văn hoá – Tâm linh',
    'Thiên nhiên – Núi rừng',
    'Trải nghiệm – Mạo hiểm',
    'Lịch sử – Di tích',
    'Chụp ảnh – Sống ảo',
    'Nghỉ dưỡng – Thư giãn',
  ];

  final _groups = [
    'Một mình',
    'Cặp đôi',
    'Gia đình',
    'Nhóm bạn',
    'Người lớn tuổi',
  ];

  final _durations = ['1 ngày', '2 ngày', '3 ngày'];

  final _seasons = ['Mùa khô (12–4)', 'Mùa mưa (5–11)', 'Lễ hội lớn'];

  void _generateSuggestion() {
    if (_style == null ||
        _group == null ||
        _duration == null ||
        _season == null) {
      return;
    }

    final int days = int.tryParse(_duration!.split(' ')[0]) ?? 1;
    final List<TayNinhLocation> pool =
        List<TayNinhLocation>.from(tayNinhLocationsByStyle[_style] ?? []);
    pool.shuffle();
    final lunchPool = List<TayNinhLocation>.from(lunchOptions)..shuffle();

    final used = <TayNinhLocation>{};
    final schedule = <List<TayNinhLocation>>[];

    for (int i = 0; i < days; i++) {
      final remaining = pool.where((e) => !used.contains(e)).toList();
      final morning = remaining.firstWhere((e) => e.time == 'Sáng',
          orElse: () => TayNinhLocation.empty());
      final afternoon = remaining.firstWhere((e) => e.time == 'Chiều',
          orElse: () => TayNinhLocation.empty());
      final lunch = lunchPool[i % lunchPool.length];

      final dayPlan = <TayNinhLocation>[];
      if (morning.title.isNotEmpty) {
        used.add(morning);
        dayPlan.add(morning);
      }
      dayPlan.add(lunch);
      if (afternoon.title.isNotEmpty) {
        used.add(afternoon);
        dayPlan.add(afternoon);
      }

      schedule.add(dayPlan);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TayNinhTimelineScreen(schedule: schedule),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(AssetHelper.img_logo_travelogue,
                height: 20.w, width: 20.w, fit: BoxFit.contain),
            SizedBox(width: 3.w),
            Text('Tây Ninh đi đâu ?',
                style: TextStyle(fontSize: 20.sp, fontFamily: "Pattaya")),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Icon(Icons.question_answer_outlined,
                        color: Colors.teal, size: 24.sp),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Bạn không biết đi đâu? Để Go Young giúp bạn lên lịch trình nè! 💡',
                        style: TextStyle(fontSize: 14.sp, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            _buildDropdownCard(
                '1. Bạn thích kiểu du lịch nào?',
                _styles,
                _style,
                (val) => setState(() => _style = val),
                Icons.explore_outlined),
            _buildDropdownCard(
                '2. Bạn đi với ai?',
                _groups,
                _group,
                (val) => setState(() => _group = val),
                Icons.people_alt_outlined),
            _buildDropdownCard(
                '3. Bạn muốn đi mấy ngày?',
                _durations,
                _duration,
                (val) => setState(() => _duration = val),
                Icons.calendar_today_outlined),
            _buildDropdownCard('4. Bạn đi vào thời điểm nào?', _seasons,
                _season, (val) => setState(() => _season = val), Icons.sunny),
            SizedBox(height: 1.h),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateSuggestion,
                icon: const Icon(Icons.travel_explore_outlined),
                label: const Text('Dự đoán điểm đến'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard(String label, List<String> options, String? value,
      void Function(String?) onChanged, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.5.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.teal, size: 18.sp),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(label,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.5.sp)),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              DropdownButtonFormField<String>(
                value: value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

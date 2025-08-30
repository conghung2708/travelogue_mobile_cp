import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/schedule_confirm_dialog.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_calendar_background.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_schedule_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_calendar_selector.dart';

class TourScheduleCalendarScreen extends StatefulWidget {
  static const String routeName = '/tour-schedule-calendar';
  const TourScheduleCalendarScreen({super.key});

  @override
  State<TourScheduleCalendarScreen> createState() =>
      _TourScheduleCalendarScreenState();
}

enum _ViewMode { calendar, list }

class _TourScheduleCalendarScreenState
    extends State<TourScheduleCalendarScreen> {
  late TourModel tour;
  late List<TourScheduleModel> schedules;
  late bool isGroupTour;


  _ViewMode _mode = _ViewMode.list;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;


  final TextEditingController _searchCtl = TextEditingController();
  String _search = '';
  int? _filterMonth; 
  int? _filterYear; 

  final formatter = NumberFormat('#,###');

  DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
  bool _isPastOrToday(DateTime day) => !_d(day).isAfter(_d(DateTime.now()));
  bool get _hasAnyUpcoming => schedules
      .any((s) => s.startTime != null && s.startTime!.isAfter(DateTime.now()));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as TourCalendarArgs;
    tour = args.tour;
    schedules = args.schedules;
    isGroupTour = args.isGroupTour;
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  TourScheduleModel? getScheduleForDay(DateTime day) {
    if (_isPastOrToday(day)) return null;
    return schedules.firstWhereOrNull((s) {
      final dep = s.startTime;
      return dep != null &&
          dep.year == day.year &&
          dep.month == day.month &&
          dep.day == day.day;
    });
  }

  void _openConfirm(TourScheduleModel matched) {
    final media = (tour.medias.isNotEmpty &&
            tour.medias.first.mediaUrl?.isNotEmpty == true)
        ? tour.medias.first.mediaUrl!
        : AssetHelper.img_tay_ninh_login;

    ScheduleConfirmDialog.show(
      context,
      tour: tour,
      schedule: matched,
      isGroupTour: isGroupTour,
      media: media,
      formatter: formatter,
    );
  }

  Future<void> _jumpToMonth() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (_) => _YearMonthPickerSheet(
        initial: focusedDay,
        firstYear: DateTime.now().year,
        lastYear: DateTime.now().year + 2,
      ),
    );
    if (picked != null) {
      setState(() {
        focusedDay = DateTime(picked.year, picked.month);
        _mode = _ViewMode.calendar;
      });
    }
  }

  void _goToNextAvailable({bool switchToCalendarIfNeeded = true}) {
    final now = DateTime.now();
    final sorted = [...schedules]
      ..retainWhere((s) => s.startTime != null && s.startTime!.isAfter(now))
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    final next = sorted.firstOrNull;
    if (next == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không còn lịch nào sắp tới.')),
      );
      return;
    }
    setState(() {
      focusedDay = DateTime(next.startTime!.year, next.startTime!.month);
      selectedDay = next.startTime;
      if (switchToCalendarIfNeeded) _mode = _ViewMode.calendar;
    });
  }


  List<TourScheduleModel> _filteredSchedules() {
    final now = DateTime.now();
    final query = _search.trim().toLowerCase();
    final items = schedules.where((s) => s.startTime != null).toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    return items.where((s) {
      final d = s.startTime!;
      if (_filterMonth != null && d.month != _filterMonth) return false;
      if (_filterYear != null && d.year != _filterYear) return false;


      if (query.isNotEmpty) {
        final labelDate =
            DateFormat('dd/MM/yyyy', 'vi_VN').format(d).toLowerCase();
        final labelDayOfWeek =
            DateFormat('EEE', 'vi_VN').format(d).toLowerCase();
        final labelTime = DateFormat('HH:mm', 'vi_VN').format(d).toLowerCase();
        final title = ((tour.name ?? tour.name) ?? '').toLowerCase();

        final combined = '$labelDate $labelDayOfWeek $labelTime $title';
        if (!combined.contains(query)) return false;
      }

      if (!d.isAfter(now)) return false;
      return true;
    }).toList();
  }

  Map<String, List<TourScheduleModel>> _groupByMonth(
      List<TourScheduleModel> list) {
    final map = <String, List<TourScheduleModel>>{};
    for (final s in list) {
      final d = s.startTime!;
      final key = DateFormat('MMMM yyyy', 'vi_VN').format(d);
      map.putIfAbsent(key, () => []).add(s);
    }
    return map;
  }

  void _applyMonthFilterFromFocused() {
    setState(() {
      _filterMonth = focusedDay.month;
      _filterYear = focusedDay.year;
      _mode = _ViewMode.list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const TourCalendarBackground(
            image: AssetHelper.img_tour_type_selector,
            overlayOpacity: 0.6,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                
                  TourScheduleHeader(onBack: () => Navigator.pop(context)),
                  SizedBox(height: 1.5.h),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 8,
                    spacing: 10,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButton<_ViewMode>(
                          value: _mode,
                          underline: const SizedBox.shrink(),
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: Colors.black87,
                          style: text.labelLarge?.copyWith(color: Colors.white),
                          items: const [
                            DropdownMenuItem(
                              value: _ViewMode.calendar,
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_rounded,
                                      size: 18, color: Colors.white70),
                                  SizedBox(width: 8),
                                  Text('Lịch'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: _ViewMode.list,
                              child: Row(
                                children: [
                                  Icon(Icons.view_list_rounded,
                                      size: 18, color: Colors.white70),
                                  SizedBox(width: 8),
                                  Text('Danh sách'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => _mode = v!),
                        ),
                      ),

                     
                      // Wrap(
                      //   spacing: 8,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   children: [
                    
                      //     OutlinedButton.icon(
                      //       onPressed: () => _goToNextAvailable(
                      //         switchToCalendarIfNeeded: _mode == _ViewMode.calendar,
                      //       ),
                      //       style: OutlinedButton.styleFrom(
                      //         foregroundColor: Colors.white,
                      //         side: BorderSide(color: Colors.white24),
                      //         padding: EdgeInsets.symmetric(
                      //           horizontal: 3.w, vertical: .9.h),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12)),
                      //       ),
                      //       icon: const Icon(Icons.skip_next_rounded, size: 18),
                      //       label: const Text('Lịch gần nhất'),
                      //     ),

                    
                      //     TextButton.icon(
                      //       onPressed: _jumpToMonth,
                      //       style: TextButton.styleFrom(
                      //         foregroundColor: Colors.white,
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 3.w, vertical: .8.h),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //       ),
                      //       icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      //       label: const Text('Tới tháng...'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  if (_mode == _ViewMode.calendar)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _applyMonthFilterFromFocused,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white24),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.list_rounded, size: 18),
                        label: const Text('Xem lịch tháng này'),
                      ),
                    ),

                  SizedBox(height: 1.2.h),

                  if (_mode == _ViewMode.calendar) ...[
                    _CalendarShell(
                      child: TourCalendarSelector(
                        focusedDay: focusedDay,
                        selectedDay: selectedDay,
                        getScheduleForDay: getScheduleForDay,
                        onDaySelected: (selected, focused) {
                          if (_isPastOrToday(selected)) {
                            _showEmptyDayHint(context);
                            return;
                          }

                          final matched = getScheduleForDay(selected);
                          if (matched != null) {
                            _openConfirm(matched);
                          } else {
                            _showEmptyDayHint(context);
                          }

                          setState(() {
                            selectedDay = selected;
                            focusedDay = focused;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 1.6.h),
                    Text(
                      '🗓️ Chọn đúng thời điểm – mở ra chuyến đi đáng nhớ!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ] else ...[
                    _ListFilters(
                      searchCtl: _searchCtl,
                      onKeywordChanged: (v) => setState(() => _search = v),
                      filterMonth: _filterMonth,
                      filterYear: _filterYear,
                      onClearFilters: () => setState(() {
                        _searchCtl.clear();
                        _search = '';
                        _filterMonth = null;
                        _filterYear = null;
                      }),
                      onPickMonth: () async {
                        final picked = await showModalBottomSheet<DateTime>(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4.w)),
                          ),
                          builder: (_) => _YearMonthPickerSheet(
                            initial: DateTime(
                                _filterYear ?? DateTime.now().year,
                                _filterMonth ?? DateTime.now().month),
                            firstYear: DateTime.now().year,
                            lastYear: DateTime.now().year + 2,
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _filterMonth = picked.month;
                            _filterYear = picked.year;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 1.2.h),
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          final data = _filteredSchedules();
                          if (data.isEmpty) {
                            return _EmptyListHint(
                              onNextAvailable: _hasAnyUpcoming
                                  ? () => _goToNextAvailable(
                                      switchToCalendarIfNeeded: false)
                                  : null,
                            );
                          }
                          final grouped = _groupByMonth(data);
                          return _ScheduleListView(
                            tour: tour,
                            groups: grouped,
                            onTapSchedule: _openConfirm,
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmptyDayHint(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.surface.withOpacity(.95),
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ngày này chưa có lịch. Bạn có thể xem lịch trong tháng hoặc nhảy tới lịch gần nhất.',
                style:
                    text.bodyMedium?.copyWith(color: cs.onSurface, height: 1.2),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _goToNextAvailable,
              child: const Text('Lịch gần nhất'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarShell extends StatelessWidget {
  final Widget child;
  const _CalendarShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class _ListFilters extends StatelessWidget {
  final TextEditingController searchCtl;
  final ValueChanged<String> onKeywordChanged;
  final int? filterMonth;
  final int? filterYear;
  final VoidCallback onClearFilters;
  final Future<void> Function() onPickMonth;

  const _ListFilters({
    required this.searchCtl,
    required this.onKeywordChanged,
    required this.filterMonth,
    required this.filterYear,
    required this.onClearFilters,
    required this.onPickMonth,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final chipLabel = (filterMonth != null && filterYear != null)
        ? '${DateFormat('MMMM', 'vi_VN').format(DateTime(2000, filterMonth!))} $filterYear'
        : null;

    return Column(
      children: [
        // Tìm kiếm
        // TextField(
        //   controller: searchCtl,
        //   onChanged: onKeywordChanged,
        //   style: const TextStyle(color: Colors.white),
        //   decoration: InputDecoration(
        //     hintText: 'Tìm nhanh theo ngày',
        //     hintStyle: const TextStyle(color: Colors.white70),
        //     prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
        //     filled: true,
        //     fillColor: Colors.white.withOpacity(.10),
        //     contentPadding:
        //         EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(14),
        //       borderSide: BorderSide(color: Colors.white24),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(14),
        //       borderSide: BorderSide(color: Colors.white24),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(14),
        //       borderSide: BorderSide(color: cs.primary),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 1.h),

  
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onPickMonth,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white24),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .9.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.filter_alt_rounded, size: 18),
              label: const Text('Tháng/Năm'),
            ),
            SizedBox(width: 2.w),
            if (chipLabel != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(chipLabel,
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onClearFilters,
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            TextButton(
              onPressed: onClearFilters,
              child: const Text('Xoá lọc'),
            ),
          ],
        )
      ],
    );
  }
}

class _ScheduleListView extends StatelessWidget {
  final TourModel tour;
  final Map<String, List<TourScheduleModel>> groups;
  final void Function(TourScheduleModel) onTapSchedule;

  const _ScheduleListView({
    required this.tour,
    required this.groups,
    required this.onTapSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final monthKeys = groups.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: monthKeys.length,
      itemBuilder: (_, i) {
        final key = monthKeys[i];
        final list = groups[key]!
          ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

        return Padding(
          padding: EdgeInsets.only(bottom: 1.8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .8.h),
                child: Text(
                  key.toLowerCase().replaceFirstMapped(
                        RegExp(r'^[a-zà-ỹ]'),
                        (m) => m.group(0)!.toUpperCase(),
                      ),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            
              ...list.map((s) {
                final d = s.startTime!;
                final label = DateFormat('EEE, dd/MM/yyyy', 'vi_VN').format(d);
                final title = (tour.name ?? '');

                final int max = s.maxParticipant ?? 0;
                final int booked = s.currentBooked ?? 0;
                final int available = (max - booked).clamp(0, max);
                final bool low = available <= 5; 

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: .6.h),
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(.92),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: cs.outlineVariant.withOpacity(.5)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.event_available_rounded),
                    title: Text(
                      label,
                      style: text.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: title.isNotEmpty
                        ? Text(
                            title,
                            style: text.bodySmall
                                ?.copyWith(color: cs.outline, height: 1.1),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (available == 0)
                                ? Colors.grey.shade300
                                : (low
                                    ? Colors.red.withOpacity(.12)
                                    : Colors.green.withOpacity(.12)),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: (available == 0)
                                  ? Colors.grey.shade400
                                  : (low ? Colors.redAccent : Colors.green),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                available == 0
                                    ? Icons.event_busy_rounded
                                    : Icons.event_seat_rounded,
                                size: 16,
                                color: (available == 0)
                                    ? Colors.grey.shade600
                                    : (low ? Colors.redAccent : Colors.green),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                available == 0 ? 'Hết chỗ' : '$available/${max == 0 ? "?" : max} chỗ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: (available == 0)
                                      ? Colors.grey.shade700
                                      : (low
                                          ? Colors.redAccent
                                          : Colors.green.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: () => onTapSchedule(s),
                  ),
                );
              })
            ],
          ),
        );
      },
    );
  }
}

class _EmptyListHint extends StatelessWidget {
  final VoidCallback? onNextAvailable;
  const _EmptyListHint({this.onNextAvailable});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        SizedBox(height: 12.h),
        Icon(Icons.search_off_rounded, size: 48, color: cs.outline),
        SizedBox(height: 1.2.h),
        Text(
          'Không tìm thấy lịch phù hợp',
          textAlign: TextAlign.center,
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Thử đổi từ khoá, bỏ bộ lọc, hoặc chuyển sang tháng khác.',
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: Colors.white70),
        ),
        SizedBox(height: 2.h),
        // if (onNextAvailable != null)
        //   Align(
        //     child: OutlinedButton.icon(
        //       onPressed: onNextAvailable,
        //       icon: const Icon(Icons.skip_next_rounded),
        //       label: const Text('Lịch gần nhất'),
        //       style: OutlinedButton.styleFrom(
        //         foregroundColor: Colors.white,
        //         side: BorderSide(color: Colors.white24),
        //       ),
        //     ),
        //   ),
        // SizedBox(height: 20.h),
      ],
    );
  }
}

class _YearMonthPickerSheet extends StatefulWidget {
  final DateTime initial;
  final int firstYear;
  final int lastYear;

  const _YearMonthPickerSheet({
    required this.initial,
    required this.firstYear,
    required this.lastYear,
  });

  @override
  State<_YearMonthPickerSheet> createState() => _YearMonthPickerSheetState();
}

class _YearMonthPickerSheetState extends State<_YearMonthPickerSheet> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year.clamp(widget.firstYear, widget.lastYear);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final months = List.generate(12, (i) => i + 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: cs.primary.withOpacity(.12),
                  child: Icon(Icons.calendar_month_rounded,
                      color: cs.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text('Chọn nhanh tháng & năm',
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Year picker
            SizedBox(
              height: 180,
              child: YearPicker(
                firstDate: DateTime(widget.firstYear),
                lastDate: DateTime(widget.lastYear),
                selectedDate: DateTime(_year),
                onChanged: (d) => setState(() => _year = d.year),
              ),
            ),
            const SizedBox(height: 8),
            // Month grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: months.map((m) {
                final label =
                    DateFormat('MMM', 'vi_VN').format(DateTime(2000, m));
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.onSurface,
                    side: BorderSide(color: cs.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () =>
                      Navigator.pop(context, DateTime(_year, m, 1)),
                  child: Text(label),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

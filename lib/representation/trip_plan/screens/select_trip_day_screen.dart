import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';

import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/services/vietmap_search_service.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_day_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/guide_team_selector_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';

import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_day_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_tab_button.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_header.dart';
import 'package:travelogue_mobile/representation/widgets/address_autocomplete_field.dart';

class SelectTripDayScreen extends StatefulWidget {
  static const String routeName = '/select-trip-day';
  const SelectTripDayScreen({super.key});

  @override
  State<SelectTripDayScreen> createState() => _SelectTripDayScreenState();
}

class _SelectTripDayScreenState extends State<SelectTripDayScreen>
    with SingleTickerProviderStateMixin {
  TripPlanDetailModel? _detail;
  List<DateTime> _days = [];
  late final TextEditingController _nameController;
  late final TextEditingController _pickupNameController;
  late final TextEditingController _pickupPointController;

  bool _isSyncingControllers = false;

  void _setCtl(TextEditingController c, String t) {
    c.value = c.value.copyWith(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
      composing: TextRange.empty,
    );
  }

  BoxDecoration get _tileBox => BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1.2),
      );

  InputDecoration _dialogDeco(String label, String hint, {IconData? icon}) {
    const light = BorderSide(color: Color(0xFFE6EEF8));
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7FAFF),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: light),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: light),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E7CF6), width: 1.5),
      ),
    );
  }

  String _stripDiacritics(String s) {
    const pairs = <List<String>>[
      // a / A
      ['[àáạảãâầấậẩẫăằắặẳẵ]', 'a'],
      ['[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]', 'A'],
      // e / E
      ['[èéẹẻẽêềếệểễ]', 'e'],
      ['[ÈÉẸẺẼÊỀẾỆỂỄ]', 'E'],
      // i / I
      ['[ìíịỉĩ]', 'i'],
      ['[ÌÍỊỈĨ]', 'I'],
      // o / O
      ['[òóọỏõôồốộổỗơờớợởỡ]', 'o'],
      ['[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]', 'O'],
      // u / U
      ['[ùúụủũưừứựửữ]', 'u'],
      ['[ÙÚỤỦŨƯỪỨỰỬỮ]', 'U'],
      // y / Y
      ['[ỳýỵỷỹ]', 'y'],
      ['[ỲÝỴỶỸ]', 'Y'],
      // d / D
      ['đ', 'd'],
      ['Đ', 'D'],
    ];

    var out = s;
    for (final p in pairs) {
      out = out.replaceAll(RegExp(p[0]), p[1]);
    }
    return out;
  }

  bool _isAddressInTayNinh(String s) {
    final n = _stripDiacritics(s).toLowerCase();
    return n.contains('tay ninh');
  }

  // -----------------------------------

  bool _sameYmd(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime get _todayYmd => _ymd(DateTime.now());
  DateTime get _tomorrowYmd => _todayYmd.add(const Duration(days: 1));

  bool _isTomorrow(DateTime d) => _sameYmd(_ymd(d), _tomorrowYmd);

  void _showTomorrowError(DateTime date) {
    final txt = DateFormat('dd/MM').format(date);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Không thể thêm ($txt).')),
    );
  }

  bool _dayHasActivities(DateTime day) {
    final d = _detail;
    if (d == null) return false;
    final idx = d.days.indexWhere((it) => _sameYmd(it.date, day));
    return idx != -1 && d.days[idx].activities.isNotEmpty;
  }

  Future<bool> _confirmDeleteDayUi({
    required int dayIndex,
    required bool hasAct,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      decoration: const BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep_rounded,
                              color: Colors.white, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Xoá Ngày ${dayIndex + 1}?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasAct) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Ngày này đang có hoạt động. Xoá ngày sẽ xoá vĩnh viễn toàn bộ hoạt động trong ngày này.',
                                    style: TextStyle(height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ] else ...[
                            const Text(
                              'Bạn có chắc muốn xoá ngày này khỏi hành trình?',
                              style: TextStyle(height: 1.35),
                            ),
                            const SizedBox(height: 10),
                          ],
                          const Text(
                            'Hệ thống sẽ tự rút ngắn phạm vi ngày của hành trình tương ứng (ngày đầu hoặc ngày cuối).',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: ColorPalette.dividerColor),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColorPalette.primaryColor,
                                side: const BorderSide(
                                    color: ColorPalette.primaryColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                              ),
                              child: const Text('Huỷ'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: Gradients.defaultGradientBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.delete_outline_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Xoá ngày',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  Future<void> _onDeleteDay(int index) async {
    if (_detail == null) return;
    if (_days.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xoá vì chỉ còn 1 ngày.')),
      );
      return;
    }

    final isFirst = index == 0;
    final isLast = index == _days.length - 1;

    if (!isFirst && !isLast) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ có thể xoá Ngày đầu hoặc Ngày cuối. '
              'Nếu muốn bỏ ngày giữa, hãy dùng “Sửa ngày” để chỉnh phạm vi.'),
        ),
      );
      return;
    }

    final day = _days[index];
    final hasAct = _dayHasActivities(day);

    final ok = await _confirmDeleteDayUi(
      dayIndex: index,
      hasAct: hasAct,
    );

    if (!ok) return;

    final oldStart = _ymd(_detail!.startDate);
    final oldEnd = _ymd(_detail!.endDate);

    final newStart = isFirst ? oldStart.add(const Duration(days: 1)) : oldStart;
    final newEnd = isLast ? oldEnd.subtract(const Duration(days: 1)) : oldEnd;

    final filteredPayload =
        _mapLocationsWithinRange(_detail!, newStart, newEnd);

    _pendingShortenStart = newStart;
    _pendingShortenEnd = newEnd;

    context.read<TripPlanBloc>().add(UpdateTripPlanLocationsEvent(
          tripPlanId: _detail!.id,
          locations: filteredPayload,
        ));
  }

  int _selectedTabIndex = 0;
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  TourGuideModel? _selectedGuide;
  bool _argsProcessed = false;
  String? _tripId;

  String? _initialImageUrl;
  DateTime? _pendingShortenStart;
  DateTime? _pendingShortenEnd;
  bool? _pendingAddAtStart;

  bool _leavingScreen = false;
  bool _loadingShown = false;

  void _showLoading() {
    if (_loadingShown) return;
    _loadingShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    if (!_loadingShown) return;
    _loadingShown = false;
    final root = Navigator.of(context, rootNavigator: true);
    if (root.canPop()) {
      root.pop();
    }
  }

  Future<bool> _confirmAddDayUi({
    required bool atStart,
    required DateTime dateToAdd,
  }) async {
    final dateText = DateFormat('dd/MM/yyyy').format(dateToAdd);
    final whereText = atStart ? 'ở ĐẦU hành trình' : 'ở CUỐI hành trình';

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      decoration: const BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.add_circle_outline_rounded,
                              color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Thêm 1 ngày?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bạn muốn thêm 1 ngày $whereText.'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 18, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text('Ngày mới: $dateText',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Hệ thống sẽ mở rộng phạm vi ngày của hành trình. '
                            'Bạn có thể thêm hoạt động cho ngày mới sau khi tạo.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: ColorPalette.dividerColor),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColorPalette.primaryColor,
                                side: const BorderSide(
                                    color: ColorPalette.primaryColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                              ),
                              child: const Text('Huỷ'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: Gradients.defaultGradientBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.add_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text('Thêm ngày',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  Future<void> _onAddDay({required bool atStart}) async {
    if (_detail == null) return;

    final oldStart = _ymd(_detail!.startDate);
    final oldEnd = _ymd(_detail!.endDate);

    final dateToAdd = atStart
        ? oldStart.subtract(const Duration(days: 1))
        : oldEnd.add(const Duration(days: 1));

    if (_isTomorrow(dateToAdd)) {
      _showTomorrowError(dateToAdd);
      return;
    }

    final ok = await _confirmAddDayUi(atStart: atStart, dateToAdd: dateToAdd);
    if (!ok) return;

    final newStart = atStart ? dateToAdd : oldStart;
    final newEnd = atStart ? oldEnd : dateToAdd;

    _pendingAddAtStart = atStart;

    context.read<TripPlanBloc>().add(UpdateTripPlanEvent(
          id: _detail!.id,
          name: _detail!.name,
          description: _detail!.description,
          startDate: newStart,
          endDate: newEnd,
          imageUrl: _detail!.imageUrl ?? _initialImageUrl,
        ));
  }

  DateTime _ymd(DateTime d) => DateTime(d.year, d.month, d.day);

  List<TripPlanLocationModel> _mapLocationsWithinRange(
    TripPlanDetailModel d,
    DateTime startInclusive,
    DateTime endInclusive,
  ) {
    final startDay = DateTime(
        startInclusive.year, startInclusive.month, startInclusive.day, 0, 0, 0);
    final endDay = DateTime(
        endInclusive.year, endInclusive.month, endInclusive.day, 23, 59, 59);

    final acts = <TripActivityModel>[];
    for (final day in d.days) {
      for (final a in day.activities) {
        final st = a.startTime;
        if (!st.isBefore(startDay) && !st.isAfter(endDay)) {
          acts.add(a);
        }
      }
    }

    acts.sort((a, b) => a.startTime.compareTo(b.startTime));

    final result = <TripPlanLocationModel>[];
    int runningOrder = 1;
    for (final a in acts) {
      result.add(
        TripPlanLocationModel(
          tripPlanLocationId: (a.tripPlanLocationId?.isNotEmpty ?? false)
              ? a.tripPlanLocationId
              : null,
          locationId: a.locationId,
          order: runningOrder++,
          startTime: a.startTime,
          endTime: a.endTime,
          notes: a.notes,
          travelTimeFromPrev: 0,
          distanceFromPrev: 0,
          estimatedStartTime: a.startTime.millisecondsSinceEpoch ~/ 1000,
          estimatedEndTime: a.endTime.millisecondsSinceEpoch ~/ 1000,
        ),
      );
    }
    return result;
  }

  void _rebuildDaysFromDetail(TripPlanDetailModel detail) {
    try {
      _days = detail.getDays().map(_ymd).toList();
    } catch (_) {
      final s = _ymd(detail.startDate);
      final e = _ymd(detail.endDate);
      final count = e.difference(s).inDays + 1;
      _days = List.generate(count, (i) => s.add(Duration(days: i)));
    }
    if (_selectedTabIndex >= _days.length) {
      _selectedTabIndex = _days.isEmpty ? 0 : _days.length - 1;
    }
  }

  String _money(num v) =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(v);

  int get _numDays => _days.length;
  num get _guidePricePerDay => (_selectedGuide?.price ?? 0);
  num get _totalPrice => _guidePricePerDay * _numDays;
  bool get _hasGuide => _selectedGuide != null;

  List<int> _emptyDayIndexes(TripPlanDetailModel d) {
    DateTime _asYmd(DateTime x) => DateTime(x.year, x.month, x.day);
    final empty = <int>[];
    for (int i = 0; i < _days.length; i++) {
      final day = _days[i];
      final idx = d.days.indexWhere((it) => _asYmd(it.date) == _asYmd(day));
      final hasAct = idx != -1 && d.days[idx].activities.isNotEmpty;
      if (!hasAct) empty.add(i + 1);
    }
    return empty;
  }

  @override
  void initState() {
    _pickupNameController = TextEditingController();
    _pickupPointController = TextEditingController();

    super.initState();
    _nameController = TextEditingController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsProcessed) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    TripPlanDetailModel? detail;
    String? tripId;

    if (args is TripPlanDetailModel) {
      detail = args;
      _initialImageUrl = (detail.imageUrl?.trim().isNotEmpty ?? false)
          ? detail.imageUrl!.trim()
          : _initialImageUrl;
    } else if (args is String) {
      tripId = args;
    } else if (args is Map) {
      if (args['detail'] is TripPlanDetailModel) {
        detail = args['detail'] as TripPlanDetailModel;
      } else if (args['tripPlanDetail'] is TripPlanDetailModel) {
        detail = args['tripPlanDetail'] as TripPlanDetailModel;
      }
      final rawTripId = args['tripId'] ?? args['tripPlanId'];
      if (rawTripId != null) tripId = rawTripId.toString();

      final argImg = (args['imageUrl'] as String?)?.trim();
      if (argImg != null &&
          argImg.isNotEmpty &&
          argImg.toLowerCase() != 'string') {
        _initialImageUrl = argImg;
      }
    }

    if (detail != null) {
      _detail = detail;
      _nameController.text = _detail!.name;
      _setCtl(_pickupNameController, _detail!.pickupName ?? '');
      _setCtl(_pickupPointController, _detail!.pickupAddress ?? '');
      _rebuildDaysFromDetail(_detail!);
    } else if (tripId != null) {
      _tripId = tripId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TripPlanBloc>().add(GetTripPlanDetailEvent(_tripId!));
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Thiếu dữ liệu: cần tripId hoặc detail')),
        );
      });
    }

    _argsProcessed = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    _pickupNameController.dispose();
    _pickupPointController.dispose();
    super.dispose();
  }

  void _handleEditDateRange() async {
    if (_detail == null) return;
    final now = DateTime.now();

    final oldStart = _ymd(_detail!.startDate);
    final oldEnd = _ymd(_detail!.endDate);

    final first = _ymd(oldStart.isBefore(now) ? oldStart : now);
    final last = DateTime(
      (now.year + 2 > oldEnd.year) ? now.year + 2 : oldEnd.year,
      12,
      31,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: last,
      initialDateRange: DateTimeRange(start: oldStart, end: oldEnd),
      locale: const Locale('vi', 'VN'),
    );
    if (picked == null) return;

    final newStart = _ymd(picked.start);
    final newEnd = _ymd(picked.end);

    final isShortenedStart = newStart.isAfter(oldStart);
    final isExtendedStart = newStart.isBefore(oldStart);
    final isShortenedEnd = newEnd.isBefore(oldEnd);
    final isExtendedEnd = newEnd.isAfter(oldEnd);

    if (isExtendedStart && _isTomorrow(newStart)) {
      _showTomorrowError(newStart);
      return;
    }
    if (isExtendedEnd && _isTomorrow(newEnd)) {
      _showTomorrowError(newEnd);
      return;
    }

    if (isShortenedStart || isShortenedEnd) {
      final ok = await _confirmShortenAndDelete(newStart, newEnd);
      if (!ok) return;

      final filteredPayload =
          _mapLocationsWithinRange(_detail!, newStart, newEnd);
      _pendingShortenStart = newStart;
      _pendingShortenEnd = newEnd;

      context.read<TripPlanBloc>().add(UpdateTripPlanLocationsEvent(
            tripPlanId: _detail!.id,
            locations: filteredPayload,
          ));
      return;
    }

    if (isExtendedStart || isExtendedEnd) {
      context.read<TripPlanBloc>().add(UpdateTripPlanEvent(
            id: _detail!.id,
            name: _detail!.name,
            description: _detail!.description,
            startDate: isExtendedStart ? newStart : oldStart,
            endDate: isExtendedEnd ? newEnd : oldEnd,
            imageUrl: _detail!.imageUrl ?? _initialImageUrl,
          ));
      return;
    }
  }

  Future<void> _openEditNameSheetPro() async {
    if (_detail == null) return;
    final c = TextEditingController(text: _detail!.name);
    final newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Đổi tên hành trình',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: c,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Tên hành trình mới',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(c.text.trim()),
                  child: const Text('Lưu'),
                ),
              )
            ],
          ),
        );
      },
    );
    if (newName == null || newName.isEmpty || newName == _detail!.name) return;

    context.read<TripPlanBloc>().add(UpdateTripPlanEvent(
          id: _detail!.id,
          name: newName,
          description: _detail!.description,
          startDate: _detail!.startDate,
          endDate: _detail!.endDate,
          imageUrl: _detail!.imageUrl ?? _initialImageUrl,
        ));
  }

  List<TripPlanLocationModel> _mapAllActivitiesToLocations(
      TripPlanDetailModel d) {
    final result = <TripPlanLocationModel>[];
    int runningOrder = 1;

    for (final day in d.days) {
      final acts = [...day.activities]
        ..sort((a, b) => a.order.compareTo(b.order));
      for (final act in acts) {
        result.add(
          TripPlanLocationModel(
            tripPlanLocationId: (act.tripPlanLocationId?.isNotEmpty ?? false)
                ? act.tripPlanLocationId
                : null,
            locationId: act.locationId,
            order: runningOrder++,
            startTime: act.startTime,
            endTime: act.endTime,
            notes: act.notes,
            travelTimeFromPrev: 0,
            distanceFromPrev: 0,
            estimatedStartTime: act.startTime.millisecondsSinceEpoch ~/ 1000,
            estimatedEndTime: act.endTime.millisecondsSinceEpoch ~/ 1000,
          ),
        );
      }
    }
    return result;
  }

  Future<bool> _confirmShortenAndDelete(
      DateTime newStart, DateTime newEnd) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Thay hành trình'),
            content: const Text(
                'Bạn đang thay đổi phạm vi ngày. Mọi hoạt động nằm ngoài khoảng ngày mới sẽ bị xoá vĩnh viễn. '
                'Bạn có chắc muốn tiếp tục không?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Hủy')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Tiếp tục')),
            ],
          ),
        ) ??
        false;
  }

  void _putAllLocationsNow() {
    final d = _detail;
    if (d == null) return;
    final payload = _mapAllActivitiesToLocations(d);
    context.read<TripPlanBloc>().add(
          UpdateTripPlanLocationsEvent(
            tripPlanId: d.id,
            locations: payload,
          ),
        );
  }

  void _handleSubmitPlan() async {
    final d = _detail;
    if (d == null) return;

    if (_hasGuide) {
      final empties = _emptyDayIndexes(d);
      if (empties.isNotEmpty) {
        final msg = 'Các ngày chưa có hoạt động: '
            '${empties.map((e) => 'Ngày $e').join(', ')}.\n'
            'Vui lòng thêm hoạt động cho tất cả các ngày trước khi đặt hướng dẫn viên.';

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Thiếu hoạt động'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK')),
            ],
          ),
        );
        return;
      }
      final ok = await _confirmFinalizeIfHasGuide();
      if (!ok) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GuideTeamSelectorScreen(
            guide: _selectedGuide!,
            startDate: d.startDate,
            endDate: d.endDate,
            unitPrice: _selectedGuide!.price ?? 0,
            tripPlanId: d.id,
          ),
        ),
      );
      return;
    }

    final payload = _mapAllActivitiesToLocations(d);
    if (payload.isNotEmpty) {
      context.read<TripPlanBloc>().add(
            UpdateTripPlanLocationsEvent(tripPlanId: d.id, locations: payload),
          );
    }
    _leavingScreen = true;
    Navigator.pushNamedAndRemoveUntil(
      context,
      MyTripPlansScreen.routeName,
      (route) => false,
    );
    AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
  }

  Future<void> _openPickupDialog() async {
    final tmpName = TextEditingController(text: _pickupNameController.text);
    final tmpAddr = TextEditingController(text: _pickupPointController.text);

    String? err;

    bool isValidTN(String s) => VietmapSearchService.isInTayNinh(s.trim());

    final ok = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: StatefulBuilder(
                builder: (ctx, setModal) {
                  final validNow = isValidTN(tmpAddr.text);

                  Widget quickChip(String label, VoidCallback onTap) {
                    return ActionChip(
                      label: Text(label),
                      onPressed: onTap,
                      backgroundColor: const Color(0xFFF1F7FF),
                      shape: StadiumBorder(
                          side: BorderSide(color: Colors.blue.shade100)),
                      elevation: 0,
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        decoration: const BoxDecoration(
                          gradient: Gradients.defaultGradientBackground,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.local_taxi_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Điểm đón',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F2FF),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFD6E7FF)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.info_outline_rounded,
                                      color: Color(0xFF2E7CF6), size: 18),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Giúp chúng tôi tìm đến bạn nhanh và chính xác hơn!',
                                      style:
                                          TextStyle(fontSize: 13, height: 1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // // Quick suggestions for "Tên điểm đón"
                            // Wrap(
                            //   spacing: 8,
                            //   runSpacing: 8,
                            //   children: [
                            //     quickChip('Khách sạn …', () {
                            //       setModal(() {
                            //         tmpName.text = 'Khách sạn …';
                            //         tmpName.selection = TextSelection.fromPosition(
                            //             TextPosition(offset: tmpName.text.length));
                            //       });
                            //     }),
                            //     quickChip('Nhà riêng', () {
                            //       setModal(() {
                            //         tmpName.text = 'Nhà riêng';
                            //         tmpName.selection = TextSelection.fromPosition(
                            //             TextPosition(offset: tmpName.text.length));
                            //       });
                            //     }),
                            //     quickChip('Bến xe Tây Ninh', () {
                            //       setModal(() {
                            //         tmpName.text = 'Bến xe Tây Ninh';
                            //         tmpName.selection = TextSelection.fromPosition(
                            //             TextPosition(offset: tmpName.text.length));
                            //       });
                            //     }),
                            //   ],
                            // ),
                            // const SizedBox(height: 10),

                            // Field: Tên điểm đón (optional)
                            TextField(
                              controller: tmpName,
                              decoration: _dialogDeco(
                                'Tên điểm đón (tùy chọn)',
                                'VD: Khách sạn Victory – Phòng 1204',
                                icon: Icons.person_pin_circle_rounded,
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),

                            AddressAutocompleteField(
                              controller: tmpAddr,
                              labelText: 'Địa chỉ (bắt buộc)',
                              hintText:
                                  'VD: 81 Hoàng Lê Kha, P.3, TP. Tây Ninh',
                              validator: (s) =>
                                  VietmapSearchService.isInTayNinh(s),
                              onSelected: (_) {
                                setModal(() => err = null);

                                // VietmapSearchService.geocodeOnce(_).then((geo) { ... });
                              },
                            ),

                            if (err != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                err!,
                                style: const TextStyle(
                                    color: Colors.redAccent, fontSize: 12.5),
                              ),
                            ],

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  validNow ? Icons.check_circle : Icons.cancel,
                                  size: 16,
                                  color: validNow
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  validNow
                                      ? 'Địa chỉ hợp lệ'
                                      : 'Yêu cầu nhập địa chỉ hợp lệ',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: validNow
                                        ? Colors.green[700]
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          height: 1, color: ColorPalette.dividerColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColorPalette.primaryColor,
                                  side: const BorderSide(
                                      color: ColorPalette.primaryColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: const Text('Huỷ'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final addr = tmpAddr.text.trim();
                                  if (addr.isEmpty) {
                                    setModal(
                                        () => err = 'Vui lòng nhập Địa chỉ');
                                    return;
                                  }
                                  // if (!isValidTN(addr)) {
                                  //   setModal(() => err = 'Địa chỉ phải thuộc Tây Ninh');
                                  //   return;
                                  // }
                                  Navigator.pop(ctx, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: const BoxDecoration(
                                    gradient:
                                        Gradients.defaultGradientBackground,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.check_rounded,
                                            color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text('Lưu',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ) ??
        false;

    if (!ok) return;

    final name = tmpName.text.trim();
    final addr = tmpAddr.text.trim();

    _isSyncingControllers = true;
    _setCtl(_pickupNameController, name);
    _setCtl(_pickupPointController, addr);
    _isSyncingControllers = false;

    if (_detail != null) {
      setState(() {
        _detail = _detail!.copyWith(
          pickupName: name.isNotEmpty ? name : null,
          pickupAddress: addr,
        );
      });
    }
  }

  Widget _buildGuideTile() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        if (_detail == null) return;

        final hasActivity =
            _detail!.days.any((day) => day.activities.isNotEmpty);

        if (!hasActivity) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Bạn cần thêm ít nhất một địa điểm trước khi chọn hướng dẫn viên.'),
            ),
          );
          return;
        }

        final guide = await Navigator.pushNamed(
          context,
          '/select-tour-guide',
          arguments: _detail,
        ) as TourGuideModel?;

        if (guide != null) {
          setState(() {
            _selectedGuide = guide;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: _tileBox,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.sp,
              backgroundImage: (_selectedGuide?.avatarUrl != null &&
                      _selectedGuide!.avatarUrl!.isNotEmpty)
                  ? NetworkImage(_selectedGuide!.avatarUrl!)
                  : AssetImage(AssetHelper.avatar) as ImageProvider,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hướng dẫn viên',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    _selectedGuide?.userName ?? 'Chưa chọn hướng dẫn viên',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: _selectedGuide == null
                          ? FontWeight.w500
                          : FontWeight.w700,
                      color: _selectedGuide == null
                          ? Colors.black54
                          : Colors.blue.shade900,
                    ),
                  ),
                  if (_selectedGuide?.price != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${_money(_guidePricePerDay)}/ngày · $_numDays ngày',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupTile() {
    final hasAddr = (_pickupPointController.text.trim().isNotEmpty) ||
        ((_detail?.pickupAddress ?? '').trim().isNotEmpty);

    final name = _pickupNameController.text.trim().isNotEmpty
        ? _pickupNameController.text.trim()
        : (_detail?.pickupName ?? '');
    final addr = hasAddr
        ? (_pickupPointController.text.trim().isNotEmpty
            ? _pickupPointController.text.trim()
            : (_detail?.pickupAddress ?? ''))
        : '';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _openPickupDialog,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: _tileBox,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: Gradients.defaultGradientBackground,
              ),
              child: const Icon(Icons.local_taxi_rounded, color: Colors.white),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Điểm đón',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  if (!hasAddr) ...[
                    const Text('Chưa chọn điểm đón',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 2),
                    const Text(
                        'Nhấn để nhập: Tên điểm đón (tùy chọn) & Địa chỉ (bắt buộc)',
                        style: TextStyle(fontSize: 12, color: Colors.black45)),
                  ] else ...[
                    if (name.isNotEmpty)
                      Text('Tên: $name',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('Địa chỉ: $addr',
                        style: const TextStyle(fontSize: 13)),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child:
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _clampIndex(int index, int max) {
      if (max < 0) return 0;
      if (index < 0) return 0;
      if (index > max) return max;
      return index;
    }

    return BlocConsumer<TripPlanBloc, TripPlanState>(
      listener: (context, state) {
        if (!mounted || _leavingScreen) return;

        final isScreenOpLoading = state is GetTripPlanDetailLoading ||
            state is UpdateTripPlanLoading ||
            state is UpdateTripPlanLocationsLoading;

        if (isScreenOpLoading) {
          _showLoading();
        } else {
          _hideLoading();
        }

        if (state is GetTripPlanDetailSuccess) {
          final prevIndex = _selectedTabIndex;

          var det = state.tripPlanDetail;
          final missingServerImg =
              det.imageUrl == null || det.imageUrl!.isEmpty;
          final hasArgImg =
              _initialImageUrl != null && _initialImageUrl!.isNotEmpty;
          if (missingServerImg && hasArgImg) {
            det = TripPlanDetailModel(
              id: det.id,
              name: det.name,
              description: det.description,
              startDate: det.startDate,
              endDate: det.endDate,
              totalDays: det.totalDays,
              status: det.status,
              statusText: det.statusText,
              days: det.days,
              imageUrl: _initialImageUrl,
              pickupName: det.pickupName,
              pickupAddress: det.pickupAddress,
            );
          }

          setState(() {
            _detail = det;
            _nameController.text = _detail!.name;
            _setCtl(_pickupNameController, _detail!.pickupName ?? '');
            _setCtl(_pickupPointController, _detail!.pickupAddress ?? '');
            _rebuildDaysFromDetail(_detail!);
            _selectedTabIndex =
                _days.isNotEmpty ? prevIndex.clamp(0, _days.length - 1) : 0;
          });
        } else if (state is UpdateTripPlanLocationsSuccess) {
          final hasPendingShorten =
              (_pendingShortenStart != null) || (_pendingShortenEnd != null);
          if (hasPendingShorten && _detail != null) {
            final newStart = _pendingShortenStart ?? _detail!.startDate;
            final newEnd = _pendingShortenEnd ?? _detail!.endDate;
            _pendingShortenStart = null;
            _pendingShortenEnd = null;

            context.read<TripPlanBloc>().add(UpdateTripPlanEvent(
                  id: _detail!.id,
                  name: _detail!.name,
                  description: _detail!.description,
                  startDate: newStart,
                  endDate: newEnd,
                  imageUrl: _detail!.imageUrl ?? _initialImageUrl,
                ));
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu danh sách hoạt động')),
          );
          final id = _detail?.id;
          if (id != null) {
            context.read<TripPlanBloc>().add(GetTripPlanDetailEvent(id));
          }
        } else if (state is UpdateTripPlanSuccess) {
          final adding = _pendingAddAtStart != null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              adding
                  ? 'Đã thêm 1 ngày ở ${_pendingAddAtStart! ? "đầu" : "cuối"} hành trình'
                  : 'Đã cập nhật ngày hành trình',
            )),
          );

          final id = state.tripPlanDetail.id.isNotEmpty
              ? state.tripPlanDetail.id
              : _detail?.id;
          if (id != null) {
            context.read<TripPlanBloc>().add(GetTripPlanDetailEvent(id));
          }
        } else if (state is GetTripPlanDetailError ||
            state is UpdateTripPlanError ||
            state is UpdateTripPlanLocationsError) {
          _pendingShortenStart = null;
          _pendingShortenEnd = null;
          final msg = (state as dynamic).message;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        if (_detail == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF1F7FF),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF1F7FF),
          body: _buildBody(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final d = _detail!;
    return Column(
      children: [
        TripHeader(
          title: d.name,
          isEditingName: false,
          nameController: _nameController,
          onEditTap: _openEditNameSheetPro,
          coverImage: (d.imageUrl != null && d.imageUrl!.isNotEmpty)
              ? d.imageUrl
              : _initialImageUrl,
        ),
        Padding(
          padding:
              EdgeInsets.only(top: 1.5.h, left: 4.w, right: 4.w, bottom: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _leavingScreen = true;
                  _hideLoading();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MyTripPlansScreen.routeName,
                    (route) => false,
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppBloc.tripPlanBloc.add(const GetTripPlansEvent());
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios,
                        size: 13.sp, color: Colors.black54),
                    Text("Quay lại", style: TextStyle(fontSize: 13.5.sp)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _handleEditDateRange,
                child: Row(
                  children: [
                    Icon(Icons.edit_calendar,
                        size: 14.sp, color: Colors.blueAccent),
                    SizedBox(width: 1.w),
                    Text("Sửa ngày",
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.blueAccent)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              _buildGuideTile(),
              SizedBox(height: 1.2.h),
              _buildPickupTile(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.black54, size: 13.sp),
              SizedBox(width: 2.w),
              Text(
                _days.isNotEmpty
                    ? '${DateFormat('dd/MM').format(_days.first)} ➔ ${DateFormat('dd/MM').format(_days.last)}'
                    : 'Không có ngày',
                style: TextStyle(color: Colors.black87, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              _AddDayButton(
                tooltip: 'Thêm 1 ngày ở ĐẦU',
                onTap: () => _onAddDay(atStart: true),
              ),
              const SizedBox(width: 8),
              ...List.generate(_days.length, (index) {
                final allowDelete = index == 0 || index == _days.length - 1;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      TripTabButton(
                        isSelected: index == _selectedTabIndex,
                        label: 'Ngày ${index + 1}',
                        onTap: () => setState(() => _selectedTabIndex = index),
                      ),
                      if (allowDelete)
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Tooltip(
                            message: 'Xoá ngày này',
                            child:
                                _CornerClose(onTap: () => _onDeleteDay(index)),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(width: 8),
              _AddDayButton(
                tooltip: 'Thêm 1 ngày ở CUỐI',
                onTap: () => _onAddDay(atStart: false),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: TripDayCard(
                      day: _days[_selectedTabIndex],
                      detail: d,
                      onUpdateActivities: (updated) {
                        DateTime _asLocalYmd(DateTime d) => DateTime(
                            d.toLocal().year,
                            d.toLocal().month,
                            d.toLocal().day);

                        final targetDay = _asLocalYmd(_days[_selectedTabIndex]);
                        final idx = d.days.indexWhere(
                            (it) => _asLocalYmd(it.date) == targetDay);

                        if (idx == -1) return;

                        final old = d.days[idx];
                        setState(() {
                          d.days[idx] = TripDayModel(
                            dayNumber: old.dayNumber,
                            date: old.date,
                            dateFormatted: old.dateFormatted,
                            activities: List<TripActivityModel>.from(updated),
                          );
                        });
                      },
                      onUpdateLocations: (_) {
                        _putAllLocationsNow();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h, top: 1.h),
                child: Column(
                  children: [
                    Text(
                      "✨ Mỗi ngày là một cuộc phiêu lưu mới!",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.5.h),
                    GestureDetector(
                      onTap: _handleSubmitPlan,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.4.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                          ),
                          borderRadius: BorderRadius.circular(6.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.white, size: 16.sp),
                            SizedBox(width: 2.w),
                            Text(
                              'Hoàn tất kế hoạch',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, int>?> _selectGuestCounts() async {
    int adults = 1;
    int children = 0;

    return await showModalBottomSheet<Map<String, int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Chọn số lượng khách',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Người lớn', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (adults > 1) {
                                setModalState(() => adults--);
                              }
                            },
                          ),
                          Text('$adults', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setModalState(() => adults++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Trẻ em', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (children > 0) {
                                setModalState(() => children--);
                              }
                            },
                          ),
                          Text('$children',
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setModalState(() => children++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop({
                          'adults': adults,
                          'children': children,
                        });
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _confirmFinalizeIfHasGuide() async {
    if (!_hasGuide) return true;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text('Xác nhận hoàn tất'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bạn đã chọn hướng dẫn viên ${_selectedGuide?.userName ?? ''}. '
                    'Khi hoàn tất, hệ thống sẽ tiến hành thanh toán và bạn sẽ không thể chỉnh sửa kế hoạch nữa.',
                    style: const TextStyle(height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tổng dự kiến: ${_money(_totalPrice)} '
                          '(${_money(_guidePricePerDay)}/ngày × $_numDays ngày)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Hủy'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Xác nhận & thanh toán'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class _CornerClose extends StatelessWidget {
  final VoidCallback onTap;
  const _CornerClose({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class _AddDayButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? tooltip;
  const _AddDayButton({required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 28,
          height: 28,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            gradient: Gradients.defaultGradientBackground,
          ),
          child: const Center(
            child: Icon(Icons.add_rounded, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

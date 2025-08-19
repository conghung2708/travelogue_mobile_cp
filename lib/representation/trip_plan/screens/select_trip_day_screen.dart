import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';

import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_day_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_booking_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';

import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_day_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_tab_button.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_header.dart';

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

  int _selectedTabIndex = 0;
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  TourGuideModel? _selectedGuide;
  bool _argsProcessed = false;
  String? _tripId;

  // giữ pending ngày mới sau khi đã PUT locations khi rút ngắn
  DateTime? _pendingShortenStart;
  DateTime? _pendingShortenEnd;

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
    }

    if (detail != null) {
      _detail = detail;
      _nameController.text = _detail!.name;
      _rebuildDaysFromDetail(_detail!);
      debugPrint('[SelectTripDay] Got detail via arguments: ${_detail!.id}');
    } else if (tripId != null) {
      _tripId = tripId;
      debugPrint('[SelectTripDay] Fetching detail by tripId=$_tripId');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TripPlanBloc>().add(GetTripPlanDetailEvent(_tripId!));
        }
      });
    } else {
      debugPrint('[SelectTripDay][WARN] No arguments provided.');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiếu dữ liệu: cần tripId hoặc detail')),
        );
      });
    }

    _argsProcessed = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleEditDateRange() async {
    if (_detail == null) return;
    final now = DateTime.now();

    final oldStart = _ymd(_detail!.startDate);
    final oldEnd = _ymd(_detail!.endDate);

    // Cho phép chọn sớm hơn ngày hiện tại của trip, nhưng không trước "today".
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

    // Nếu có bất kỳ rút ngắn nào (đầu hoặc cuối), cần lọc & PUT lại locations.
    if (isShortenedStart || isShortenedEnd) {
      final ok = await _confirmShortenAndDelete(newStart, newEnd);
      if (!ok) return;

      final filteredPayload =
          _mapLocationsWithinRange(_detail!, newStart, newEnd);

      // Luôn lưu cả 2 đầu mốc mới để hợp nhất chính xác sau khi PUT locations xong
      _pendingShortenStart = newStart;
      _pendingShortenEnd = newEnd;

      context.read<TripPlanBloc>().add(UpdateTripPlanLocationsEvent(
            tripPlanId: _detail!.id,
            locations: filteredPayload,
          ));
      return;
    }

    // Chỉ mở rộng (không rút ngắn): cập nhật trip trực tiếp
    if (isExtendedStart || isExtendedEnd) {
      context.read<TripPlanBloc>().add(UpdateTripPlanEvent(
            id: _detail!.id,
            name: _detail!.name,
            description: _detail!.description,
            startDate: isExtendedStart ? newStart : oldStart,
            endDate: isExtendedEnd ? newEnd : oldEnd,
            imageUrl: _detail!.imageUrl,
          ));
      return;
    }

    // Không thay đổi gì
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
          imageUrl: _detail!.imageUrl,
        ));
  }

  List<TripPlanLocationModel> _mapAllActivitiesToLocations(
      TripPlanDetailModel d) {
    final result = <TripPlanLocationModel>[];
    int runningOrder = 1;

    for (final day in d.days) {
      final acts = [...day.activities]..sort((a, b) => a.order.compareTo(b.order));
      for (final act in acts) {
        print('Mapping activity: ${act.name} (tplId=${act.tripPlanLocationId})');
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
    print('FULL payload count: ${result.length}');
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
    print('[PUT] sending ${payload.length} locations to BE');
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

      final guestCounts = await _selectGuestCounts();
      if (guestCounts == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GuideBookingConfirmationScreen(
            tripPlanId: d.id,
            guide: _selectedGuide!,
            startDate: d.startDate,
            endDate: d.endDate,
            adults: guestCounts['adults']!,
            children: guestCounts['children']!,
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
        if (!_leavingScreen) {
          if (state is TripPlanLoading) {
            _showLoading();
          } else {
            _hideLoading();
          }
        }
        if (_leavingScreen) return;

        if (state is GetTripPlanDetailSuccess) {
          final prevIndex = _selectedTabIndex;
          if (!mounted) return;
          setState(() {
            _detail = state.tripPlanDetail;
            _nameController.text = _detail!.name;
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
                  imageUrl: _detail!.imageUrl,
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật ngày hành trình')),
          );
          final id = (state.tripPlanDetail.id.isNotEmpty)
              ? state.tripPlanDetail.id
              : _detail?.id;
          if (id != null) {
            context.read<TripPlanBloc>().add(GetTripPlanDetailEvent(id));
          }
        } else if (state is TripPlanError ||
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
          child: GestureDetector(
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
                margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
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
                          Text(
                            _selectedGuide?.userName ??
                                'Chưa chọn hướng dẫn viên',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          if (_selectedGuide?.price != null)
                            Row(
                              children: [
                                Icon(Icons.attach_money,
                                    size: 13.sp, color: Colors.green),
                                SizedBox(width: 1.w),
                                Text(
                                  '${_money(_guidePricePerDay)}/ngày · $_numDays ngày',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (_hasGuide)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: .6.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.green.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.payments_outlined,
                                size: 16, color: Colors.green[800]),
                            SizedBox(width: 1.w),
                            Text(
                              _money(_totalPrice),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedGuide != null)
                      IconButton(
                        onPressed: () => setState(() => _selectedGuide = null),
                        icon: Icon(Icons.cancel,
                            color: Colors.redAccent, size: 18.sp),
                        tooltip: 'Bỏ chọn',
                      ),
                    Icon(Icons.arrow_forward_ios,
                        size: 14.sp, color: Colors.grey),
                  ],
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
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
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: List.generate(
              _days.length,
              (index) => TripTabButton(
                isSelected: index == _selectedTabIndex,
                label: 'Ngày ${index + 1}',
                onTap: () => setState(() => _selectedTabIndex = index),
              ),
            ),
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
                        DateTime _asLocalYmd(DateTime d) =>
                            DateTime(d.toLocal().year, d.toLocal().month, d.toLocal().day);

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

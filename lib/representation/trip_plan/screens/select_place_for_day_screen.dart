import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/services/vietmap_route_service.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/utils/time_utils.dart';

import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';
import 'package:travelogue_mobile/model/trip_plan/itinerary_stop.dart';

import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/filter_chips_bar.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/place_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/route_dialogs.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/selected_list_sheet.dart';

class _VisitAdjust {
  final DateTime arrival;
  final int stayMinutes;
  const _VisitAdjust(this.arrival, this.stayMinutes);
}

class SelectPlaceForDayScreen extends StatefulWidget {
  static const routeName = '/select-place-for-day';
  const SelectPlaceForDayScreen({super.key});

  @override
  State<SelectPlaceForDayScreen> createState() =>
      _SelectPlaceForDayScreenState();
}

class _SelectPlaceForDayScreenState extends State<SelectPlaceForDayScreen> {
  static const _kBlue = Color(0xFF1565C0);
  static const _kBlueLight = Color(0xFFE3F2FD);
  static const _kBlueLight2 = Color(0xFFEEF6FF);

  bool _forceFoodMode = false;
  bool _autoInsertAfterPick = false;
  TimeOfDay? _lunchAt;
  int _lunchStayMinutes = 90;
  int? _dayNumber;
  String? _dayLabel;
  bool _foodOnly = false;

  ButtonStyle get _tonalBlueButton => ElevatedButton.styleFrom(
        backgroundColor: _kBlueLight,
        foregroundColor: _kBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );

  Widget _dialogAction(String label,
      {required VoidCallback onPressed, bool isPrimary = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _tonalBlueButton.copyWith(
        backgroundColor:
            WidgetStatePropertyAll(isPrimary ? _kBlue : _kBlueLight),
        foregroundColor:
            WidgetStatePropertyAll(isPrimary ? Colors.white : _kBlue),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Theme _wrapDialog(Widget child) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: _kBlue),
          contentTextStyle:
              TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
        ),
      ),
      child: child,
    );
  }

  Future<bool> _showConfirmDialog(
      {required String title, required Widget content}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => _wrapDialog(
        AlertDialog(
          title: const Row(children: [
            Icon(Icons.info_outline, color: _kBlue),
            SizedBox(width: 8),
            Expanded(child: Text(''))
          ]),
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kBlue)),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: _kBlueLight2,
                    borderRadius: BorderRadius.circular(12)),
                child:
                    Padding(padding: const EdgeInsets.all(12), child: content),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            _dialogAction('Hủy', onPressed: () => Navigator.pop(ctx, false)),
            _dialogAction('Tiếp tục',
                isPrimary: true, onPressed: () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    );
    return ok == true;
  }

  Future<bool> _showInputDialog({
    required String title,
    required Widget input,
    String cancelText = 'Hủy',
    String okText = 'Lưu',
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => _wrapDialog(
        AlertDialog(
          title: const Row(children: [
            Icon(Icons.tune, color: _kBlue),
            SizedBox(width: 8),
            Text('Thiết lập')
          ]),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: _kBlue)),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: _kBlueLight2,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(padding: const EdgeInsets.all(12), child: input),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            _dialogAction(cancelText,
                onPressed: () => Navigator.pop(ctx, false)),
            _dialogAction(okText,
                isPrimary: true, onPressed: () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    );
    return ok == true;
  }

  final ValueNotifier<int> selectedFilterIndex = ValueNotifier<int>(0);

  final List<TripActivityModel> _selectedActivities = [];
  final Set<String> _selectedIds = <String>{};
  final Set<String> _blockedLocationIds = <String>{};

  bool _didHydrateCoords = false;
  static const TimeOfDay kLunchStart = TimeOfDay(hour: 11, minute: 0);
  static const TimeOfDay kLunchEnd = TimeOfDay(hour: 14, minute: 0);

  final List<ItineraryStop> _itinerary = [];
  List<LocationModel> _allLocations = [];
  bool _didInit = false;

  LocationModel? _anchorPlace;
  final Map<String, double> _roadKmCache = {};
  double _maxDistanceKm = 20.0;

  static const int minHour = 6;
  static const int maxHour = 23;

  bool _userPickedStart = false;

  late TimeOfDay _dayStart;
  late DateTime _dayDate;

  late final VietmapRouteService _vietmap = VietmapRouteService(
    apiKey: '840f8a8247cb32578fc81fec50af42b8ede321173a31804b',
  );

  Future<void> _recomputeLinkAndTimesAfterRemove(int removedIdx) async {
    final currIdx = removedIdx;
    final prevIdx = removedIdx - 1;

    if (currIdx >= _itinerary.length) {
      _recalcTimesForSelected(startFromIndex: prevIdx + 1);
      return;
    }

    int travelMeters = 0;
    int travelSeconds = 0;

    if (prevIdx >= 0) {
      final from = _itinerary[prevIdx].place;
      final to = _itinerary[currIdx].place;
      final fromLat = from.safeLat, fromLng = from.safeLng;
      final toLat = to.safeLat, toLng = to.safeLng;

      if (fromLat != null &&
          fromLng != null &&
          toLat != null &&
          toLng != null) {
        try {
          final route = await _vietmap.routeMotorcycle(
            fromLat: fromLat,
            fromLng: fromLng,
            toLat: toLat,
            toLng: toLng,
          );
          travelMeters = route.distanceMeters;
          travelSeconds = route.durationSeconds;
        } catch (e) {
          debugPrint('[RECOMPUTE][WARN] Lỗi khi tính route A→C: $e');
        }
      }
    }

    final oldC = _itinerary[currIdx];
    final fromDepart = (prevIdx >= 0)
        ? _itinerary[prevIdx].depart
        : TimeUtils.combine(_dayDate, _dayStart);
    final newArrival = fromDepart.add(Duration(seconds: travelSeconds));
    final newDepart = newArrival.add(Duration(minutes: oldC.stayMinutes));

    _itinerary[currIdx] = ItineraryStop(
      place: oldC.place,
      arrival: newArrival,
      depart: newDepart,
      stayMinutes: oldC.stayMinutes,
      travelMeters: travelMeters,
      travelSeconds: travelSeconds,
    );

    _selectedActivities[currIdx] = _selectedActivities[currIdx].copyWith(
      startTime: newArrival,
      endTime: newDepart,
      startTimeFormatted: DateFormat('HH:mm').format(newArrival),
      endTimeFormatted: DateFormat('HH:mm').format(newDepart),
      duration: '${oldC.stayMinutes} phút',
      order: currIdx + 1,
    );

    _recalcTimesForSelected(startFromIndex: currIdx + 1);
  }

  void _hydrateSelectedFromCatalog() {
    if (_didHydrateCoords) return;
    if (_allLocations.isEmpty || _itinerary.isEmpty) return;

    for (int i = 0; i < _itinerary.length; i++) {
      final stop = _itinerary[i];
      final pid = stop.place.id ?? '';
      if (pid.isEmpty) continue;

      final found = _allLocations.firstWhere(
        (l) => (l.id ?? '') == pid,
        orElse: () => LocationModel(id: null),
      );
      if (found.id != null) {
        _itinerary[i] = ItineraryStop(
          place: found,
          arrival: stop.arrival,
          depart: stop.depart,
          stayMinutes: stop.stayMinutes,
          travelMeters: stop.travelMeters,
          travelSeconds: stop.travelSeconds,
        );
      }
    }

    final lastId = _selectedActivities.last.locationId;
    final anchor = _allLocations.firstWhere(
      (l) => (l.id ?? '') == lastId,
      orElse: () => LocationModel(id: null),
    );
    if (anchor.id != null) {
      _anchorPlace = anchor;
    }

    _didHydrateCoords = true;
  }

  Future<void> _handleRemoveAt(int idx) async {
    final beforeFirstId =
        _itinerary.isNotEmpty ? _itinerary.first.place.id : null;

    final removedAct = _selectedActivities[idx];
    setState(() {
      _selectedActivities.removeAt(idx);
      _itinerary.removeAt(idx);
      _selectedIds.remove(removedAct.locationId);
    });

    await _recomputeLinkAndTimesAfterRemove(idx);

    final afterFirstId =
        _itinerary.isNotEmpty ? _itinerary.first.place.id : null;
    if (beforeFirstId != afterFirstId) {
      await _syncStartWithFirstStop();
    }

    if (_anchorPlace != null) _unawaited(_refreshMatrixFor(_allLocations));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final args =
        (ModalRoute.of(context)?.settings.arguments as Map?) ?? const {};

    final _ = args['detail'] as TripPlanDetailModel?;

    final dayArg = args['day'];
    if (dayArg is DateTime) {
      _dayDate = DateTime(dayArg.year, dayArg.month, dayArg.day);
    } else {
      final now = DateTime.now();
      _dayDate = DateTime(now.year, now.month, now.day);
    }

    _dayNumber = args['dayNumber'] as int?;
    _dayLabel = DateFormat('dd/MM/yyyy (EEEE)', 'vi').format(_dayDate);

    final startTimeArg = args['startTime'];
    _dayStart = startTimeArg is TimeOfDay
        ? startTimeArg
        : const TimeOfDay(hour: minHour, minute: 0);

    final initialSelected =
        (args['selected'] as List?)?.cast<TripActivityModel>() ?? const [];

    if (initialSelected.isNotEmpty) {
      final t0 = initialSelected.first.startTime;
      _dayStart = TimeOfDay(hour: t0.hour, minute: t0.minute);
    }

    _selectedActivities
      ..clear()
      ..addAll(initialSelected);
    _selectedIds
      ..clear()
      ..addAll(initialSelected.map((e) => e.locationId));

    if (_selectedActivities.isNotEmpty) {
      for (final a in _selectedActivities) {
        final loc = LocationModel(
          id: a.locationId,
          name: a.name,
          description: a.description,
          address: a.address,
        );
        _itinerary.add(
          ItineraryStop(
            place: loc,
            arrival: a.startTime,
            depart: a.endTime,
            stayMinutes: a.endTime.difference(a.startTime).inMinutes,
            travelMeters: 0,
            travelSeconds: 0,
          ),
        );
      }
    }

    final otherSelected =
        (args['allSelectedOtherDays'] as List?)?.cast<TripActivityModel>() ??
            const [];
    _blockedLocationIds
      ..clear()
      ..addAll(
          otherSelected.map((e) => e.locationId).where((e) => e.isNotEmpty));

    _forceFoodMode = args['forceFoodMode'] == true;
    _foodOnly = args['foodOnly'] == true;
    _autoInsertAfterPick = args['autoInsertAfterPick'] == true;
    _lunchAt = args['lunchAt'] is TimeOfDay
        ? args['lunchAt'] as TimeOfDay
        : const TimeOfDay(hour: 12, minute: 0);
    _lunchStayMinutes = (args['lunchStayMinutes'] is int)
        ? args['lunchStayMinutes'] as int
        : 90;

    if (_forceFoodMode) {
      selectedFilterIndex.value = 2; 
    }
    if (_foodOnly) {
      selectedFilterIndex.value = 2; 
    }
  }

  Widget _foodBanner() {
    if (!_forceFoodMode) return const SizedBox.shrink();
    final needFoodNow = _spansLunch && !_hasFoodSelected;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 0.5.h),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: needFoodNow
            ? const Color(0xFFFFF3E0)
            : (_hasFoodSelected ? const Color(0xFFE8F5E9) : _kBlueLight2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: needFoodNow
              ? const Color(0xFFEF6C00)
              : (_hasFoodSelected ? const Color(0xFF2E7D32) : _kBlue),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _hasFoodSelected
                ? Icons.check_circle
                : (needFoodNow ? Icons.error_outline : Icons.restaurant),
            color: _hasFoodSelected
                ? const Color(0xFF2E7D32)
                : (needFoodNow ? const Color(0xFFEF6C00) : _kBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _hasFoodSelected
                  ? 'Đã chọn điểm ăn uống cho ngày ${_dayNumber ?? ''} • ${_dayLabel ?? ''}'
                  : (needFoodNow
                      ? 'Lịch đi qua khung trưa — vui lòng chọn Ẩm thực cho ngày ${_dayNumber ?? ''} • ${_dayLabel ?? ''}'
                      : 'Bạn chưa chọn điểm ăn uống hôm nay. Bỏ qua Ẩm thực? Nhấn HOÀN TẤT để xác nhận.'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _hasFoodSelected
                    ? const Color(0xFF2E7D32)
                    : (needFoodNow ? const Color(0xFFEF6C00) : _kBlue),
              ),
            ),
          ),
          if (!_hasFoodSelected)
            TextButton(
                onPressed: () => selectedFilterIndex.value = 2,
                child: Text(needFoodNow ? 'Chọn ngay' : 'Tới Ẩm thực')),
        ],
      ),
    );
  }

  Future<void> _ensureLegRoutes() async {
    if (_itinerary.length <= 1) return;
    for (int i = 1; i < _itinerary.length; i++) {
      final prev = _itinerary[i - 1].place;
      final curr = _itinerary[i].place;
      final fLat = prev.safeLat, fLng = prev.safeLng;
      final tLat = curr.safeLat, tLng = curr.safeLng;
      if (fLat == null || fLng == null || tLat == null || tLng == null)
        continue;
      if (_itinerary[i].travelSeconds > 0 && _itinerary[i].travelMeters > 0)
        continue;

      try {
        final route = await _vietmap.routeMotorcycle(
            fromLat: fLat, fromLng: fLng, toLat: tLat, toLng: tLng);
        final old = _itinerary[i];
        _itinerary[i] = ItineraryStop(
          place: old.place,
          arrival: old.arrival,
          depart: old.depart,
          stayMinutes: old.stayMinutes,
          travelMeters: route.distanceMeters,
          travelSeconds: route.durationSeconds,
        );
      } catch (_) {}
    }
  }

  String? _openCloseText(LocationModel loc) {
    final open = _parseOpenTime(itemOpenTime: loc.openTime);
    final close = _parseCloseTime(itemCloseTime: loc.closeTime);
    if (open == null && close == null) return null;
    final parts = <String>[];
    if (open != null) parts.add('Mở: ${_fmtTOD(open)}');
    if (close != null) parts.add('Đóng: ${_fmtTOD(close)}');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc()..add(const GetAllLocationEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildIconOnlyAppBar(context),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            _allLocations = state is GetHomeSuccess ? state.locations : [];

            if (!_didHydrateCoords &&
                _allLocations.isNotEmpty &&
                _itinerary.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;
                setState(() {
                  _hydrateSelectedFromCatalog();
                });
                await _ensureLegRoutes();
                await _syncStartWithFirstStop(showPrompt: false);
                _recalcTimesForSelected();
                _unawaited(_refreshMatrixFor(_allLocations));
              });
            }

            if (_anchorPlace == null &&
                _selectedActivities.isNotEmpty &&
                _allLocations.isNotEmpty) {
              final lastAct = _selectedActivities.last;
              final found = _allLocations.firstWhere(
                (loc) => (loc.id ?? '') == lastAct.locationId,
                orElse: () => LocationModel(id: null),
              );
              if (found.id != null) _anchorPlace = found;
            }

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Text('Chọn',
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      Text('Địa điểm',
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          SizedBox(width: 2.w),
                          Text(
                              'Bắt đầu từ: ${TimeUtils.fmtTimeOfDay(_dayStart)}'),
                          TextButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                  context: context, initialTime: _dayStart);
                              if (picked == null) return;

                              if (picked.hour < minHour ||
                                  picked.hour > maxHour) {
                                _snack(
                                    'Chỉ cho phép từ $minHour:00 tới $maxHour:00');
                                return;
                              }

                              final oldStart = _dayStart;
                              setState(() {
                                _userPickedStart = true;
                                _dayStart = picked;
                              });

                              if (_itinerary.isNotEmpty) {
                                final first = _itinerary.first;
                                final firstStay = first.stayMinutes;
                                DateTime arrival0 =
                                    TimeUtils.combine(_dayDate, _dayStart);

                                final adjust = await _respectOpenClose(
                                    first.place, arrival0, firstStay);
                                if (adjust == null) {
                                  setState(() {
                                    _dayStart = oldStart;
                                  });
                                  return;
                                }

                                final newArr = adjust.arrival;
                                final newStay = adjust.stayMinutes;
                                final newDep =
                                    newArr.add(Duration(minutes: newStay));

                                _selectedActivities[0] =
                                    _selectedActivities[0].copyWith(
                                  startTime: newArr,
                                  endTime: newDep,
                                  startTimeFormatted:
                                      DateFormat('HH:mm').format(newArr),
                                  endTimeFormatted:
                                      DateFormat('HH:mm').format(newDep),
                                  duration: '$newStay phút',
                                );
                                _itinerary[0] = ItineraryStop(
                                  place: first.place,
                                  arrival: newArr,
                                  depart: newDep,
                                  stayMinutes: newStay,
                                  travelMeters: first.travelMeters,
                                  travelSeconds: first.travelSeconds,
                                );
                              }

                              _roadKmCache.clear();
                              _recalcTimesForSelected();
                            },
                            child: const Text('Đổi giờ'),
                          ),
                        ],
                      ),
                      _foodBanner(),
                      SizedBox(height: 0.5.h),
                      InkWell(
                        onTap: _showDistanceTip,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.4.h),
                          child: Row(
                            children: [
                              const Icon(Icons.motorcycle,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Chọn điểm trong bán kính ${_maxDistanceKm.toStringAsFixed(0)} km để dành nhiều thời gian khám phá hơn',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      if (!_foodOnly)
                        Center(
                            child: FilterChipsBar(
                                selectedIndexListenable: selectedFilterIndex)),
                      const TitleWithCustoneUnderline(
                          text: '📍Địa điểm ', text2: ' nổi bật'),
                      SizedBox(height: 2.h),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: selectedFilterIndex,
                          builder: (context, filterIndex, _) {
                            final appliedIndex = _foodOnly ? 2 : filterIndex;

                            final filtered =
                                _filterLocations(_allLocations, appliedIndex);

                            if (_anchorPlace != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _refreshMatrixFor(filtered);
                              });
                            }

                            return MasonryGridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2.h,
                              crossAxisSpacing: 4.w,
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final loc = filtered[index];
                                final id = loc.id ?? (loc.name ?? '$index');

                                final isSelectedHere = _selectedActivities
                                    .any((a) => a.locationId == id);
                                final order = isSelectedHere
                                    ? _selectedActivities.indexWhere(
                                            (a) => a.locationId == id) +
                                        1
                                    : 0;

                                final blocked =
                                    _blockedLocationIds.contains(id);

                                String? distanceText;
                                if (_anchorPlace != null) {
                                  final anchorId = (_anchorPlace!.id ??
                                          _anchorPlace!.name) ??
                                      '';
                                  final idForKey = (loc.id ?? loc.name) ?? '';
                                  if (anchorId != idForKey) {
                                    final key = _roadKey(_anchorPlace!.id,
                                        _anchorPlace!.name, loc.id, loc.name);
                                    final km = _roadKmCache[key];
                                    if (km != null) {
                                      distanceText =
                                          '${km.toStringAsFixed(1)} km';
                                    }
                                  }
                                }

                                final openClose = _openCloseText(loc);

                                return PlaceCard(
                                  imageUrl: loc.imgUrlFirst,
                                  name: loc.name ?? '',
                                  icon: _iconForCategory(
                                      _mapCategoryToType(loc.category)),
                                  overlayOrder: order,
                                  blocked: blocked,
                                  onTap:
                                      blocked ? null : () => _onPlaceTap(loc),
                                  onLongPress: () => Navigator.pushNamed(
                                    context,
                                    '/place_detail_screen',
                                    arguments: loc,
                                  ),
                                  distanceText: distanceText,
                                  metaText: openClose,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2.h,
                  left: 8.w,
                  right: 8.w,
                  child: _buildCompleteButton(alwaysEnabled: true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<TimeOfDay?> _ensureStartNotBeforeOpen(TimeOfDay? openTod) async {
    if (openTod == null) return _dayStart;

    final planned = _dayStart;
    final earliest = const TimeOfDay(hour: minHour, minute: 0);

    TimeOfDay effective = (planned.hour < earliest.hour ||
            (planned.hour == earliest.hour && planned.minute < earliest.minute))
        ? earliest
        : planned;

    final isTooEarly = (openTod.hour > effective.hour) ||
        (openTod.hour == effective.hour && openTod.minute > effective.minute);

    if (!isTooEarly) return effective;

    final ok = await _showConfirmDialog(
      title: 'Điểm mở cửa lúc ${_fmtTOD(openTod)}',
      content: Text(
        'Giờ bạn chọn là ${_fmtTOD(effective)}, nhưng điểm này mở cửa lúc ${_fmtTOD(openTod)}. '
        'Bạn có muốn lùi “Bắt đầu từ” về ${_fmtTOD(openTod)} không?',
      ),
    );

    if (ok) {
      setState(() {
        _dayStart = openTod;
        _userPickedStart = false;
      });
      return openTod;
    } else {
      return null;
    }
  }

  PreferredSizeWidget _buildIconOnlyAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _roundedIconButton(Icons.arrow_back,
            onPressed: () => Navigator.pop(context)),
      ),
      actions: [
        _roundedIconButton(Icons.menu),
        const SizedBox(width: 10),
        _buildSelectedCountButton(),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _roundedIconButton(IconData icon, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildSelectedCountButton() {
    return Stack(
      children: [
        _roundedIconButton(Icons.star_border, onPressed: _showSelectedList),
        if (_selectedActivities.isNotEmpty)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Text('${_selectedActivities.length}',
                  style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Future<void> _showDistanceTip() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.motorcycle, color: _kBlue),
                  SizedBox(width: 8),
                  Text('Giới hạn khoảng cách',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _kBlue)),
                ],
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: _kBlueLight2,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Để chuyến đi thoải mái và tiết kiệm thời gian di chuyển, hãy chọn điểm kế tiếp trong vòng ${_maxDistanceKm.toStringAsFixed(0)} km từ điểm trước.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Hiện tại: ${_maxDistanceKm.toStringAsFixed(0)} km',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: _kBlue)),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: _tonalBlueButton,
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await _askChangeRadius();
                    },
                    icon: const Icon(Icons.tune),
                    label: const Text('Đổi bán kính'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _confirmDistanceAfterRemoval(int idx) async {
    final prevIdx = idx - 1;
    final nextIdx = idx + 1;

    if (prevIdx >= 0 && nextIdx < _itinerary.length) {
      final from = _itinerary[prevIdx].place;
      final to = _itinerary[nextIdx].place;
      final fLat = from.safeLat, fLng = from.safeLng;
      final tLat = to.safeLat, tLng = to.safeLng;

      if (fLat != null && fLng != null && tLat != null && tLng != null) {
        try {
          final route = await _vietmap.routeMotorcycle(
              fromLat: fLat, fromLng: fLng, toLat: tLat, toLng: tLng);
          final distanceKm = route.distanceMeters / 1000.0;
          if (distanceKm > _maxDistanceKm) {
            return _showConfirmDialog(
              title: 'Khoảng cách xa sau khi xóa',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _placePills(from.name ?? 'Điểm trước', to.name ?? 'Điểm sau'),
                  const SizedBox(height: 12),
                  Text(
                      'Sau khi xóa, khoảng cách sẽ là ${distanceKm.toStringAsFixed(1)} km (>${_maxDistanceKm.toStringAsFixed(0)} km).'),
                ],
              ),
            );
          }
        } catch (_) {}
      }
    }
    return true;
  }

  Future<void> _askChangeRadius() async {
    final controller =
        TextEditingController(text: _maxDistanceKm.toStringAsFixed(0));
    final ok = await _showInputDialog(
      title: 'Đổi bán kính (km)',
      input: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: 'Ví dụ: 15', suffixText: 'km', border: InputBorder.none),
      ),
      okText: 'Lưu',
      cancelText: 'Hủy',
    );

    if (ok == true) {
      final v = double.tryParse(controller.text.trim().replaceAll(',', '.'));
      if (v == null || v <= 0) {
        _snack('Vui lòng nhập số km hợp lệ.');
        return;
      }
      setState(() {
        _maxDistanceKm = v;
      });
    }
  }

  void _showSelectedList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final places = _selectedActivities
                .map((a) => LocationModel(
                      id: a.locationId,
                      name: a.name,
                      description: a.description,
                      address: a.address,
                      category: a.type,
                      medias:
                          (a.imageUrl != null && a.imageUrl!.trim().isNotEmpty)
                              ? [MediaModel(mediaUrl: a.imageUrl!.trim())]
                              : const <MediaModel>[],
                    ))
                .toList();
            final itin = List<ItineraryStop>.from(_itinerary);

            return SelectedListSheet(
              selectedPlaces: places,
              itinerary: itin,
              typeLabelBuilder: (loc) => _vnTypeLabelFromCategory(loc.category),
              onRemoveAt: (idx) async {
                final removedAct = _selectedActivities[idx];
                final prevIdx = idx - 1;
                final nextIdx = idx + 1;

                bool continueRemove = true;
                if (prevIdx >= 0 && nextIdx < _itinerary.length) {
                  final from = _itinerary[prevIdx].place;
                  final to = _itinerary[nextIdx].place;
                  final fLat = from.safeLat, fLng = from.safeLng;
                  final tLat = to.safeLat, tLng = to.safeLng;

                  if (fLat != null &&
                      fLng != null &&
                      tLat != null &&
                      tLng != null) {
                    try {
                      final route = await _vietmap.routeMotorcycle(
                        fromLat: fLat,
                        fromLng: fLng,
                        toLat: tLat,
                        toLng: tLng,
                      );
                      final distanceKm = route.distanceMeters / 1000.0;
                      if (distanceKm > _maxDistanceKm) {
                        continueRemove = await _showConfirmDialog(
                          title: 'Khoảng cách xa sau khi xóa',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _placePills(from.name ?? 'Điểm trước',
                                  to.name ?? 'Điểm sau'),
                              const SizedBox(height: 12),
                              Text(
                                'Sau khi xóa “${removedAct.name}”, khoảng cách sẽ là ${distanceKm.toStringAsFixed(1)} km (>${_maxDistanceKm.toStringAsFixed(0)} km).',
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (_) {}
                  }
                }
                if (!continueRemove) return;

                await _handleRemoveAt(idx);

                if (!context.mounted) return;
                if (_selectedActivities.isEmpty) {
                  Navigator.pop(context);
                } else {
                  setModalState(() {});
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _placePills(String a, String b) {
    Widget chip(String text, IconData icon) {
      final maxW = MediaQuery.of(context).size.width * 0.55;
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              color: _kBlueLight, borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: _kBlue),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                      color: _kBlue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        chip(a, Icons.place),
        const Icon(Icons.arrow_forward, color: _kBlue, size: 18),
        chip(b, Icons.flag)
      ],
    );
  }

  Widget _buildCompleteButton({bool alwaysEnabled = false}) {
    final hasAny = _selectedActivities.isNotEmpty;

    final BoxDecoration deco = hasAny
        ? BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))
            ],
          )
        : BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30));

    return DecoratedBox(
      decoration: deco,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.8.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () async {
          final hasAny = _selectedActivities.isNotEmpty;

          if (!hasAny) {
            Navigator.pop(
                context, {'tpl': null, 'acts': null, 'clearDay': true});
            return;
          }

          if (_forceFoodMode && _spansLunch && !_hasFoodSelected) {
            _snack(
                'Bạn cần chọn ít nhất một địa điểm Ẩm thực cho ngày này (lịch đi qua khung trưa).');
            selectedFilterIndex.value = 2;
            return;
          }
          final payload = _toTplList();
          Navigator.pop(context, {
            'tpl': payload,
            'acts': List<TripActivityModel>.from(_selectedActivities)
          });
        },
        icon: Icon(hasAny ? Icons.check_circle : Icons.save_outlined,
            size: 20.sp, color: hasAny ? Colors.white : Colors.black54),
        label: Text(
          hasAny ? 'HOÀN TẤT' : 'LƯU NGÀY TRỐNG',
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: hasAny ? Colors.white : Colors.black87,
              letterSpacing: 1.2),
        ),
      ),
    );
  }

  Future<void> _syncStartWithFirstStop({bool showPrompt = true}) async {
    if (_selectedActivities.isEmpty || _itinerary.isEmpty) return;

    final firstPlace = _itinerary.first.place;
    final openTod = _parseOpenTime(itemOpenTime: firstPlace.openTime);
    if (openTod == null) return;

    final start = _dayStart;
    final startEarlier = (start.hour < openTod.hour) ||
        (start.hour == openTod.hour && start.minute < openTod.minute);
    if (!startEarlier) return;

    if (_userPickedStart && showPrompt) {
      final ok = await _showConfirmDialog(
        title: 'Điểm mở cửa lúc ${_fmtTOD(openTod)}',
        content: Text(
          'Bạn đang bắt đầu lúc ${_fmtTOD(start)}, sớm hơn giờ mở cửa của “${firstPlace.name ?? 'điểm đầu tiên'}” (${_fmtTOD(openTod)}). '
          'Bạn có muốn lùi “Bắt đầu từ” về ${_fmtTOD(openTod)} không?',
        ),
      );
      if (!ok) return;
    }

    setState(() {
      _dayStart = openTod;
      _userPickedStart = false;
      _recalcTimesForSelected();
    });
  }

  Future<void> _onPlaceTap(LocationModel loc) async {
    final id = loc.id ?? (loc.name ?? '');
    final isSelected = _selectedActivities.any((a) => a.locationId == id);

    if (_forceFoodMode && _autoInsertAfterPick) {
      final ok = await _insertLunchAt(loc);
      if (!ok) return;
      Navigator.pop(context, {
        'tpl': _toTplList(),
        'acts': List<TripActivityModel>.from(_selectedActivities)
      });
      return;
    }

    if (isSelected) {
      final idx = _selectedActivities.indexWhere((a) => a.locationId == id);
      if (!await _confirmDistanceAfterRemoval(idx)) return;
      await _handleRemoveAt(idx);
      return;
    }

    if (_blockedLocationIds.contains(id)) {
      _snack('Địa điểm này đã có ở ngày khác.');
      return;
    }

    final stay = await RouteDialogs.askStayMinutes(context);
    if (stay == null || stay <= 0) return;

    if (_selectedActivities.isEmpty) {
      if (loc.safeLat == null || loc.safeLng == null) {
        _snack(
            '“${loc.name ?? 'Điểm này'}” thiếu tọa độ. Không thể làm điểm xuất phát.');
        return;
      }

      final openTod = _parseOpenTime(itemOpenTime: loc.openTime);
      final confirmedStart = await _ensureStartNotBeforeOpen(openTod);
      if (confirmedStart == null) return;

      DateTime arrival = TimeUtils.combine(_dayDate, _dayStart);
      final minDt = TimeUtils.combine(
          _dayDate, const TimeOfDay(hour: minHour, minute: 0));
      if (arrival.isBefore(minDt)) arrival = minDt;

      final adjust = await _respectOpenClose(loc, arrival, stay);
      if (adjust == null) return;

      arrival = adjust.arrival;
      final int finalStay = adjust.stayMinutes;
      final depart = arrival.add(Duration(minutes: finalStay));

      if (!TimeUtils.withinDay(arrival, _dayDate, minHour, maxHour) ||
          !TimeUtils.withinDay(depart, _dayDate, minHour, maxHour)) {
        _snack('Lịch vượt quá $maxHour:00, vui lòng chọn thời lượng ngắn hơn.');
        return;
      }

      final ok = await RouteDialogs.showFirstStopDialog(
        context: context,
        placeName: loc.name ?? 'Điểm mới',
        arrival: arrival,
        depart: depart,
        stayMinutes: finalStay,
      );
      if (!ok) return;

      final act = _makeActivityFromLocation(
          loc: loc, arrival: arrival, depart: depart, order: 1);

      setState(() {
        _selectedActivities.add(act);
        _itinerary.add(ItineraryStop(
          place: loc,
          arrival: arrival,
          depart: depart,
          stayMinutes: finalStay,
          travelMeters: 0,
          travelSeconds: 0,
        ));
        _selectedIds.add(id);
        _anchorPlace = loc;
        _roadKmCache.clear();
      });

      _unawaited(_refreshMatrixFor(_allLocations));
      return;
    }

    final lastStop = _itinerary.last;
    final fromLat = lastStop.place.safeLat, fromLng = lastStop.place.safeLng;
    final toLat = loc.safeLat, toLng = loc.safeLng;

    if (fromLat == null || fromLng == null) {
      _snack(
          '“${lastStop.place.name ?? 'Điểm trước'}” thiếu tọa độ. Không thể tính lộ trình.');
      return;
    }
    if (toLat == null || toLng == null) {
      _snack(
          '“${loc.name ?? 'Điểm mới'}” thiếu tọa độ. Không thể tính lộ trình.');
      return;
    }

    try {
      final route = await _vietmap.routeMotorcycle(
          fromLat: fromLat, fromLng: fromLng, toLat: toLat, toLng: toLng);

      final distanceKm = route.distanceMeters / 1000.0;
      if (distanceKm > _maxDistanceKm) {
        final confirm = await _showConfirmDialog(
          title: 'Khoảng cách xa',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _placePills(
                  lastStop.place.name ?? 'Điểm trước', loc.name ?? 'Điểm mới'),
              const SizedBox(height: 12),
              Text(
                  'Điểm này cách điểm trước khoảng ${distanceKm.toStringAsFixed(1)} km, vượt giới hạn khuyến nghị là ${_maxDistanceKm.toStringAsFixed(0)} km.'),
            ],
          ),
        );
        if (confirm != true) return;
      }

      var arrival =
          lastStop.depart.add(Duration(seconds: route.durationSeconds));
      final adjust = await _respectOpenClose(loc, arrival, stay);
      if (adjust == null) return;

      arrival = adjust.arrival;
      final int finalStay = adjust.stayMinutes;
      final depart = arrival.add(Duration(minutes: finalStay));

      if (!TimeUtils.withinDay(arrival, _dayDate, minHour, maxHour) ||
          !TimeUtils.withinDay(depart, _dayDate, minHour, maxHour)) {
        _snack('Lịch vượt khung giờ $minHour:00–$maxHour:00 của ngày.');
        return;
      }

      final ok = await RouteDialogs.showRouteSummaryDialog(
        context: context,
        placeName: loc.name ?? 'Điểm mới',
        distanceKm: double.parse(distanceKm.toStringAsFixed(1)),
        travelMinutes: (route.durationSeconds / 60).round(),
        arrival: arrival,
        depart: depart,
      );
      if (!ok) return;

      final act = _makeActivityFromLocation(
        loc: loc,
        arrival: arrival,
        depart: depart,
        order: _selectedActivities.length + 1,
      );

      setState(() {
        _selectedActivities.add(act);
        _itinerary.add(ItineraryStop(
          place: loc,
          arrival: arrival,
          depart: depart,
          stayMinutes: finalStay,
          travelMeters: route.distanceMeters,
          travelSeconds: route.durationSeconds,
        ));
        _selectedIds.add(id);
        _anchorPlace = loc;
        _roadKmCache.clear();
      });

      _unawaited(_refreshMatrixFor(_allLocations));
    } on dynamic catch (e, st) {
      try {
        final status = (e as dynamic).response?.statusCode;
        final data = (e as dynamic).response?.data;
        final uri = (e as dynamic).requestOptions?.uri;
        debugPrint('[ROUTE][ERR] Dio-like error status=$status uri=$uri');
        debugPrint('[ROUTE][ERR] respData=$data');
      } catch (_) {}
      debugPrint('[ROUTE][ERR] $e');
      debugPrint(st.toString());
      _snack('Không thể tính lộ trình: ${e.runtimeType}. Vui lòng thử lại.');
    }
  }

  void _recalcTimesForSelected({int startFromIndex = 0}) {
    if (_selectedActivities.isEmpty) return;

    DateTime cursor = TimeUtils.combine(_dayDate, _dayStart);
    final earliest =
        TimeUtils.combine(_dayDate, const TimeOfDay(hour: minHour, minute: 0));
    if (cursor.isBefore(earliest)) cursor = earliest;

    for (int i = 0; i < _selectedActivities.length; i++) {
      if (i < startFromIndex && i != 0) continue;

      final oldAct = _selectedActivities[i];
      final oldStop = _itinerary[i];

      final stayMinutes = oldAct.endTime
          .difference(oldAct.startTime)
          .inMinutes
          .clamp(5, 24 * 60);

      if (i == 0) {
        // giữ cursor
      } else {
        final legTravelSecs = _itinerary[i].travelSeconds;
        cursor = _itinerary[i - 1].depart.add(Duration(seconds: legTravelSecs));
      }

      final arrival = cursor;
      final depart = arrival.add(Duration(minutes: stayMinutes));

      _selectedActivities[i] = oldAct.copyWith(
        startTime: arrival,
        endTime: depart,
        startTimeFormatted: DateFormat('HH:mm').format(arrival),
        endTimeFormatted: DateFormat('HH:mm').format(depart),
        duration: '$stayMinutes phút',
        order: i + 1,
      );

      _itinerary[i] = ItineraryStop(
        place: oldStop.place,
        arrival: arrival,
        depart: depart,
        stayMinutes: stayMinutes,
        travelMeters: oldStop.travelMeters,
        travelSeconds: oldStop.travelSeconds,
      );

      cursor = depart;
    }
    final tooLate = !TimeUtils.withinDay(
        _selectedActivities.last.endTime, _dayDate, minHour, maxHour);
    if (tooLate) {
      _snack('Lịch vượt khung giờ $minHour:00–$maxHour:00 sau khi đổi giờ.');
    }
  }

  TripActivityModel _makeActivityFromLocation({
    required LocationModel loc,
    required DateTime arrival,
    required DateTime depart,
    required int order,
  }) {
    final type = _vnTypeLabelFromCategory(loc.category);
    final durationMin = depart.difference(arrival).inMinutes;
    final img = loc.imgUrlFirst.trim();

    return TripActivityModel(
      locationId: loc.id ?? '',
      type: type,
      name: loc.name ?? 'Địa điểm không tên',
      description: loc.description ?? '',
      address: loc.address ?? '',
      startTime: arrival,
      endTime: depart,
      startTimeFormatted: DateFormat('HH:mm').format(arrival),
      endTimeFormatted: DateFormat('HH:mm').format(depart),
      duration: '$durationMin phút',
      notes: '',
      order: order,
      imageUrl: img.isEmpty ? null : img,
    );
  }

  List<TripPlanLocationModel> _toTplList() {
    final result = <TripPlanLocationModel>[];
    for (int i = 0; i < _selectedActivities.length; i++) {
      final a = _selectedActivities[i];
      final stop = _itinerary[i];
      result.add(
        TripPlanLocationModel(
          tripPlanLocationId: null,
          locationId: a.locationId,
          order: i + 1,
          startTime: a.startTime,
          endTime: a.endTime,
          notes: a.notes,
          travelTimeFromPrev: stop.travelSeconds,
          distanceFromPrev: stop.travelMeters,
          estimatedStartTime: a.startTime.millisecondsSinceEpoch ~/ 1000,
          estimatedEndTime: a.endTime.millisecondsSinceEpoch ~/ 1000,
        ),
      );
    }
    return result;
  }

  List<LocationModel> _filterLocations(
      List<LocationModel> src, int filterIndex) {
    switch (filterIndex) {
      case 1:
        return src
            .where((e) => _mapCategoryToType(e.category) == 'history')
            .toList();
      case 2:
        return src
            .where((e) => _mapCategoryToType(e.category) == 'food')
            .toList();
      case 3:
        return src
            .where((e) => _mapCategoryToType(e.category) == 'craft')
            .toList();
      case 4: 
        return src
            .where((e) => _mapCategoryToType(e.category) == 'scenic')
            .toList();
      default:
        return src;
    }
  }

  String _mapCategoryToType(String? category) {
    final c = (category ?? '').toLowerCase();
    if (c.contains('lịch sử')) return 'history';
    if (c.contains('làng nghề')) return 'craft';
    if (c.contains('ẩm thực')) return 'food';
    return 'scenic';
  }

  String _vnTypeLabelFromCategory(String? category) {
    switch (_mapCategoryToType(category)) {
      case 'history':
        return 'Địa điểm lịch sử';
      case 'craft':
        return 'Làng nghề';
      case 'food':
        return 'Ẩm thực';
      default:
        return 'Danh lam thắng cảnh';
    }
  }

  IconData _iconForCategory(String type) {
    switch (type) {
      case 'food':
        return Icons.restaurant;
      case 'craft':
        return Icons.handyman;
      default:
        return Icons.location_on;
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  TimeOfDay? _parseOpenTime({String? itemOpenTime}) {
    final s = itemOpenTime?.trim();
    if (s == null || s.isEmpty) return null;
    final m = RegExp(r'(\d{1,2})(?:[:hHgG]?(\d{2}))?').firstMatch(s);
    if (m == null) return null;
    final h = int.tryParse(m.group(1) ?? '');
    final mm = int.tryParse(m.group(2) ?? '0') ?? 0;
    if (h == null || h < 0 || h > 23) return null;
    if (mm < 0 || mm > 59) return null;
    return TimeOfDay(hour: h, minute: mm);
  }

  TimeOfDay? _parseCloseTime({String? itemCloseTime}) {
    final s = itemCloseTime?.trim();
    if (s == null || s.isEmpty) return null;
    final m = RegExp(r'(\d{1,2})(?:[:hHgG]?(\d{2}))?').firstMatch(s);
    if (m == null) return null;
    final h = int.tryParse(m.group(1) ?? '');
    final mm = int.tryParse(m.group(2) ?? '0') ?? 0;
    if (h == null || h < 0 || h > 23) return null;
    if (mm < 0 || mm > 59) return null;
    return TimeOfDay(hour: h, minute: mm);
  }

  bool get _spansLunch {
    if (_selectedActivities.isEmpty) return false;
    final start = DateTime(_dayDate.year, _dayDate.month, _dayDate.day,
        kLunchStart.hour, kLunchStart.minute);
    final end = DateTime(_dayDate.year, _dayDate.month, _dayDate.day,
        kLunchEnd.hour, kLunchEnd.minute);
    final firstStart = _selectedActivities.first.startTime;
    final lastEnd = _selectedActivities.last.endTime;
    return firstStart.isBefore(end) && lastEnd.isAfter(start);
  }

  bool get _hasFoodSelected =>
      _selectedActivities.any((a) => _mapCategoryToType(a.type) == 'food');

  Future<bool> _insertLunchAt(LocationModel loc) async {
    final target =
        TimeOfDay(hour: _lunchAt?.hour ?? 12, minute: _lunchAt?.minute ?? 0);
    final targetDt = TimeUtils.combine(_dayDate, target);
    final lunchStay = _lunchStayMinutes;

    if (_itinerary.isEmpty) {
      final adjust = await _respectOpenClose(loc, targetDt, lunchStay);
      if (adjust == null) return false;
      final arr = adjust.arrival;
      final dep = arr.add(Duration(minutes: adjust.stayMinutes));
      if (!TimeUtils.withinDay(arr, _dayDate, minHour, maxHour) ||
          !TimeUtils.withinDay(dep, _dayDate, minHour, maxHour)) {
        _snack('Giờ trưa vượt khung $minHour:00–$maxHour:00.');
        return false;
      }
      final act = _makeActivityFromLocation(
          loc: loc, arrival: arr, depart: dep, order: 1);
      setState(() {
        _selectedActivities.add(act);
        _itinerary.add(ItineraryStop(
          place: loc,
          arrival: arr,
          depart: dep,
          stayMinutes: adjust.stayMinutes,
          travelMeters: 0,
          travelSeconds: 0,
        ));
        _selectedIds.add((loc.id ?? loc.name) ?? '');
        _anchorPlace = loc;
        _roadKmCache.clear();
      });
      return true;
    }

    int insertIndex = _selectedActivities.length;
    Duration bestDelta = const Duration(days: 999);

    for (int i = 0; i < _itinerary.length; i++) {
      final prev = _itinerary[i];
      DateTime earliestReach = prev.depart;

      if (i < _itinerary.length - 1) {
        final next = _itinerary[i + 1];
        final pLat = prev.place.safeLat, pLng = prev.place.safeLng;
        final lLat = loc.safeLat, lLng = loc.safeLng;
        if (pLat != null && pLng != null && lLat != null && lLng != null) {
          try {
            final r = await _vietmap.routeMotorcycle(
                fromLat: pLat, fromLng: pLng, toLat: lLat, toLng: lLng);
            final arrLoc =
                prev.depart.add(Duration(seconds: r.durationSeconds));
            final delta = (arrLoc.isAfter(targetDt))
                ? arrLoc.difference(targetDt)
                : targetDt.difference(arrLoc);
            if (delta < bestDelta) {
              bestDelta = delta;
              insertIndex = i + 1;
            }
          } catch (_) {}
        }
      } else {
        final delta = (earliestReach.isAfter(targetDt))
            ? earliestReach.difference(targetDt)
            : targetDt.difference(earliestReach);
        if (delta < bestDelta) {
          bestDelta = delta;
          insertIndex = i + 1;
        }
      }
    }

    DateTime arrival = targetDt;
    int travelMeters = 0, travelSeconds = 0;
    if (insertIndex - 1 >= 0) {
      final prev = _itinerary[insertIndex - 1];
      final pLat = prev.place.safeLat, pLng = prev.place.safeLng;
      final lLat = loc.safeLat, lLng = loc.safeLng;
      if (pLat != null && pLng != null && lLat != null && lLng != null) {
        try {
          final r = await _vietmap.routeMotorcycle(
              fromLat: pLat, fromLng: pLng, toLat: lLat, toLng: lLng);
          travelMeters = r.distanceMeters;
          travelSeconds = r.durationSeconds;
          arrival = prev.depart.add(Duration(seconds: travelSeconds));
        } catch (_) {}
      }
    }

    final adjust = await _respectOpenClose(loc, arrival, lunchStay);
    if (adjust == null) return false;

    final arr = adjust.arrival;
    final dep = arr.add(Duration(minutes: adjust.stayMinutes));

    if (!TimeUtils.withinDay(arr, _dayDate, minHour, maxHour) ||
        !TimeUtils.withinDay(dep, _dayDate, minHour, maxHour)) {
      _snack('Giờ trưa vượt khung $minHour:00–$maxHour:00.');
      return false;
    }

    final act = _makeActivityFromLocation(
        loc: loc, arrival: arr, depart: dep, order: insertIndex + 1);

    setState(() {
      _selectedActivities.insert(insertIndex, act);
      _itinerary.insert(
        insertIndex,
        ItineraryStop(
          place: loc,
          arrival: arr,
          depart: dep,
          stayMinutes: adjust.stayMinutes,
          travelMeters: travelMeters,
          travelSeconds: travelSeconds,
        ),
      );
      _selectedIds.add((loc.id ?? loc.name) ?? '');
      _anchorPlace = loc;
      _roadKmCache.clear();
    });

    _recalcTimesForSelected(startFromIndex: insertIndex);
    return true;
  }

  Future<_VisitAdjust?> _respectOpenClose(
      LocationModel loc, DateTime rawArrival, int stayMinutes) async {
    DateTime arrival = rawArrival;
    int stay = stayMinutes;

    final openTod = _parseOpenTime(itemOpenTime: loc.openTime);
    final closeTod = _parseCloseTime(itemCloseTime: loc.closeTime);

    if (openTod != null) {
      final openDt = TimeUtils.combine(_dayDate, openTod);
      if (arrival.isBefore(openDt)) {
        final ok = await _showConfirmDialog(
          title: 'Chưa mở cửa',
          content: Text(
              '“${loc.name ?? 'Địa điểm'}” mở lúc ${_fmtTOD(openTod)}. Bạn có muốn chờ đến ${_fmtTOD(openTod)} không?'),
        );
        if (!ok) return null;
        arrival = openDt;
      }
    }

    if (closeTod != null) {
      final closeDt = TimeUtils.combine(_dayDate, closeTod);

      if (!arrival.isBefore(closeDt)) {
        _snack(
            '“${loc.name ?? 'Địa điểm'}” đóng lúc ${_fmtTOD(closeTod)}. Không thể ghé vào giờ này.');
        return null;
      }
      final proposedDepart = arrival.add(Duration(minutes: stay));
      if (proposedDepart.isAfter(closeDt)) {
        final left = closeDt.difference(arrival).inMinutes;
        if (left < 5) {
          _snack(
              'Chỉ còn $left phút trước giờ đóng cửa — thời lượng quá ngắn.');
          return null;
        }
        final ok = await _showConfirmDialog(
          title: 'Sắp đến giờ đóng cửa',
          content: Text(
              '“${loc.name ?? 'Địa điểm'}” đóng lúc ${_fmtTOD(closeTod)}.\nChỉ còn $left phút. '
              'Bạn có muốn rút ngắn thời gian dừng xuống $left phút không?'),
        );
        if (!ok) return null;
        stay = left;
      }
    }

    return _VisitAdjust(arrival, stay);
  }

  String _fmtTOD(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _roadKey(String? aId, String? aName, String? bId, String? bName) =>
      '${(aId ?? aName) ?? ''}|${(bId ?? bName) ?? ''}';

  Future<void> _refreshMatrixFor(List<LocationModel> targets) async {
    final a = _anchorPlace;
    if (a == null) return;

    final aLat = a.safeLat, aLng = a.safeLng;
    if (aLat == null || aLng == null) return;

    final usableTargets = <LocationModel>[];
    final coords = <List<double>>[];
    for (final t in targets) {
      final tId = (t.id ?? t.name) ?? '';
      final aId = (a.id ?? a.name) ?? '';
      if (tId == aId) continue;

      final lat = t.safeLat, lng = t.safeLng;
      if (lat == null || lng == null) continue;

      final key = _roadKey(a.id, a.name, t.id, t.name);
      if (_roadKmCache.containsKey(key)) continue;

      usableTargets.add(t);
      coords.add([lat, lng]);
    }

    if (coords.isEmpty) return;

    try {
      final kms = await _vietmap.matrixDistanceKm(
        anchorLat: aLat,
        anchorLng: aLng,
        targetsLatLng: coords,
        vehicle: 'motorcycle',
      );

      for (var i = 0; i < usableTargets.length; i++) {
        final t = usableTargets[i];
        final km = kms[i];
        if (km == null) continue;
        final key = _roadKey(a.id, a.name, t.id, t.name);
        _roadKmCache[key] = km;
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _unawaited(Future<void> f) {}
}

extension LocGeoX on LocationModel {
  double? get safeLat => latitude;
  double? get safeLng => longitude;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_day_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';

import 'package:travelogue_mobile/representation/trip_plan/screens/select_place_for_day_screen.dart';

class TripDayCard extends StatelessWidget {
  final DateTime day;
  final TripPlanDetailModel detail;

  final void Function(List<TripActivityModel> activities)? onUpdateActivities;
  final void Function(List<TripPlanLocationModel> locations)? onUpdateLocations;

  const TripDayCard({
    super.key,
    required this.day,
    required this.detail,
    this.onUpdateActivities,
    this.onUpdateLocations,
  });

  DateTime _ymd(DateTime d) => DateTime(d.year, d.month, d.day);

  TripDayModel? _findDayData(TripPlanDetailModel detail, DateTime day) {
    final target = _ymd(day);
    for (final d in detail.days) {
      if (_ymd(d.date) == target) {
        return d;
      }
    }
    return null;
  }

  List<T> _castList<T>(dynamic v) {
    if (v is List) {
      try {
        return v.cast<T>();
      } catch (_) {
        if (T == TripPlanLocationModel && v.isNotEmpty && v.first is Map) {
          return v
              .map<TripPlanLocationModel>((e) =>
                  TripPlanLocationModel.fromJson(e as Map<String, dynamic>))
              .cast<T>()
              .toList();
        }
        if (T == TripActivityModel && v.isNotEmpty && v.first is Map) {
          return v
              .map<TripActivityModel>(
                  (e) => TripActivityModel.fromJson(e as Map<String, dynamic>))
              .cast<T>()
              .toList();
        }
      }
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE, dd MMM', 'vi').format(day);

    final TripDayModel? dayData = _findDayData(detail, day);
    final List<TripActivityModel> activities = dayData?.activities ?? const [];

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 18.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(AssetHelper.img_lac_vien_01),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayName,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Text("📍 Các điểm đến trong ngày hôm nay",
                style: TextStyle(fontSize: 13.sp)),
            SizedBox(height: 1.h),
            ElevatedButton.icon(
              onPressed: () async {
                final allDays = detail.days;

                final TripDayModel? currentDayData = _findDayData(detail, day);
                final List<TripActivityModel> activities =
                    currentDayData?.activities ?? [];

                TimeOfDay? startTime;
                if (activities.isNotEmpty) {
                  final t = activities.first.startTime;
                  startTime = TimeOfDay(hour: t.hour, minute: t.minute);
                }

                final otherSelected = allDays
                    .where((d) => _ymd(d.date) != _ymd(day))
                    .expand((d) => d.activities)
                    .toList();

                final result = await Navigator.pushNamed(
                  context,
                  SelectPlaceForDayScreen.routeName,
                  arguments: {
                    'detail': detail,
                    'day': day,
                    'selected': activities,
                    'allSelectedOtherDays': otherSelected,
                    'startTime':
                        startTime ?? const TimeOfDay(hour: 6, minute: 0),
                  },
                );

                if (result is Map) {
                  final bool clearDay = result['clearDay'] == true ||
                      (result['tpl'] == null && result['acts'] == null);

                  if (clearDay) {
                    onUpdateActivities?.call(<TripActivityModel>[]);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onUpdateLocations?.call(const []);
                    });
                    return;
                  }

                  final finalActs =
                      _castList<TripActivityModel>(result['acts']);
                  if (finalActs.isNotEmpty) {
                    onUpdateActivities?.call(finalActs);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onUpdateLocations?.call(const []);
                    });
                    return;
                  }

                  final tplNew =
                      _castList<TripPlanLocationModel>(result['tpl']);
                  if (tplNew.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onUpdateLocations?.call(const []);
                    });
                    return;
                  }

                  return;
                }

                if (result is List<TripActivityModel> && result.isNotEmpty) {
                  onUpdateActivities
                      ?.call(List<TripActivityModel>.from(result));
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onUpdateLocations?.call(const []);
                  });
                  return;
                }

                if (result is List<TripPlanLocationModel> &&
                    result.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onUpdateLocations?.call(const []);
                  });
                }
              },
              icon: Icon(Icons.add_location_alt_outlined, size: 14.sp),
              label: Text('Thêm địa điểm', style: TextStyle(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.w)),
              ),
            ),
            if (activities.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Column(
                children: activities.asMap().entries.map((entry) {
                  final act = entry.value;

                  final title = act.name ?? 'Hoạt động';
                  final typeText = act.type ?? 'Hoạt động';
                  final startF = act.startTimeFormatted ??
                      DateFormat('HH:mm').format(act.startTime);
                  final endF = act.endTimeFormatted ??
                      DateFormat('HH:mm').format(act.endTime);
                  final duration = act.duration ?? '';
                  final infoLine = [
                    typeText,
                    '$startF–$endF',
                    if (duration.isNotEmpty) '($duration)',
                  ].join(' • ');

                  final img = act.imageUrl?.trim();
                  final address = (act.address ?? '').trim();

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w)),
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (img?.isNotEmpty == true)
                            ? Image.network(
                                img!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported, size: 32),
                      ),
                      title: Text(title, style: TextStyle(fontSize: 13.sp)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(infoLine, style: TextStyle(fontSize: 11.5.sp)),
                          if (address.isNotEmpty) ...[
                            SizedBox(height: 0.3.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.place,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

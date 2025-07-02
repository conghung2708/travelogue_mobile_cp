
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_tour_guide_screen.dart';
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
  late TripPlan trip;
  late List<DateTime> days;
  late TextEditingController _nameController;
  bool isEditingName = false;

  int selectedTabIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  final Map<DateTime, List<dynamic>> selectedPerDay = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) {
      return;
    }

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (args.containsKey('trip')) {
      trip = args['trip'] as TripPlan;
      days = args['days'] as List<DateTime>;
    } else {
      final name = args['name'] as String;
      final startDate = args['startDate'] as DateTime;
      final endDate = args['endDate'] as DateTime;

      trip = TripPlan(
        id: 'trip${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: 'Chưa có mô tả',
        startDate: startDate,
        endDate: endDate,
        coverImage: 'https://via.placeholder.com/400x200?text=Your+Trip',
        status: TripStatus.noGuide.index,
        rating: 0,
        price: 0,
      );

      days = List.generate(
        endDate.difference(startDate).inDays + 1,
        (i) => startDate.add(Duration(days: i)),
      );
    }

    if (args.containsKey('selectedPerDay')) {
      final rawMap = args['selectedPerDay'] as Map;
      for (final entry in rawMap.entries) {
        final date = entry.key as DateTime;
        final items = List<dynamic>.from(entry.value);
        selectedPerDay[date] = items;
      }
    }

    _nameController = TextEditingController(text: trip.name);
    _isInitialized = true;

  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditName() {
    setState(() {
      isEditingName = !isEditingName;
      if (!isEditingName) {
        _nameController.text = trip.name;
      }
    });
  }

  Future<void> _handleEditDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      locale: const Locale('vi', 'VN'),
      initialDateRange: DateTimeRange(start: days.first, end: days.last),
    );

    if (picked != null) {
      Navigator.pushReplacementNamed(
        context,
        SelectTripDayScreen.routeName,
        arguments: {
          'name': trip.name,
          'startDate': picked.start,
          'endDate': picked.end,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7FF),
      body: Column(
        children: [
          TripHeader(
            trip: trip,
            isEditingName: isEditingName,
            nameController: _nameController,
            onEditTap: () {
              if (isEditingName && _nameController.text.trim().isNotEmpty) {
                trip.name = _nameController.text.trim();
              }
              _toggleEditName();
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 1.5.h, left: 4.w, right: 4.w, bottom: 0.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                 Navigator.pop(context, trip);  
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
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
            child: GestureDetector(
              onTap: () async {
                final updatedTrip = await Navigator.pushNamed(
                  context,
                  SelectTourGuideScreen.routeName,
                  arguments: trip,
                ) as TripPlan?;

                if (updatedTrip != null) {
                  setState(() {
                    trip = TripPlan(
                      id: updatedTrip.id,
                      name: updatedTrip.name,
                      description: updatedTrip.description,
                      startDate: updatedTrip.startDate,
                      endDate: updatedTrip.endDate,
                      coverImage: updatedTrip.coverImage,
                      status: updatedTrip.tourGuide != null
                          ? TripStatus.planning.index
                          : TripStatus.noGuide.index,
                      rating: updatedTrip.rating,
                      price: updatedTrip.price,
                      versionId: updatedTrip.versionId,
                      tourGuide: updatedTrip.tourGuide,
                    );
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_pin_circle,
                        color: Colors.blue, size: 20.sp),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.tourGuide == null
                                ? "Chưa chọn hướng dẫn viên"
                                : trip.tourGuide!.name,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          Text(
                            trip.tourGuide == null
                                ? "Nhấn để chọn người đồng hành cùng bạn"
                                : trip.tourGuide!.bio,
                            style: TextStyle(
                                fontSize: 11.5.sp, color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (trip.tourGuide != null)
                      IconButton(
                        onPressed: () => setState(() => trip.tourGuide = null),
                        icon: Icon(Icons.cancel,
                            color: Colors.redAccent, size: 18.sp),
                      ),
                    Icon(Icons.arrow_forward_ios,
                        size: 14.sp, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black54, size: 13.sp),
                SizedBox(width: 2.w),
                Text(
                  '${DateFormat('dd/MM').format(days.first)} ➔ ${DateFormat('dd/MM').format(days.last)}',
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
                days.length,
                (index) => TripTabButton(
                  isSelected: index == selectedTabIndex,
                  label: 'Ngày ${index + 1}',
                  onTap: () => setState(() => selectedTabIndex = index),
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
                        day: days[selectedTabIndex],
                        trip: trip,
                        selectedItems:
                            selectedPerDay[days[selectedTabIndex]] ?? [],
                        otherSelected: selectedPerDay.entries
                            .where((e) => e.key != days[selectedTabIndex])
                            .expand((e) => e.value)
                            .toList(),
                        onUpdate: (updatedList) {
                          setState(() {
                            selectedPerDay[days[selectedTabIndex]] =
                                updatedList;
                          });
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
                        "\u2728 Mỗi ngày là một cuộc phiêu lưu mới, hãy khám phá thật trọn vẹn!",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.5.h),
                      GestureDetector(
                        onTap: () async {
                          if (trip.tourGuide == null) {
                            final decision = await showDialog<bool?>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "✨ Hành trình chưa có người dẫn đường"),
                                content: const Text(
                                  "Bạn chưa chọn hướng dẫn viên. Họ có thể giúp bạn trải nghiệm sâu sắc và thú vị hơn.\n\nBạn có muốn chọn ngay bây giờ không?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, null),
                                    child: const Text("Quay lại"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Không cần"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                    ),
                                    child: const Text("Tìm hướng dẫn viên"),
                                  ),
                                ],
                              ),
                            );

                            if (decision == null) {
                              return;
                            }

                            if (decision == true) {
                              final updatedTrip = await Navigator.pushNamed(
                                context,
                                SelectTourGuideScreen.routeName,
                                arguments: trip,
                              ) as TripPlan?;

                              if (updatedTrip != null) {
                                setState(() {
                                  trip = updatedTrip;
                                  trip.tourGuide = updatedTrip.tourGuide;
                                });
                                return;
                              }
                            } else {
                              trip.statusEnum = TripStatus.noGuide;
                            }
                          } else {
                            trip.statusEnum = TripStatus.planning;
                          }

                          final tripPlanVersionId =
                              'ver_${DateTime.now().millisecondsSinceEpoch}';
                          trip.versionId = tripPlanVersionId;
                          final newLocations = <TripPlanLocation>[];
                          final newCuisines = <TripPlanCuisine>[];
                          final newCrafts = <TripPlanCraftVillage>[];

                          int order = 0;

                        
                          selectedPerDay.forEach((day, items) {
                           
                            for (var item in items) {
                          final start = DateTime(day.year, day.month, day.day);
final end = DateTime(day.year, day.month, day.day);

                              if (item is TripPlanLocation) {
                                newLocations.add(TripPlanLocation(
                                  tripPlanVersionId: tripPlanVersionId,
                                  startTime: start,
                                  endTime: end,
                                  note: item.note,
                                  order: order++,
                                  location: item.location,
                                ));
                              } else if (item is TripPlanCuisine) {
                                newCuisines.add(TripPlanCuisine(
                                  tripPlanVersionId: tripPlanVersionId,
                                  startTime: start,
                                  endTime: end,
                                  note: item.note,
                                  order: order++,
                                  restaurant: item.restaurant,
                                ));
                              } else if (item is TripPlanCraftVillage) {
                                newCrafts.add(TripPlanCraftVillage(
                                  tripPlanVersionId: tripPlanVersionId,
                                  startTime: start,
                                  endTime: end,
                                  note: item.note,
                                  order: order++,
                                  craftVillage: item.craftVillage,
                                ));
                              }
                            }
                          });

                          tripLocations.addAll(newLocations);
                          tripCuisines.addAll(newCuisines);
                          tripCraftVillages.addAll(newCrafts);

                          trip.coverImage =
                              getTripPlanCoverImage(tripPlanVersionId);
                          Navigator.pop(context, trip);
                        },
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
      ),
    );
  }
}

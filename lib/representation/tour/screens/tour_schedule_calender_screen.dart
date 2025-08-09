import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/args/tour_calendar_args.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_payment_confirmation_screen.dart';

import 'package:travelogue_mobile/representation/tour/screens/tour_team_selector_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_schedule_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_calendar_selector.dart';

class TourScheduleCalendarScreen extends StatefulWidget {
  static const String routeName = '/tour-schedule-calendar';

  const TourScheduleCalendarScreen({super.key});

  @override
  State<TourScheduleCalendarScreen> createState() =>
      _TourScheduleCalendarScreenState();
}

class _TourScheduleCalendarScreenState
    extends State<TourScheduleCalendarScreen> {
  late TourModel tour;
  late List<TourScheduleModel> schedules;
  late bool isGroupTour;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  final formatter = NumberFormat('#,###');
  DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
 bool _isPastOrToday(DateTime day) => !_d(day).isAfter(_d(DateTime.now()));
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as TourCalendarArgs;
    tour = args.tour;
    schedules = args.schedules;
    isGroupTour = args.isGroupTour;
  }

TourScheduleModel? getScheduleForDay(DateTime day) {
  if (_isPastOrToday(day)) return null; 
  return schedules.firstWhereOrNull((s) {
    final dep = s.startTime;
    return dep != null && isSameDay(dep, day);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetHelper.img_tour_type_selector),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  TourScheduleHeader(onBack: () => Navigator.pop(context)),
                  SizedBox(height: 2.h),
                  TourCalendarSelector(
                    focusedDay: focusedDay,
                    selectedDay: selectedDay,
                    getScheduleForDay: getScheduleForDay,
                  onDaySelected: (selected, focused) {
  if (_isPastOrToday(selected)) {
 
    return;
  }

                      final matched = getScheduleForDay(selected);
                      if (matched != null) {
                        final departure = matched.startTime!;
                        final availableSlot = (matched.maxParticipant ?? 0) -
                            (matched.currentBooked ?? 0);

                        final media = (tour.mediaList.isNotEmpty &&
                                tour.mediaList.first.mediaUrl?.isNotEmpty ==
                                    true)
                            ? tour.mediaList.first.mediaUrl!
                            : AssetHelper.img_tay_ninh_login;
                        final guide = matched.tourGuide;
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.4),
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 24),
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(5.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.event_available,
                                        size: 28.sp,
                                        color: ColorPalette.primaryColor),
                                    SizedBox(height: 2.h),
                                    Text("Xác nhận ngày khởi hành",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.primaryColor)),
                                    SizedBox(height: 2.h),
                                    _buildDialogRow(
                                        Icons.calendar_today,
                                        'Ngày đi:',
                                        DateFormat('dd/MM/yyyy')
                                            .format(departure)),
                                    SizedBox(height: 1.h),
                                    _buildDialogRow(
                                        Icons.monetization_on,
                                        'Giá:',
                                        '${formatter.format(matched.adultPrice?.round() ?? 0)}đ'),
                                    SizedBox(height: 1.h),
                                    _buildDialogRow(Icons.people_outline,
                                        'Còn lại:', '$availableSlot chỗ'),
                                    SizedBox(height: 3.h),
                                    if (guide != null) ...[
                                      Divider(),
                                      SizedBox(height: 1.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.5.h),
                                        child: Row(
                                          children: [
                                       
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xFFE0F2FE), 
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(1.w),
                                              child: const Icon(
                                                Icons.person_rounded,
                                                color: Color(
                                                    0xFF0284C7), 
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                          
                                            Text(
                                              'Hướng dẫn viên',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 1.w),
                                 
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                                indent: 8,
                                                endIndent: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      _buildGuideCard(guide),
                                      SizedBox(height: 2.h),
                                    ],
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Huỷ"),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (isGroupTour) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        TourTeamSelectorScreen(
                                                      tour: tour,
                                                      schedule: matched,
                                                      media: media,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.pushNamed(
                                                  context,
                                                  TourPaymentConfirmationScreen
                                                      .routeName,
                                                  arguments: {
                                                    'tour': tour,
                                                    'schedule': matched,
                                                    'media': media,
                                                    'startTime':
                                                        matched.startTime!,
                                                    'adults': 1,
                                                    'children': 0,
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5.h),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: Gradients
                                                    .defaultGradientBackground,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text("Chọn ngày này",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '🗓️ Chọn đúng thời điểm – mở ra chuyến đi đáng nhớ!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorPalette.primaryColor, size: 20.sp),
        SizedBox(width: 2.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '$label ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15.sp)),
                TextSpan(
                    text: value,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        fontSize: 15.sp)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildGuideCard(TourGuideModel guide) {
  final name = (guide.userName?.isNotEmpty == true)
      ? guide.userName!
      : (guide.email ?? 'Hướng dẫn viên');
  final rating = (guide.averageRating ?? 0).toDouble().clamp(0, 5);
  final reviews = guide.totalReviews ?? 0;
  final price = guide.price;
  final sex = guide.sexText;

  final avatar = (guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty)
      ? NetworkImage(guide.avatarUrl!)
      : const AssetImage(AssetHelper.img_default) as ImageProvider;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.withOpacity(0.08),
          Colors.cyan.withOpacity(0.05),
          Colors.white,
        ],
      ),
      border: Border.all(color: Colors.blue.withOpacity(0.15)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    padding: EdgeInsets.all(3.5.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(2.2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7DD3FC), Color(0xFF60A5FA)],
                ),
              ),
              child: CircleAvatar(
                radius: 21.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 19.sp,
                  backgroundImage: avatar,
                ),
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 3.5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded,
                      size: 18, color: Color(0xFF3B82F6)),
                ],
              ),
              SizedBox(height: 0.6.h),
              Row(
                children: [
                  _StarRow(rating: rating),
                  SizedBox(width: 1.2.w),
                  Text(
                    '${rating.toStringAsFixed(1)} (${NumberFormat('#,###').format(reviews)})',
                    style: TextStyle(fontSize: 11.5.sp, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 0.7.h),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (price != null)
                    _ChipPill(
                      icon: Icons.payments_rounded,
                      label:
                          'Phí: ${NumberFormat('#,###').format(price.round())}đ',
                    ),
                  if (sex?.isNotEmpty == true)
                    _ChipPill(
                      icon: Icons.wc_rounded,
                      label: sex!,
                      tone: ChipTone.neutral,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StarRow extends StatelessWidget {
  final num rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      final fill = rating + 0.001 - i;
      final icon = fill >= 0
          ? Icons.star_rounded
          : (fill > -1 ? Icons.star_half_rounded : Icons.star_border_rounded);
      stars.add(Icon(icon, size: 16, color: const Color(0xFFFFB200)));
    }
    return Row(children: stars);
  }
}

enum ChipTone { primary, neutral }

class _ChipPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final ChipTone tone;
  const _ChipPill({
    required this.icon,
    required this.label,
    this.tone = ChipTone.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bg = tone == ChipTone.primary
        ? const Color(0xFFEFF6FF)
        : const Color(0xFFF3F4F6);
    final fg = tone == ChipTone.primary
        ? const Color(0xFF2563EB)
        : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style:
                TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

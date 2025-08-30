import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_event.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/repository/workshop_repository.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';

class HotLocationCard extends StatefulWidget {
  final LocationModel place;
  const HotLocationCard({super.key, required this.place});

  @override
  State<HotLocationCard> createState() => _HotLocationCardState();
}

class _HotLocationCardState extends State<HotLocationCard> {
  bool isLiked = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isLiked = widget.place.isLiked;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _chip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: Colors.white),
          SizedBox(width: 5.sp),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay? _parseHm(String? hm) {
    if (hm == null || hm.trim().isEmpty) return null;
    final p = hm.split(':');
    if (p.length < 2) return null;
    final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatHm(TimeOfDay? t) {
    if (t == null) return '';
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  bool _isOpenNow(TimeOfDay? open, TimeOfDay? close) {
    if (open == null || close == null) return false;
    final now = TimeOfDay.now();
    bool afterEq(TimeOfDay a, TimeOfDay b) =>
        a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
    bool before(TimeOfDay a, TimeOfDay b) =>
        a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
    if (before(open, close)) {
      return afterEq(now, open) && before(now, close);
    }
    return afterEq(now, open) || before(now, close);
  }

  @override
  Widget build(BuildContext context) {
    final openT = _parseHm(widget.place.openTime);
    final closeT = _parseHm(widget.place.closeTime);
    final hasHours = openT != null && closeT != null;
    final hoursLabel = hasHours
        ? '${_formatHm(openT)} – ${_formatHm(closeT)}'
        : (widget.place.openTime ?? widget.place.closeTime ?? '');
    final isOpen = hasHours ? _isOpenNow(openT, closeT) : null;

    final category = (widget.place.category ?? '').trim();
    final district = (widget.place.districtName ?? '').trim();

    return GestureDetector(
      onTap: () {
        if ((widget.place.category ?? '') == "Làng nghề") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => WorkshopBloc(WorkshopRepository())
                  ..add(GetWorkshopsEvent(craftVillageId: widget.place.id ?? '')),
                child: const CraftVillageDetailScreen(),
              ),
              settings: RouteSettings(arguments: widget.place),
            ),
          );
        } else {
          Navigator.of(context).pushNamed(
            PlaceDetailScreen.routeName,
            arguments: widget.place,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.sp),
        child: Container(
          margin: const EdgeInsets.only(right: kDefaultPadding),
          width: 260,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(4, 4)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ImageNetworkCard(
                    url: widget.place.imgUrlFirst,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),

                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.black.withOpacity(0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (category.isNotEmpty || district.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 56, 
                    child: Wrap(
                      spacing: 6.sp,
                      runSpacing: 6.sp,
                      children: [
                        if (category.isNotEmpty)
                          _chip(icon: Icons.category_rounded, text: category),
                        if (district.isNotEmpty)
                          _chip(icon: Icons.location_on_rounded, text: district),
                      ],
                    ),
                  ),

                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        if (UserLocal().getAccessToken.isEmpty) {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                          return;
                        }
                        setState(() => isLiked = !isLiked);
                        _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          if (isLiked != widget.place.isLiked) {
                            AppBloc.homeBloc.add(
                              UpdateLikedLocationEvent(
                                locationId: widget.place.id ?? '',
                                isLiked: isLiked,
                                context: context,
                              ),
                            );
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Icon(
                          isLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                   
                      Text(
                        widget.place.name ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          shadows: const [
                            Shadow(color: Colors.black38, blurRadius: 6),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.sp),

           
                      if ((hoursLabel).trim().isNotEmpty || isOpen != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if ((hoursLabel).trim().isNotEmpty) ...[
                              Icon(Icons.schedule_rounded,
                                  size: 11.sp, color: Colors.white),
                              SizedBox(width: 6.sp),
                              Text(
                                hoursLabel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (isOpen != null) ...[
                              SizedBox(width: 8.sp),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.sp, vertical: 3.5.sp),
                                decoration: BoxDecoration(
                                  color: (isOpen ? Colors.green : Colors.red)
                                      .withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  isOpen ? 'Đang mở cửa' : 'Đã đóng',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

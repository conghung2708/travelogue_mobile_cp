import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village_detail_screen.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';

class HotLocationCard extends StatefulWidget {
  final LocationModel place;
  const HotLocationCard({
    super.key,
    required this.place,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if ((widget.place.category ?? '') == "Làng nghề") {
          Navigator.of(context).pushNamed(
            CraftVillageDetailScreen.routeName,
            arguments: widget.place,
          );
        } else {
          Navigator.of(context).pushNamed(
            PlaceDetailScreen.routeName,
            arguments: widget.place,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.sp),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: kDefaultPadding),
              width: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ImageNetworkCard(
                  url: widget.place.imgUrlFirst,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 16,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  height: 30.sp,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Text(
                    widget.place.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 25,
              child: GestureDetector(
                onTap: () {
                  if (UserLocal().getAccessToken.isEmpty) {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                    return;
                  }
                  setState(() {
                    isLiked = !isLiked;
                  });
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
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
                child: Container(
                  padding: EdgeInsets.all(7.sp),
                  color: Colors.transparent,
                  child: Icon(
                    isLiked
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/model/location_model.dart';

import 'package:travelogue_mobile/representation/home/widgets/hot_location_card.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class HotLocations extends StatefulWidget {
  final List<LocationModel> places;

  const HotLocations({super.key, required this.places});

  @override
  State<HotLocations> createState() => _HotLocationsState();
}

class _HotLocationsState extends State<HotLocations> {
  Set<int> favoritePlaces = {};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWithCustoneUnderline(
            text: 'Điểm đến',
            text2: ' Tây Ninh 🗺️',
          ),
          // SizedBox(height: 15.sp),
          Container(
            margin: const EdgeInsets.only(top: kDefaultPadding),
            padding: EdgeInsets.zero,
            height: 300,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemCount: widget.places.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                LocationModel place = widget.places[index];

                return HotLocationCard(
                  place: place,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

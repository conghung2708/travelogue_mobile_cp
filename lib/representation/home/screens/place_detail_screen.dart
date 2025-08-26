import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_bloc.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_event.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';
import 'package:travelogue_mobile/representation/home/widgets/place_bottom_bar.dart';

class PlaceDetailScreen extends StatefulWidget {
  final LocationModel place;

  const PlaceDetailScreen({super.key, required this.place});

  static const routeName = '/place_detail_screen';

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
@override
void initState() {
  super.initState();

  final locationId = widget.place.id ?? '';


  // AppBloc.hotelRestaurantBloc.add(GetHotelRestaurantEvent(locationId: locationId));


  context.read<NearestDataBloc>().add(GetNearestCuisineEvent(locationId));
  context.read<NearestDataBloc>().add(GetNearestHistoricalEvent(locationId));
}

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.place.imgUrlFirst),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent,
        //     statusBarBrightness: Brightness.light,
        //     statusBarIconBrightness: Brightness.light,
        //   ),
        //   backgroundColor: Colors.transparent,
        //   surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   centerTitle: true,
        // ),
        // bottomNavigationBar: ,
        body: Stack(
          children: [
            PlaceBottomBar(
              place: widget.place,
            ),
            Positioned(
              top: 30.sp,
              left: 17.sp,
              child: ArrowBackButton(onPressed: () {
                Navigator.of(context).pop();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

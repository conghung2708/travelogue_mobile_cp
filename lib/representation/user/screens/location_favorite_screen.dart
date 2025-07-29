import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';

class FavoriteLocationScreen extends StatelessWidget {
  static const String routeName = '/favourite_location_screen';

  const FavoriteLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FBFB), // nhẹ hơn, sáng hơn
      appBar: AppBar(
        title: const Text(
          'Địa điểm yêu thích',
          style: TextStyle(
            fontFamily: "Pattaya",
            fontSize: 24,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final List<LocationModel> locationFavorite =
              state.props[3] as List<LocationModel>;

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 2.5.h,
              childAspectRatio: 0.70,
            ),
            itemCount: locationFavorite.length,
            itemBuilder: (context, index) {
              final location = locationFavorite[index];
              final image = location.medias?.first.mediaUrl ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    PlaceDetailScreen.routeName,
                    arguments: location,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        child: Stack(
                          children: [
                            ImageNetworkCard(
                              url: image,
                              height: 17.5.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.15),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.teal,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w, vertical: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 2.5.w, vertical: 0.5.h),
                              //   decoration: BoxDecoration(
                              //     color: Colors.teal.shade50,
                              //     borderRadius: BorderRadius.circular(50),
                              //   ),
                              //   child: Text(
                              //     location.typeLocationName ?? 'Địa điểm',
                              //     style: TextStyle(
                              //       fontSize: 11.5.sp,
                              //       fontWeight: FontWeight.w500,
                              //       color: Colors.teal[700],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 1.2.h),
                              Expanded(
                                child: Text(
                                  location.description ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

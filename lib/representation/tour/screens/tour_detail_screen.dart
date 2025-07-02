import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/blocs/restaurant/restaurant_bloc.dart';
import 'package:travelogue_mobile/core/repository/restaurant_repository.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_location_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_cuisine_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_craft_village_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/craft_village_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

import 'package:travelogue_mobile/representation/tour/widgets/tour_detail_content.dart';

class TourDetailScreen extends StatelessWidget {
  static const routeName = '/tour_detail';

  final TourTestModel tour;
  final TourMediaTestModel? media;
  final TourGuideTestModel? guide;

  const TourDetailScreen({
    super.key,
    required this.tour,
    this.media,
    this.guide,
  });

  Widget _buildTourImage() {
    final isAsset = !(media?.mediaUrl?.startsWith('http') ?? false);
    return isAsset
        ? Image.asset(
            media?.mediaUrl ?? AssetHelper.img_tay_ninh_login,
            width: double.infinity,
            height: 30.h,
            fit: BoxFit.cover,
          )
        : Image.network(
            media!.mediaUrl!,
            width: double.infinity,
            height: 30.h,
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()..add(GetAllLocationEvent())),
        BlocProvider(
          create: (_) => RestaurantBloc(repository: RestaurantRepository())
            ..add(GetAllRestaurantEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      _buildTourImage(),
                      Positioned(
                        top: 2.h,
                        left: 4.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState) {
                        if (homeState is! GetHomeSuccess) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return BlocBuilder<RestaurantBloc, RestaurantState>(
                          builder: (context, restaurantState) {
                            if (restaurantState is! RestaurantLoaded) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final locationList = homeState.locations;
                            final restaurantList = restaurantState.restaurants;

                            TourPlanVersionTestModel? currentVersion;
                            try {
                              currentVersion = mockTourPlanVersions.firstWhere(
                                  (v) => v.id == tour.currentVersionId);
                            } catch (_) {
                              currentVersion = null;
                            }

                            TourGuideTestModel? currentGuide;
                            try {
                              if (currentVersion?.tourGuideId != null) {
                                currentGuide = mockTourGuides.firstWhere(
                                    (g) => g.id == currentVersion!.tourGuideId);
                              }
                            } catch (_) {
                              currentGuide = null;
                            }

                            final locationPlans = mockTourPlanLocations
                                .where((e) => e.tourPlanVersionId == currentVersion?.id)
                                .toList();

                            final cuisinePlans = mockTourPlanCuisines
                                .where((e) => e.tourPlanVersionId == currentVersion?.id)
                                .toList();

                            final villagePlans = mockTourPlanCraftVillages
                                .where((e) => e.tourPlanVersionId == currentVersion?.id)
                                .toList();

                            final craftVillageList = villagePlans.map((v) {
                              return craftVillages.firstWhere(
                                (c) => c.id == v.craftVillageId,
                                orElse: () => CraftVillageModel(
                                  id: '',
                                  name: 'Không rõ',
                                  description: '',
                                  content: '',
                                  phoneNumber: '',
                                  email: '',
                                  address: '',
                                  imageList: [],
                                ),
                              );
                            }).toList();

                            final Map<String, String> descriptionMap = {
                              for (var loc in locationPlans)
                                loc.id: locationList
                                        .firstWhere(
                                          (l) => l.id == loc.locationId,
                                          orElse: () => LocationModel(
                                              id: '',
                                              name: '',
                                              description: ''),
                                        )
                                        .description ??
                                    '',
                              for (var cui in cuisinePlans)
                                cui.id: restaurantList
                                        .firstWhere(
                                          (r) => r.id == cui.cuisineId,
                                          orElse: () => RestaurantModel(
                                              id: '',
                                              name: '',
                                              description: ''),
                                        )
                                        .description ??
                                    '',
                              for (var vil in villagePlans)
                                vil.id: craftVillageList
                                    .firstWhere(
                                      (v) => v.id == vil.craftVillageId,
                                      orElse: () => CraftVillageModel(
                                        id: '',
                                        name: '',
                                        description: '',
                                        content: '',
                                        phoneNumber: '',
                                        email: '',
                                        address: '',
                                        imageList: [],
                                      ),
                                    )
                                    .description,
                            };

                            return SingleChildScrollView(
                              padding: EdgeInsets.all(4.w),
                              child: TourDetailContent(
                                tour: tour,
                                guide: guide ?? currentGuide,
                                locations: locationPlans,
                                cuisines: cuisinePlans,
                                villages: villagePlans,
                                locationList: locationList,
                                restaurantList: restaurantList,
                                craftVillageList: craftVillageList,
                                descriptionMap: descriptionMap,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Xác nhận"),
                    content: const Text("Bạn có muốn gọi điện cho 0336626193 không?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Huỷ"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Gọi"),
                      )
                    ],
                  ),
                );

                if (confirm == true) {
                  final phoneUri = Uri(scheme: 'tel', path: '0336626193');
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không thể thực hiện cuộc gọi.')),
                    );
                  }
                }
              },
              child: const Icon(Icons.phone),
            ),
          );
        },
      ),
    );
  }
}
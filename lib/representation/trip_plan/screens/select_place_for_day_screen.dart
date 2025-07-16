import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/restaurant/restaurant_bloc.dart';
import 'package:travelogue_mobile/core/repository/restaurant_repository.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';
import 'package:travelogue_mobile/model/trip_craft_village.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class SelectPlaceForDayScreen extends StatefulWidget {
  static const routeName = '/select-place-for-day';

  final TripPlan trip;
  final DateTime day;

  const SelectPlaceForDayScreen(
      {super.key, required this.trip, required this.day});

  @override
  State<SelectPlaceForDayScreen> createState() =>
      _SelectPlaceForDayScreenState();
}



class _SelectPlaceForDayScreenState extends State<SelectPlaceForDayScreen> {
  final ValueNotifier<int> selectedFilterIndex = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> selectedPlaces = [];
  List<LocationModel> locations = [];
  List<RestaurantModel> restaurants = [];
  Set<String> blockedIds = {}; 
  

    @override
  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  final initialSelected = args['selected'] as List<dynamic>? ?? [];
  final blockedItems = args['allSelectedOtherDays'] as List<dynamic>? ?? [];

  // Chuyển blocked items thành Set<String> id  
  blockedIds.clear();
  for (var item in blockedItems) {
    if (item is TripPlanLocation) {
      blockedIds.add(item.location.id ?? '');
    } else if (item is TripPlanCuisine) {
      blockedIds.add(item.restaurant.id ?? '');
    } else if (item is TripPlanCraftVillage) {
      blockedIds.add(item.craftVillage.id);
    }
  }

  // Khởi tạo selectedPlaces nếu rỗng
  if (selectedPlaces.isEmpty && initialSelected.isNotEmpty) {
    for (var item in initialSelected) {
      if (item is TripPlanLocation) {
        selectedPlaces.add({
          'id': item.location.id ?? '',
          'name': item.location.name ?? '',
          'imageUrl': item.location.imgUrlFirst,
          'type': 'location',
          'object': item.location,
        });
      } else if (item is TripPlanCuisine) {
        selectedPlaces.add({
          'id': item.restaurant.id ?? '',
          'name': item.restaurant.name ?? '',
          'imageUrl': item.restaurant.imgUrlFirst,
          'type': 'restaurant',
          'object': item.restaurant,
        });
      } else if (item is TripPlanCraftVillage) {
        selectedPlaces.add({
          'id': item.craftVillage.id,
          'name': item.craftVillage.name,
          'imageUrl': item.craftVillage.imageList.first,
          'type': 'craft',
          'object': item.craftVillage,
        });
      }
    }
    setState(() {}); // Cập nhật UI
  }
}
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(GetAllLocationEvent()),
        ),
        BlocProvider<RestaurantBloc>(
          create: (_) => RestaurantBloc(repository: RestaurantRepository())
            ..add(GetAllRestaurantEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildIconOnlyAppBar(context),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, locationState) {
            locations =
                locationState is GetHomeSuccess ? locationState.locations : [];
            return BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, restaurantState) {
                restaurants = restaurantState is RestaurantLoaded
                    ? restaurantState.restaurants
                    : [];
                final villages = craftVillages;
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
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold)),
                          Text('Địa điểm',
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2.h),
                          Center(
                            child: ValueListenableBuilder<int>(
                              valueListenable: selectedFilterIndex,
                              builder: (context, selectedIndex, _) {
                                final filters = [
                                  {
                                    'label': 'Tất cả',
                                    'icon': Icons.all_inclusive
                                  },
                                  {
                                    'label': 'Di tích',
                                    'icon': Icons.location_on
                                  },
                                  {
                                    'label': 'Ẩm thực',
                                    'icon': Icons.restaurant
                                  },
                                  {
                                    'label': 'Làng nghề',
                                    'icon': Icons.handyman
                                  },
                                ];
                                return SizedBox(
                                  height: 10.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        List.generate(filters.length, (index) {
                                      final selected = index == selectedIndex;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        child: GestureDetector(
                                          onTap: () =>
                                              selectedFilterIndex.value = index,
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor: selected
                                                    ? Colors.blueAccent
                                                    : Colors.grey[200],
                                                child: Icon(
                                                  filters[index]['icon']
                                                      as IconData,
                                                  color: selected
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                              SizedBox(height: 0.8.h),
                                              Text(
                                                filters[index]['label']
                                                    as String,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: selected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: selected
                                                      ? Colors.blueAccent
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                          const TitleWithCustoneUnderline(
                              text: '📍Địa điểm ', text2: ' nổi bật'),
                          SizedBox(height: 2.h),
                          Expanded(
                            child: ValueListenableBuilder<int>(
                              valueListenable: selectedFilterIndex,
                              builder: (context, filterIndex, _) {
                                List<Widget> items;
                                switch (filterIndex) {
                                  case 1:
                                    items = locations
                                        .map((e) => _buildCardItem(
                                            context,
                                            e.imgUrlFirst,
                                            e.name ?? '',
                                            Icons.location_on,
                                            e))
                                        .toList();
                                    break;
                                  case 2:
                                    items = restaurants
                                        .map((e) => _buildCardItem(
                                            context,
                                            e.imgUrlFirst,
                                            e.name ?? '',
                                            Icons.restaurant,
                                            e))
                                        .toList();
                                    break;
                                  case 3:
                                    items = villages
                                        .map((e) => _buildCardItem(
                                            context,
                                            e.imageList.first,
                                            e.name,
                                            Icons.handyman,
                                            e))
                                        .toList();
                                    break;
                                  default:
                                    items = [
                                      ...locations.map((e) => _buildCardItem(
                                          context,
                                          e.imgUrlFirst,
                                          e.name ?? '',
                                          Icons.location_on,
                                          e)),
                                      ...restaurants.map((e) => _buildCardItem(
                                          context,
                                          e.imgUrlFirst,
                                          e.name ?? '',
                                          Icons.restaurant,
                                          e)),
                                      ...villages.map((e) => _buildCardItem(
                                          context,
                                          e.imageList.first,
                                          e.name,
                                          Icons.handyman,
                                          e)),
                                    ];
                                }
                                return MasonryGridView.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2.h,
                                  crossAxisSpacing: 4.w,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) => items[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedPlaces.isNotEmpty)
                      Positioned(
                        bottom: 2.h,
                        left: 8.w,
                        right: 8.w,
                        child: _buildGradientCompleteButton(),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteIconButton() {
    return Stack(
      children: [
        _roundedIconButton(Icons.star_border, onPressed: _showSelectedList),
        if (selectedPlaces.isNotEmpty)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${selectedPlaces.length}',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

 void _showSelectedList() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6, // Tùy chỉnh chiều cao ban đầu
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Đã chọn (${selectedPlaces.length}/6)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: selectedPlaces.length,
                    itemBuilder: (context, index) {
                      final place = selectedPlaces[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(place['imageUrl'] ?? ''),
                          onBackgroundImageError: (_, __) => const Icon(Icons.image),
                        ),
                        title: Text(place['name']),
                        subtitle: Text(_getTypeInVietnamese(place['type'])),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedPlaces.removeAt(index);
                              Navigator.pop(context);
                              _showSelectedList(); // Hiện lại sau khi xoá
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

 
Widget _buildGradientCompleteButton() {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        final results = selectedPlaces.map((place) {
          final type = place['type'];
          if (type == 'location') {
            return TripPlanLocation(
              tripPlanVersionId: '',
              startTime: widget.day,
              endTime: widget.day.add(const Duration(hours: 1)),
              note: '',
              order: 0,
              location: place['object'],
            );
          } else if (type == 'restaurant') {
            return TripPlanCuisine(
              tripPlanVersionId: '',
              restaurant: place['object'],
              startTime: widget.day,
              endTime: widget.day.add(const Duration(hours: 1)),
              note: '',
              order: 0,
            );
          } else {
            return TripPlanCraftVillage(
              tripPlanVersionId: '',
              craftVillage: place['object'],
              startTime: widget.day,
              endTime: widget.day.add(const Duration(hours: 1)),
              note: '',
              order: 0,
            );
          }
        }).toList();

        Navigator.pop(context, results);
      },
      icon: Icon(Icons.check_circle, size: 20.sp, color: Colors.white),
      label: Text(
        'HOÀN TẤT',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );
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
        _buildFavoriteIconButton(),
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
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

 Widget _buildCardItem(
  BuildContext context,
  String imageUrl,
  String name,
  IconData icon,
  dynamic item,
) {
  final id = item.id ?? name;
  final isSelected = selectedPlaces.any((p) => p['id'] == id);
  final selectedIndex =
      isSelected ? selectedPlaces.indexWhere((p) => p['id'] == id) + 1 : 0;

  final isBlocked = blockedIds.contains(id);

  final cardContent = ClipRRect(
    borderRadius: BorderRadius.circular(4.w),
    child: Stack(
      children: [
        Image.network(
          imageUrl,
          width: 45.w,
          height: 45.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 45.w,
            height: 45.w,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, size: 16.sp),
          ),
        ),
        if (selectedIndex > 0)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    '$selectedIndex',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 2.w,
          right: 2.w,
          bottom: 2.h,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 12.sp, color: Colors.white),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 2),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  if (isBlocked) {
    return Opacity(
      opacity: 0.3,
      child: IgnorePointer(
        ignoring: true,
        child: cardContent,
      ),
    );
  }

  return GestureDetector(
    onTap: () {
      setState(() {
        if (isSelected) {
          selectedPlaces.removeWhere((p) => p['id'] == id);
        } else if (selectedPlaces.length < 6) {
          selectedPlaces.add({
            'id': id,
            'name': name,
            'imageUrl': imageUrl,
            'type': icon == Icons.restaurant
                ? 'restaurant'
                : icon == Icons.handyman
                    ? 'craft'
                    : 'location',
            'object': item,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chỉ được chọn tối đa 6 địa điểm.')),
          );
        }
      });
    },
    onLongPress: () {
      if (icon == Icons.restaurant) {
        Navigator.pushNamed(context, '/restaurant_detail_screen',
            arguments: item);
      } else if (icon == Icons.handyman) {
        Navigator.pushNamed(context, '/craft_village_detail_screen',
            arguments: item);
      } else {
        Navigator.pushNamed(context, '/place_detail_screen', arguments: item);
      }
    },
    child: cardContent,
  );
}

}


String _getTypeInVietnamese(String type) {
  switch (type) {
    case 'restaurant':
      return 'Ẩm thực';
    case 'craft':
      return 'Làng nghề';
    case 'location':
      return 'Địa điểm';
    default:
      return 'Không rõ';
  }
}

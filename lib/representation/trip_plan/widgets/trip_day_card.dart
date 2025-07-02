import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/select_place_for_day_screen.dart';

class TripDayCard extends StatelessWidget {
  final DateTime day;
  final TripPlan trip;
  final List<dynamic> selectedItems;
  final List<dynamic> otherSelected;
  final void Function(List<dynamic>) onUpdate;

  const TripDayCard({
    super.key,
    required this.day,
    required this.trip,
    required this.selectedItems,
    required this.otherSelected,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE, dd MMM', 'vi').format(day);

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
            offset: Offset(0, 0.5.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dayName,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 1.h),
            Text("📍 Các điểm đến trong ngày hôm nay",
                style: TextStyle(fontSize: 13.sp)),
            SizedBox(height: 1.h),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  SelectPlaceForDayScreen.routeName,
                  arguments: {
                    'trip': trip,
                    'day': day,
                    'selected': selectedItems,
                    'allSelectedOtherDays': otherSelected,
                  },
                );
                if (result != null && result is List) {
                  onUpdate(result);
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
            if (selectedItems.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Column(
                children: selectedItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final type = item.runtimeType.toString();
                  String title = '';
                  String subtitle = '';
                  String? imageUrl;

                  if (type.contains('TripPlanLocation')) {
                    title = item.location?.name ?? 'Địa điểm không tên';
                    subtitle = '🏜️ Địa điểm tham quan';
                    imageUrl = item.location?.imgUrlFirst;
                  } else if (type.contains('TripPlanCuisine')) {
                    title = item.restaurant?.name ?? 'Nhà hàng không tên';
                    subtitle = '🍽️ Ẩm thực';
                    imageUrl = item.restaurant?.imgUrlFirst;
                  } else if (type.contains('TripPlanCraftVillage')) {
                    title = item.craftVillage?.name ?? 'Làng nghề không tên';
                    subtitle = '🧺 Làng nghề';
                    imageUrl = item.craftVillage?.imageList.first;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w)),
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(imageUrl,
                                width: 48, height: 48, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported, size: 32),
                      ),
                      title: Text(title, style: TextStyle(fontSize: 13.sp)),
                      subtitle:
                          Text(subtitle, style: TextStyle(fontSize: 11.5.sp)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final updatedList = List.of(selectedItems);
                          updatedList.removeAt(index);
                          onUpdate(updatedList);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
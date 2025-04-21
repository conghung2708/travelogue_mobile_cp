import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';

class SearchLocationCard extends StatelessWidget {
  final LocationModel locationModel;
  const SearchLocationCard({
    super.key,
    required this.locationModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2.sp,
            color: Colors.grey.shade700,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            locationModel.imgUrlFirst,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, url, error) => const SizedBox(
              width: 60,
              height: 60,
              child: Icon(
                Icons.error,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        locationModel.name ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        locationModel.description ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              place: locationModel,
            ),
          ),
        );
      },
    );
  }
}

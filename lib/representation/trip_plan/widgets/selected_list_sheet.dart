import 'package:flutter/material.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/trip_plan/itinerary_stop.dart';

class SelectedListSheet extends StatelessWidget {
  final List<LocationModel> selectedPlaces;
  final List<ItineraryStop> itinerary;
  final String Function(LocationModel) typeLabelBuilder;
  final void Function(int index) onRemoveAt;

  const SelectedListSheet({
    super.key,
    required this.selectedPlaces,
    required this.itinerary,
    required this.typeLabelBuilder,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
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
                    final stop = index < itinerary.length ? itinerary[index] : null;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(place.imgUrlFirst),
                        onBackgroundImageError: (_, __) {},
                        child: place.imgUrlFirst.isEmpty
                            ? const Icon(Icons.image, color: Colors.white)
                            : null,
                      ),
                      title: Text(place.name ?? ''),
                      subtitle: Text(
                        stop == null
                            ? typeLabelBuilder(place)
                            : '${typeLabelBuilder(place)} • '
                              'Đến ${_fmtTime(stop.arrival)} – Rời ${_fmtTime(stop.depart)} • '
                              '${(stop.travelMeters/1000).toStringAsFixed(1)} km / ${(stop.travelSeconds/60).round()} phút di chuyển',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveAt(index),
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
  }

  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

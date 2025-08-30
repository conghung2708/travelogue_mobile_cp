class LocationDto {
  final String id, name, description, address, category, districtName;
  final String openTime, closeTime; // "HH:mm:ss"
  final double? lat, lng;
  final String? imageUrl;

  LocationDto({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.districtName,
    required this.openTime,
    required this.closeTime,
    this.lat,
    this.lng,
    this.imageUrl,
  });

  Map<String, dynamic> forContext() => {
    "id": id,
    "name": name,
    "address": address,
    "category": category,
    "districtName": districtName,
    "openTime": openTime.length >= 5 ? openTime.substring(0,5) : openTime,
    "closeTime": closeTime.length >= 5 ? closeTime.substring(0,5) : closeTime,
    "imageUrl": imageUrl,
  };
}

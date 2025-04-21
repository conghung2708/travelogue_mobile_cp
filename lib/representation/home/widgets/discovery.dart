import 'package:flutter/material.dart';

import 'package:travelogue_mobile/core/constants/dimension_constants.dart';

class Discovery extends StatelessWidget {
  const Discovery({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Khám phá địa điểm theo thành phố",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCityChip("Hà Nội"),
                _buildCityChip("Hồ Chí Minh"),
                _buildCityChip("Đà Nẵng"),
                _buildCityChip("Nha Trang"),
                _buildCityChip("Phú Quốc"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCityChip(String city) {
  return GestureDetector(
    onTap: () {
      // Điều hướng đến danh sách địa điểm của thành phố
    },
    child: Container(
      margin: const EdgeInsets.only(right: kDefaultPadding / 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        city,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    ),
  );
}

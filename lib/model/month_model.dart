import 'package:flutter/material.dart';

class Month {
  final String name;
  final IconData icon;
  final int monthId;

  Month({required this.name, required this.icon, required this.monthId});
}

List<Month> months = [
  Month(name: 'Tất cả', icon: Icons.flag, monthId: 0),
  Month(name: 'Tháng 1', icon: Icons.ac_unit, monthId: 1),
  Month(name: 'Tháng 2', icon: Icons.favorite, monthId: 2),
  Month(name: 'Tháng 3', icon: Icons.wb_sunny, monthId: 3),
  Month(name: 'Tháng 4', icon: Icons.cloud, monthId: 4),
  Month(name: 'Tháng 5', icon: Icons.local_florist, monthId: 5),
  Month(name: 'Tháng 6', icon: Icons.beach_access, monthId: 6),
  Month(name: 'Tháng 7', icon: Icons.waves, monthId: 7),
  Month(name: 'Tháng 8', icon: Icons.sunny, monthId: 8),
  Month(name: 'Tháng 9', icon: Icons.local_florist, monthId: 9),
  Month(name: 'Tháng 10', icon: Icons.local_hotel, monthId: 10),
  Month(name: 'Tháng 11', icon: Icons.nature_people, monthId: 11),
  Month(name: 'Tháng 12', icon: Icons.ac_unit, monthId: 12),
];

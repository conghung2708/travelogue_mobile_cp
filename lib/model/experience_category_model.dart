import 'package:flutter/material.dart';

class ExperienceCategory {
  final String id;
  final String name;
  final IconData icon;

  ExperienceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  String toString() => 'ExperienceCategory(id: $id, name: $name)';
}

List<ExperienceCategory> experienceCategories = [
  ExperienceCategory(
    id: '',
    name: 'Tất cả',
    icon: Icons.travel_explore,
  ),
  ExperienceCategory(
    id: '08dd7324-76ee-46ee-8417-b412d694b580',
    name: 'Văn hóa',
    icon: Icons.account_balance,
  ),
  ExperienceCategory(
    id: '08dd7324-667e-4848-8911-e1ee756bf174',
    name: 'Ẩm thực',
    icon: Icons.restaurant_menu,
  ),
  ExperienceCategory(
    id: '08dd7324-720f-4371-8f97-73f3effe1148',
    name: 'Mua sắm',
    icon: Icons.shopping_bag,
  ),
  ExperienceCategory(
    id: '08dd7324-6d0d-45f3-8a1e-d0c9f8a9c646',
    name: 'Giải trí',
    icon: Icons.celebration,
  ),
  ExperienceCategory(
    id: '08dd7324-7b91-470d-8ef5-09b5fad07ec0',
    name: 'Thiên nhiên',
    icon: Icons.park,
  ),
];

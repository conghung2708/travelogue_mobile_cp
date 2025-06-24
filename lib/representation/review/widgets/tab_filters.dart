// 📁 lib/representation/review/widgets/tab_filters.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TabFilters extends StatelessWidget {
  final String selectedFilter;
  final void Function(String) onFilterChanged;

  const TabFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCustomTab("Phổ biến", 'popular'),
        _buildCustomTab("Mới nhất", 'newest'),
      ],
    );
  }

  Widget _buildCustomTab(String label, String value) {
    final bool isSelected = selectedFilter == value;

    return GestureDetector(
      onTap: () => onFilterChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF0077B6)])
              : null,
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13.5.sp,
          ),
        ),
      ),
    );
  }
}

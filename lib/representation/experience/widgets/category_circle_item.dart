import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryCircleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryCircleItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: 3,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10.sp),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/hobby_test_model.dart';

class HobbyChipRow extends StatelessWidget {
  final List<HobbyTestModel> hobbies;
  final MainAxisAlignment alignment;
  final Set<int> selectedIds;
  final Function(int, bool) onSelectionChanged;

  const HobbyChipRow({
    super.key,
    required this.hobbies,
    required this.alignment,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: alignment,
        children: hobbies.map((hobby) {
          final isSelected = selectedIds.contains(hobby.id);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 0.5.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 24.w),
              child: Tooltip(
                message: hobby.name,
                child: FilterChip(
                  avatar: isSelected
                      ? const Icon(Icons.favorite, color: Colors.white, size: 16)
                      : null,
                  label: Text(
                    hobby.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue[900],
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: Colors.white.withOpacity(0.95),
                  selectedColor: Colors.lightBlue.shade400,
                  showCheckmark: false,
                  elevation: isSelected ? 6 : 2,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.lightBlue
                          : Colors.blue.shade100,
                      width: 1.2,
                    ),
                  ),
                  onSelected: (selected) =>
                      onSelectionChanged(hobby.id, selected),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

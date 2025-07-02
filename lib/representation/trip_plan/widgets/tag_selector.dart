import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TagOption {
  final String label;
  final IconData icon;

  TagOption(this.label, this.icon);
}

class TagSelector extends StatefulWidget {
  final List<TagOption> tags;
  final ValueChanged<String> onTagSelected;

  const TagSelector({
    super.key,
    required this.tags,
    required this.onTagSelected,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  String? selectedLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.5.h,
      children: widget.tags.map((tag) {
        final isSelected = tag.label == selectedLabel;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() => selectedLabel = tag.label);
            widget.onTagSelected(tag.label);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.white,
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tag.icon,
                    size: 16, color: isSelected ? Colors.white : Colors.blue),
                SizedBox(width: 1.5.w),
                Text(
                  tag.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilterChipsBar extends StatelessWidget {
  final ValueListenable<int> selectedIndexListenable;

  const FilterChipsBar({
    super.key,
    required this.selectedIndexListenable,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'Tất cả', 'icon': Icons.all_inclusive},
      {'label': 'Di tích', 'icon': Icons.location_on},
      {'label': 'Ẩm thực', 'icon': Icons.restaurant},
      {'label': 'Làng nghề', 'icon': Icons.handyman},
    ];

    return ValueListenableBuilder<int>(
      valueListenable: selectedIndexListenable,
      builder: (_, selectedIndex, __) {
        return SizedBox(
          height: 10.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(filters.length, (i) {
              final selected = i == selectedIndex;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndexListenable is ValueNotifier<int>) {
                      (selectedIndexListenable as ValueNotifier<int>).value = i;
                    }
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            selected ? Colors.blueAccent : Colors.grey[200],
                        child: Icon(
                          filters[i]['icon'] as IconData,
                          color: selected ? Colors.white : Colors.black54,
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Text(
                        filters[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? Colors.blueAccent : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

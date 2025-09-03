import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const int kFilterAll     = 0;
const int kFilterHistory = 1;
const int kFilterFood    = 2;
const int kFilterCraft   = 3;
const int kFilterScenic  = 4;

class FilterChipsBar extends StatelessWidget {
  final ValueListenable<int> selectedIndexListenable;

  const FilterChipsBar({
    super.key,
    required this.selectedIndexListenable,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <({String label, IconData icon, int value})>[
      (label: 'Tất cả',  icon: Icons.all_inclusive,   value: kFilterAll),
      (label: 'Di tích', icon: Icons.account_balance, value: kFilterHistory),
      (label: 'Danh lam',icon: Icons.terrain,         value: kFilterScenic),
      (label: 'Ẩm thực', icon: Icons.restaurant,      value: kFilterFood),
      (label: 'Làng nghề', icon: Icons.handyman,      value: kFilterCraft),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: selectedIndexListenable,
      builder: (_, selectedValue, __) {
        return SizedBox(
          height: 10.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(filters.length, (i) {
                final f = filters[i];
                final selected = f.value == selectedValue;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: GestureDetector(
                    onTap: () {
                      final vn = selectedIndexListenable as ValueNotifier<int>?;
                      vn?.value = f.value;
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              selected ? Colors.blueAccent : Colors.grey[200],
                          child: Icon(
                            f.icon,
                            color: selected ? Colors.white : Colors.black54,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          f.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? Colors.blueAccent : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

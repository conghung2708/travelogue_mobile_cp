import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';

class BuildItemCategory extends StatelessWidget {
  final Widget icon;
  final Color color;
  final Function() onTap;
  final String title;
  final bool isCLicked;

  const BuildItemCategory({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.title,
    this.isCLicked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: kMediumPadding,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(kItemPadding),
              border: isCLicked
                  ? Border.all(
                      width: 3.sp,
                      color: color,
                    )
                  : null,
            ),
            child: icon,
          ),
          const SizedBox(
            height: kItemPadding,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isCLicked ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

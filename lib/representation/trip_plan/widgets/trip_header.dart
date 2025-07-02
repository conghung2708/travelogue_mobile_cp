import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';

class TripHeader extends StatelessWidget {
  final TripPlan trip;
  final bool isEditingName;
  final TextEditingController nameController;
  final VoidCallback onEditTap;

  const TripHeader({
    super.key,
    required this.trip,
    required this.isEditingName,
    required this.nameController,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 26.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.w),
              bottomRight: Radius.circular(6.w),
            ),
            image: DecorationImage(
              image: const AssetImage(AssetHelper.img_dien_son_01),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.25),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 2.h,
          left: 4.w,
          right: 4.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.travel_explore, color: Colors.lightBlue, size: 18.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: nameController,
                        autofocus: true,
                        onSubmitted: (_) => onEditTap(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Pattaya",
                        ),
                        decoration: const InputDecoration(
                          hintText: "Nhập tên hành trình...",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        trip.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Pattaya",
                          shadows: const [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                offset: Offset(0, 2)),
                          ],
                        ),
                      ),
              ),
              IconButton(
                onPressed: onEditTap,
                icon: Icon(
                  isEditingName ? Icons.close : Icons.edit,
                  color: Colors.white,
                  size: 18.sp,
                ),
              )
            ],
          ),
        ),

        // 🔹 Avatar + Mời bạn đồng hành
        Positioned(
          top: 5.h,
          left: 4.w,
          right: 4.w,
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.sp,
                backgroundImage: const AssetImage(AssetHelper.avatar),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.group_add, size: 13.sp, color: Colors.white),
                    SizedBox(width: 1.w),
                    Text(
                      "Mời bạn đồng hành",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

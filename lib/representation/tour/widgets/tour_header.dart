import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/string_helper.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class TourHeader extends StatelessWidget {
  const TourHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box(StorageKey.boxUser).listenable(keys: [StorageKey.account]),
      builder: (context, box, _) {
        final user = UserLocal().getUser();

        final rawName = (user.fullName?.trim().isNotEmpty == true)
            ? user.fullName!.trim()
            : (user.userName ?? '');
        final displayName = rawName.isEmpty
            ? 'Bạn'
            : (StringHelper().formatUserName(rawName) ?? 'Bạn');

        final avatarUrl = (user.avatarUrl ?? '').trim();

        return Row(
          children: [
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: ClipOval(
                child: avatarUrl.isNotEmpty
                    ? Image.network(
                        avatarUrl,
                        width: 10.w,
                        height: 10.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AssetHelper.img_avatar, 
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AssetHelper.img_avatar, 
                        width: 10.w,
                        height: 10.w,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào, $displayName",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Pattaya",
                  ),
                ),
                Text(
                  "Khám phá hành trình tuyệt vời",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            const Spacer(),
            if (rawName.isNotEmpty)
              Icon(Icons.notifications_none, size: 6.w, color: Colors.black87),
          ],
        );
      },
    );
  }
}

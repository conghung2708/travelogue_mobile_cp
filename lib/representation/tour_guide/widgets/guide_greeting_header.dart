import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/string_helper.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class GuideGreetingHeader extends StatelessWidget {
  const GuideGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(StorageKey.boxUser)
          .listenable(keys: [StorageKey.account]),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào, $displayName",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Pattaya",
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Chọn hướng dẫn viên đồng hành cùng bạn",
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

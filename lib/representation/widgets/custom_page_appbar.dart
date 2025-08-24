import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';

class CustomPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomPageAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white10,
      elevation: 0,
      toolbarHeight: 60,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ArrowBackButton(onPressed: onBack ?? () => Navigator.of(context).pop()),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pattaya',
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box(StorageKey.boxUser)
                .listenable(keys: [StorageKey.account]),
            builder: (context, box, _) {
              final url = (UserLocal().getUser().avatarUrl ?? '').trim();

              return ClipOval(
                child: url.isNotEmpty
                    ? Image.network(
                        url,
                        width: 40, height: 40, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AssetHelper.img_avatar,
                          width: 40, height: 40, fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AssetHelper.img_avatar,
                        width: 40, height: 40, fit: BoxFit.cover,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

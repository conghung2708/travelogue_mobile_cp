import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';

class FavoriteLocationScreen extends StatelessWidget {
  static const String routeName = '/favourite_location_screen';

  const FavoriteLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF3A7DFF); // xanh dương nhạt
    final Color chipBg = const Color(0xFFEAF2FF);   // nền nhạt cho chip

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black12,
        centerTitle: true,
        foregroundColor: Colors.black87,
        title: const Text(
          'Địa điểm yêu thích',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // lấy list từ state (giống code của bạn)
          final List<LocationModel> locationFavorite =
              state.props[3] as List<LocationModel>;

          if (locationFavorite.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border_rounded,
                        size: 44.sp, color: primary.withOpacity(.4)),
                    SizedBox(height: 1.h),
                    Text(
                      'Chưa có địa điểm nào trong danh sách yêu thích',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 2.5.h,
              childAspectRatio: 0.72,
            ),
            itemCount: locationFavorite.length,
            itemBuilder: (context, index) {
              final location = locationFavorite[index];

              // ✅ KHÔNG dùng medias.first -> tránh "Bad state: No element"
              final imageUrl = location.imgUrlFirst;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    PlaceDetailScreen.routeName,
                    arguments: location,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0x11000000)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Stack(
                          children: [
                            // ImageNetworkCard đã có errorBuilder nội bộ, nhưng
                            // mình vẫn để placeholder khi url rỗng để chắc chắn.
                            if (imageUrl.isNotEmpty)
                              ImageNetworkCard(
                                url: imageUrl,
                                height: 17.5.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                height: 17.5.h,
                                width: double.infinity,
                                color: chipBg,
                                alignment: Alignment.center,
                                child: Icon(Icons.image_outlined,
                                    color: primary.withOpacity(.50), size: 26),
                              ),

                            // Nút “tim”
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(1.6.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: primary,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nội dung
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(3.8.w, 1.6.h, 3.8.w, 1.4.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tên
                              Text(
                                location.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                  color: const Color(0xFF0B1B3F),
                                ),
                              ),
                              SizedBox(height: 0.8.h),

                              // Chip loại địa điểm (dùng category)
                              if ((location.category ?? '').isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.6.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipBg,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: primary.withOpacity(.25),
                                    ),
                                  ),
                                  child: Text(
                                    location.category!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.8.sp,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                ),

                              SizedBox(height: 1.0.h),

                              // Mô tả ngắn
                              Expanded(
                                child: Text(
                                  location.description ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.8.sp,
                                    color: Colors.black54,
                                    height: 1.35,
                                  ),
                                ),
                              ),

                              // Khu vực (nếu muốn hiện)
                              if ((location.districtName ?? '').isNotEmpty) ...[
                                SizedBox(height: 0.6.h),
                                Row(
                                  children: [
                                    Icon(Icons.place_rounded,
                                        size: 14.sp, color: Colors.black38),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Text(
                                        location.districtName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/home/screens/place_detail_screen.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class RotatingSurpriseButton extends StatefulWidget {
  const RotatingSurpriseButton({super.key});

  @override
  State<RotatingSurpriseButton> createState() => _RotatingSurpriseButtonState();
}

class _RotatingSurpriseButtonState extends State<RotatingSurpriseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showRandomLocationPreview() async {
    final state = AppBloc.homeBloc.state;
    final List<LocationModel> places = state.props[1] as List<LocationModel>;

    if (places.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có địa điểm để khám phá.')),
      );
      return;
    }

    final random = Random();
    final randomPlace = places[random.nextInt(places.length)];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDiscoveryDialog(),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context); // Close loading

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: LocationPreview(
          location: randomPlace,
          onViewDetail: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(
              PlaceDetailScreen.routeName,
              arguments: randomPlace,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: GestureDetector(
              onTap: _showRandomLocationPreview,
              child: Container(
                width: 13.w,
                height: 13.w,
                decoration: BoxDecoration(
                  gradient: Gradients.defaultGradientBackground,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.explore, color: Colors.white, size: 6.w),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingDiscoveryDialog extends StatelessWidget {
  const _LoadingDiscoveryDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.h,
              child: Lottie.asset(
                'assets/animations/map_discovering.json',
                repeat: true,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '🧭 Địa điểm khám phá hôm nay là...',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationPreview extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onViewDetail;

  const LocationPreview({
    required this.location,
    required this.onViewDetail,
  });

  static final List<String> travelQuotes = [
    "“Đi để tìm lại chính mình.” 🌿",
    "“Mỗi hành trình là một câu chuyện.” 📖",
    "“Cuộc sống là những chuyến đi.” 🚀",
    "“Chạm vào vẻ đẹp vùng đất mới.” ✨",
    "“Khám phá, cảm nhận, và sống thật sâu.” 🌄",
  ];

  @override
  Widget build(BuildContext context) {
    final quote = (travelQuotes..shuffle()).first;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 65.h,
        minWidth: 80.w,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ảnh địa điểm
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Image.network(
                  location.imgUrlFirst,
                  height: 18.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: kMediumPadding, bottom: 0, left: 0, right: 80),
                child: TitleWithCustoneUnderline(
                  text: '🧭 Địa điểm: ',
                  text2: location.name ?? '',
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_quote,
                            size: 20, color: ColorPalette.subTitleColor),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            quote,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                              color: ColorPalette.subTitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      location.description ?? 'Đang cập nhật...',
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onViewDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.explore, color: Colors.white),
                        label: Text(
                          "Khám phá ngay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

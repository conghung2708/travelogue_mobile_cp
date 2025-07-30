import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/order/screens/order_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_mansory_grid.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});
  static const String routeName = '/tour';

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _folderKey = GlobalKey();
  bool _hasShownShowcase = false;
  Map<String, dynamic>? _pendingPayment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

context.read<TourBloc>().add(const GetAllToursEvent());

  }

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (_hasShownShowcase) return;

  final args = ModalRoute.of(context)?.settings.arguments;
  if (args is Map<String, dynamic>) {
    if (args['justBooked'] == true) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && _folderKey.currentContext != null) {
          ShowCaseWidget.of(context).startShowCase([_folderKey]);
          _hasShownShowcase = true;
        }
      });
    }

    if (args['pendingPayment'] == true) {
      final DateTime startTime = DateTime.tryParse(args['startTime']) ?? DateTime.now();
      final Duration diff = DateTime.now().difference(startTime);

      if (diff.inMinutes < 5) {
        _pendingPayment = args;
      } else {
        _pendingPayment = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Liên kết thanh toán đã hết hạn. Vui lòng đặt lại.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        });
      }
    }
  }
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 2.5.h),
              _buildSearchField(),
              if (_pendingPayment != null) _buildPendingPaymentBanner(),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                text: "Chuyến đi ",
                text2: "cá nhân",
              ),
              SizedBox(height: 2.h),
              _buildTripPlanBanner(),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                text: "Các tour ",
                text2: "gợi ý",
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: BlocBuilder<TourBloc, TourState>(
                  builder: (context, state) {
                    if (state is TourLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetToursSuccess) {
  final tours = state.tours;
  return TourMasonryGrid(tours: tours); 
}
 else if (state is TourError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingPaymentBanner() {
    return Container(
      margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade100.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              "Bạn còn một tour chưa thanh toán.\nNhấn để tiếp tục hoàn tất đặt chỗ ✨",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourQrPaymentScreen(
                    tour: TourModel.fromJson(_pendingPayment!['tour']),
                    schedule: TourScheduleModel.fromJson(_pendingPayment!['schedule']),
                    departureDate: DateTime.parse(_pendingPayment!['departureDate']),
                    adults: _pendingPayment!['adults'],
                    children: _pendingPayment!['children'],
                    totalPrice: _pendingPayment!['totalPrice'],
                     startTime: DateTime.parse(_pendingPayment!['startTime']),
                     checkoutUrl: _pendingPayment!['paymentLink'], 
                     
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Tiếp tục",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(backgroundImage: AssetImage(AssetHelper.avatar)),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xin chào, Hưng",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                fontFamily: "Pattaya",
              ),
            ),
            Text(
              "Khám phá hành trình tuyệt vời",
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
              ),
            )
          ],
        ),
        const Spacer(),
        Showcase.withWidget(
          key: _folderKey,
          height: 140,
          width: 270,
          container: _buildShowcasePopup(),
          overlayColor: Colors.black,
          overlayOpacity: 0.6,
          blurValue: 2.5,
          disableMovingAnimation: true,
          targetPadding: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {},
            child: _buildShowcaseButton(),
          ),
        )
      ],
    );
  }

  Widget _buildShowcasePopup() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_copy,
                  color: ColorPalette.yellowColor, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Tour đã đặt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Nhấn để xem các tour bạn đã đặt và theo dõi hành trình của mình.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowcaseButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: Gradients.defaultGradientBackground,
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        Icon(
          Icons.folder_copy_outlined,
          color: Colors.white,
          size: 6.w,
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm kiếm tour...",
          prefixIcon: Icon(Icons.search, size: 6.w),
          suffixIcon: Icon(Icons.filter_list, size: 6.w),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }

  Widget _buildTripPlanBanner() {
    return Container(
      height: 20.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        image: const DecorationImage(
          image: AssetImage(AssetHelper.img_ex_ba_den),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.15),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Icon(Icons.auto_awesome,
                      color: Colors.deepPurple, size: 6.w),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Colors.cyanAccent,
                                  Colors.blueAccent
                                ],
                                stops: [
                                  (_controller.value - 0.3).clamp(0.0, 1.0),
                                  _controller.value.clamp(0.0, 1.0)
                                ],
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              );
                            },
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              "Tạo hành trình riêng của bạn",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Pattaya",
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Cá nhân hóa trải nghiệm du lịch theo sở thích, thời gian và ngân sách của bạn.",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyTripPlansScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.lightBlueAccent,
                                Colors.blueAccent
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Text(
                            "Bắt đầu ngay",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

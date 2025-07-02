import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_detail_content.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_detail_screen_background.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class FestivalDetailScreen extends StatefulWidget {
  final EventModel festival;
  static const routeName = '/festival_detail_screen';
  const FestivalDetailScreen({super.key, required this.festival});

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreenState();
}

class _FestivalDetailScreenState extends State<FestivalDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _interested = false;
  late AnimationController _glowController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE3F2FD),
                ),
                padding: EdgeInsets.all(3.h),
                child:
                    Icon(Icons.favorite, color: Colors.blueAccent, size: 40.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                'Bạn đã quan tâm sự kiện này!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 2.5.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confettiController.play();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: Text('Đã hiểu',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final festival = ModalRoute.of(context)!.settings.arguments as EventModel;
    final now = DateTime.now();
    final start = festival.startDate ?? now;
    final isUpcoming = now.isBefore(start);

    return Scaffold(
      body: Provider<EventModel>.value(
        value: festival,
        child: Stack(
          children: [
            const FestivalDetailScreenBackground(),
            Positioned(
              top: 30.sp,
              left: 17.sp,
              child: ArrowBackButton(onPressed: () {
                Navigator.of(context).pop();
              }),
            ),
            const FestivalDetailContent(),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 10,
                minBlastForce: 5,
                emissionFrequency: 0.1,
                numberOfParticles: 10,
                gravity: 0.3,
                colors: const [
                  Colors.blueAccent,
                  Colors.lightBlue,
                  Colors.cyan,
                ],
              ),
            ),
            if (isUpcoming)
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _interested = !_interested;
                        if (_interested) {
                          _showCustomDialog();
                        }
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        final scale = 1 + 0.05 * sin(_glowController.value * 2 * pi);
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _interested ? Icons.check_circle : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _interested ? "Đã quan tâm" : "Quan tâm",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}

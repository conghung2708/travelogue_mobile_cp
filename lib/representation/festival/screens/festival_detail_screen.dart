import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_detail_content.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_detail_screen_background.dart';

class FestivalDetailScreen extends StatelessWidget {
  final EventModel festival;
  static const routeName = '/festival_detail_screen';
  const FestivalDetailScreen({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    final festival = ModalRoute.of(context)!.settings.arguments as EventModel;

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
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/representation/event/widgets/event_content.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  static const routeName = '/event_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Thông",
                  style: TextStyle(
                    // fontWeight: FontWeight.w700,
                    fontFamily: "Pattaya",
                    fontSize: 20.sp,
                  ),
                ),
                Text(
                  " Tin",
                  style: TextStyle(
                    color: Colors.blue,
                    // fontWeight: FontWeight.w700,
                    fontFamily: "Pattaya",
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const EventContent(showCategory: true),
    );
  }
}

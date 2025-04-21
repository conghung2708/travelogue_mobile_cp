import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';

class TitleWithCustoneUnderline extends StatelessWidget {
  final String text;
  final String text2;

  const TitleWithCustoneUnderline({
    super.key,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.sp,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
              // vertical: 2.h,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  // color: Colors.black87,
                  color: Colors.black87,
                  fontFamily: "Pattaya",
                ),
                children: [
                  TextSpan(
                    text: text,
                  ),
                  TextSpan(
                    text: text2,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15.sp,
            right: 0,
            child: Container(
              height: 7,
              color: Colors.blue.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}

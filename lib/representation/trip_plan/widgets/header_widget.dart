import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Image.network(
              'https://i.pravatar.cc/300',
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi Traveler,',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: "Pattaya")),
                Text('Đây là những hành trình gần đây của bạn',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.search, size: 7.w),
          SizedBox(width: 2.w),
          Icon(Icons.more_vert, size: 7.w),
        ],
      ),
    );
  }
}
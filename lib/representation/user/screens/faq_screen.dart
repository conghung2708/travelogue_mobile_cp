import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/faq_data.dart';

class FaqScreen extends StatelessWidget {
  static const routeName = '/faq_screen';
  const FaqScreen({super.key});

  // Accent nhẹ nhàng
  static const _blue = Color(0xFF42A5F5);       // xanh dương nhạt
  static const _blueBorder = Color(0xFFE3F2FD); // viền rất nhạt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // nền trắng
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'Câu hỏi thường gặp',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: "Pattaya",
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(5.w),
          itemCount: faqItems.length,
          itemBuilder: (context, index) {
            final item = faqItems[index];
            return _buildFaqCard(item.question, item.answer);
          },
        ),
      ),
    );
  }

  Widget _buildFaqCard(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _blueBorder), // viền xanh nhạt
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // rất nhẹ
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          childrenPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          title: Row(
            children: [
              Icon(Icons.question_answer_rounded, color: _blue, size: 16.sp), // icon xanh dương nhạt
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.expand_more, color: _blue, size: 18.sp), // mũi tên xanh nhạt
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

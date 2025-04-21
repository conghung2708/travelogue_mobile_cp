import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/faq_data.dart';

class FaqScreen extends StatelessWidget {
  static const routeName = '/faq_screen';

  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'Câu hỏi thường gặp',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: "Pattaya",
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
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          childrenPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          title: Row(
            children: [
              Icon(Icons.question_answer_rounded, color: Colors.teal, size: 16.sp),
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
          trailing: Icon(Icons.expand_more, color: Colors.teal, size: 18.sp),
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

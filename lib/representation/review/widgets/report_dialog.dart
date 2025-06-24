import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class ReportDialog<T> extends StatefulWidget {
  final T review;
  final void Function(T, String) onSubmit;

  const ReportDialog({
    super.key,
    required this.review,
    required this.onSubmit,
  });

  @override
  State<ReportDialog<T>> createState() => _ReportDialogState<T>();
}

class _ReportDialogState<T> extends State<ReportDialog<T>> {
  final List<String> reasons = [
    "🗯️ Ngôn từ không phù hợp",
    "📢 Spam hoặc quảng cáo",
    "⚠️ Nội dung gây hiểu nhầm",
    "❓ Khác...",
  ];

  final Set<String> selectedReasons = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
      title: Center(
        child: Text(
          "📝 Lý do báo cáo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: ColorPalette.primaryColor,
            fontFamily: "Pattaya",
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: reasons.length,
          separatorBuilder: (_, __) => SizedBox(height: 1.h),
          itemBuilder: (_, i) {
            final reason = reasons[i];
            return CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: selectedReasons.contains(reason)
                  ? const Color(0xFFE0F7FA)
                  : const Color(0xFFF6F6F6),
              title: Text(reason, style: TextStyle(fontSize: 14.sp)),
              value: selectedReasons.contains(reason),
              activeColor: ColorPalette.primaryColor,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedReasons.add(reason);
                  } else {
                    selectedReasons.remove(reason);
                  }
                });
              },
            );
          },
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "❌ Hủy",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
        InkWell(
          onTap: selectedReasons.isNotEmpty
              ? () {
                  widget.onSubmit(widget.review, selectedReasons.join(", "));
                  Navigator.pop(context);
                }
              : null,
          child: Ink(
            decoration: BoxDecoration(
              gradient: selectedReasons.isEmpty
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : Gradients.defaultGradientBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
            child: Text(
              "📨 Gửi báo cáo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

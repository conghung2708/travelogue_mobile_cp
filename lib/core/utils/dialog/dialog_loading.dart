import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showDialogLoading(BuildContext context, {String? title}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color(0x80000000),
    useRootNavigator: true,
    routeSettings: const RouteSettings(name: "Dialog_Loading_Route"),
    builder: (_) => PopScope(
      canPop: false,
      child: CircleLoading(title: title),
    ),
  );
}

class CircleLoading extends StatelessWidget {
  final String? title;
  const CircleLoading({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          child: Image.asset(
            'assets/images/img_loading.gif',
            height: 30.sp,
            width: 30.sp,
            fit: BoxFit.fitWidth,
            scale: 0.2,
          ),
        ),
      ],
    );
  }
}

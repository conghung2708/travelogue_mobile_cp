// lib/features/tour/presentation/widgets/payment_webview.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final bool hasController;
  final WebViewController? controller;
  final bool isLoading;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  const PaymentWebView({
    super.key,
    required this.hasController,
    required this.controller,
    required this.isLoading,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (hasController && controller != null)
          WebViewWidget(
            controller: controller!,
            gestureRecognizers: gestureRecognizers,
          )
        else
          const SizedBox.shrink(),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

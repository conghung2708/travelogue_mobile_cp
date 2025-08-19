
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewSection extends StatelessWidget {
  final WebViewController? controller; 
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final bool isLoading;

  const PaymentWebViewSection({
    super.key,
    required this.controller,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (controller != null)
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

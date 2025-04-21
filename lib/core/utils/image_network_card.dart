import 'package:flutter/material.dart';

class ImageNetworkCard extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageNetworkCard({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      cacheWidth: 300,
      cacheHeight: 300,
      errorBuilder: (context, url, error) => Image.asset(
        'assets/images/img_default.png',
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

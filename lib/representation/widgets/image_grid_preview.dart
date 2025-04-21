import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/representation/widgets/photo_gallery_viewer.dart';

class ImageGridPreview extends StatelessWidget {
  final List<String> images;
  final int maxImages;

  const ImageGridPreview({
    super.key,
    required this.images,
    this.maxImages = 3,
  });

  void _openPhotoGallery(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoGalleryViewer(
          images: images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = images.length - maxImages;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.only(top: 12.sp),
      itemCount: images.length > maxImages ? maxImages : images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openPhotoGallery(context, index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageNetworkCard(url: images[index], fit: BoxFit.cover),
              ),
              if (index == maxImages - 1 && remaining > 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+$remaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

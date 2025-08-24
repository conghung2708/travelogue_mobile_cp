import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';

class ExperienceDetailScreen extends StatefulWidget {
  static const routeName = '/experience_detail';
  final NewsModel experience;

  const ExperienceDetailScreen({super.key, required this.experience});

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  Future<void> _speakContent() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
      return;
    }
    if (widget.experience.content?.isNotEmpty == true) {
      await flutterTts.setLanguage("vi-VN");
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1.0);
      setState(() => isSpeaking = true);
      await flutterTts.speak(widget.experience.content!);
      flutterTts.setCompletionHandler(() {
        setState(() => isSpeaking = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 32.h,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    exp.imgUrlFirst,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(AssetHelper.img_logo_tay_ninh),
                  ),
                  // gradient dưới để chữ nổi
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // title + badge
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            if ((exp.categoryName ?? '').isNotEmpty)
                              _CategoryBadge(
                                text: exp.categoryName!,
                                bg: Colors.white.withOpacity(0.95),
                                fg: Colors.blueAccent,
                              ),
                            if ((exp.locationName ?? '').isNotEmpty)
                              _CategoryBadge(
                                text: exp.locationName!,
                                bg: Colors.white.withOpacity(0.95),
                                fg: Colors.green,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exp.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author + date + đọc
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage(AssetHelper.img_logo_tay_ninh),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Sở du lịch Tây Ninh",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _speakContent,
                        icon: Icon(
                          isSpeaking ? Icons.stop : Icons.volume_up,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${exp.createdTime != null ? "${exp.createdTime!.day}/${exp.createdTime!.month}/${exp.createdTime!.year}" : ''}",
                    style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  ),

                  const SizedBox(height: 20),
                  Html(
                    data: exp.content ?? '',
                    style: {
                      "body": Style(
                        fontSize: FontSize(14.sp),
                        lineHeight: LineHeight(1.6),
                        color: Colors.black87,
                      ),
                    },
                  ),

                  if (exp.listImages.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      "📸 Hình ảnh",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: exp.listImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () =>
                                _openPhotoGallery(context, exp.listImages, i),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ImageNetworkCard(
                                url: exp.listImages[i],
                                width: 160,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPhotoGallery(
      BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            pageController: PageController(initialPage: initialIndex),
            backgroundDecoration:
                const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _CategoryBadge({
    required this.text,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

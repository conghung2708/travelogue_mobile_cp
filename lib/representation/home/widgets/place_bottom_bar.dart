import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/config/app_env.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/hotel/widgets/hotels.dart';
import 'package:travelogue_mobile/representation/restaurent/widgets/restaurents.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' as vietmap;

// Gallery widgets (của bạn)
import 'package:travelogue_mobile/representation/widgets/photo_gallery_viewer.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class PlaceBottomBar extends StatefulWidget {
  final LocationModel place;

  const PlaceBottomBar({super.key, required this.place});

  @override
  State<PlaceBottomBar> createState() => _PlaceBottomBarState();
}

class _PlaceBottomBarState extends State<PlaceBottomBar> {
  vietmap.VietmapController? _controller;
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  final PageController _heroPager = PageController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }
    if ((widget.place.content ?? '').isNotEmpty) {
      await _tts.setLanguage('vi-VN');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      if (mounted) setState(() => _isSpeaking = true);
      await _tts.speak(widget.place.content!);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _isSpeaking = false);
      });
    }
  }

  String _formatOpenRange(LocationModel p) {
    if ((p.openTime ?? '').isEmpty && (p.closeTime ?? '').isEmpty) {
      return 'Chưa cập nhật giờ mở cửa';
    }
    if ((p.openTime ?? '').isEmpty) return 'Đến ${p.closeTime}';
    if ((p.closeTime ?? '').isEmpty) return 'Từ ${p.openTime}';
    return '${p.openTime} – ${p.closeTime}';
  }

  bool _isOpenNow(LocationModel p) {
    try {
      if ((p.openTime ?? '').isEmpty || (p.closeTime ?? '').isEmpty)
        return false;
      final now = TimeOfDay.fromDateTime(DateTime.now());
      final ot = _parseHHmm(p.openTime!);
      final ct = _parseHHmm(p.closeTime!);
      final nowM = now.hour * 60 + now.minute;
      final oM = ot.hour * 60 + ot.minute;
      final cM = ct.hour * 60 + ct.minute;
      if (oM <= cM) {
        return nowM >= oM && nowM < cM;
      } else {
        return nowM >= oM || nowM < cM;
      }
    } catch (_) {
      return false;
    }
  }

  TimeOfDay _parseHHmm(String s) {
    final parts = s.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = (parts.length > 1) ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: h, minute: m);
  }

  // Widget _buildStars(int? rating) {
  //   final r = (rating ?? 0).clamp(0, 5);
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: List.generate(5, (i) {
  //       return Icon(
  //         i < r ? Icons.star_rounded : Icons.star_border_rounded,
  //         size: 18,
  //         color: Colors.amber.shade600,
  //       );
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    final images = p.listImages;
    final isOpen = _isOpenNow(p);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.35,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 12, offset: Offset(0, -6))
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 36.h,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _heroPager,
                          itemCount: images.isEmpty ? 1 : images.length,
                          itemBuilder: (_, i) {
                            final url = images.isEmpty ? '' : images[i];
                            return GestureDetector(
                              onTap: () {
                                if (images.isEmpty) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PhotoGalleryViewer(
                                      images: images,
                                      initialIndex: i,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (url.isNotEmpty)
                                    Image.network(url, fit: BoxFit.cover)
                                  else
                                    Image.asset(
                                      AssetHelper.img_logo_tay_ninh,
                                      fit: BoxFit.cover,
                                    ),
                                  const Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black54
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          right: 14,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  p.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _RoundAction(
                                tooltip:
                                    _isSpeaking ? 'Dừng đọc' : 'Đọc nội dung',
                                onTap: _toggleSpeak,
                                child: AvatarGlow(
                                  animate: _isSpeaking,
                                  glowColor: _isSpeaking
                                      ? Colors.redAccent
                                      : Colors.blueAccent,
                                  child: Icon(
                                    _isSpeaking
                                        ? Icons.stop
                                        : Icons.volume_up_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ======== Body ========
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.sp, vertical: 12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating + chips
                        Row(
                          children: [
                            // _buildStars(p.rating),
                            // const SizedBox(width: 8),
                            // Text('${p.rating ?? 0}/5',
                            //     style: TextStyle(color: Colors.grey.shade700)),
                            if ((p.category ?? '').isNotEmpty)
                              _Chip(
                                  text: p.category!,
                                  icon: Icons.category_outlined),
                            const Spacer(),

                            if ((p.districtName ?? '').isNotEmpty) ...[
                              const SizedBox(width: 6),
                              _Chip(
                                  text: p.districtName!,
                                  icon: Icons.location_city_outlined),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: (isOpen ? Colors.green : Colors.red)
                                .withOpacity(0.08),
                            border: Border.all(
                              color: (isOpen ? Colors.green : Colors.red)
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isOpen
                                    ? Icons.lock_open_rounded
                                    : Icons.lock_outline_rounded,
                                size: 18,
                                color: isOpen ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isOpen ? 'Đang mở' : 'Đang đóng',
                                style: TextStyle(
                                  color: isOpen ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('  •  ${_formatOpenRange(p)}',
                                  style:
                                      TextStyle(color: Colors.grey.shade700)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Địa chỉ
                        if ((p.address ?? '').isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.place_outlined,
                                  size: 20, color: Colors.blueGrey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  p.address!,
                                  style: const TextStyle(
                                      fontSize: 14.5, height: 1.35),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 14),

                        // Nội dung (HTML) – click ảnh mở gallery
                        if ((p.content ?? '').isNotEmpty)
                          Html(
                            data: p.content!,
                            style: {
                              "body": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontSize: FontSize(15),
                                color: Colors.black87,
                                lineHeight: const LineHeight(1.5),
                                textAlign: TextAlign.justify,
                              ),
                              "p": Style(margin: Margins.only(bottom: 10)),
                              "h1": Style(
                                  fontSize: FontSize(22),
                                  fontWeight: FontWeight.w800),
                              "h2": Style(
                                  fontSize: FontSize(20),
                                  fontWeight: FontWeight.w700),
                              "img": Style(margin: Margins.only(bottom: 8)),
                            },
                            extensions: [
                              TagExtension(
                                tagsToExtend: {'img'},
                                builder: (ext) {
                                  final src = ext.attributes['src'] ?? '';
                                  final all = images;
                                  final index = all.indexOf(src);
                                  return GestureDetector(
                                    onTap: () {
                                      final gallery = index >= 0 ? all : [src];
                                      final init = index >= 0 ? index : 0;
                                      final ctx = ext.buildContext;
                                      if (ctx != null) {
                                        Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                            builder: (_) => PhotoGalleryViewer(
                                              images: gallery,
                                              initialIndex: init,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                          Image.network(src, fit: BoxFit.cover),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                        // Lưới ảnh (dùng widget của bạn)
                        if (images.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            'Hình ảnh',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          ImageGridPreview(
                            images: images,
                            maxImages: 6, // tuỳ chỉnh
                          ),
                        ],

                        const SizedBox(height: 18),

                        // Nút hành động nhanh
                        Row(
                          children: [
                            Expanded(
                              child: _PrimaryButton(
                                icon: Icons.travel_explore_rounded,
                                label: 'Xem trên bản đồ',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    VietMapLocationScreen.routeName,
                                    arguments: vietmap.LatLng(
                                      p.latitude ?? 10.762622,
                                      p.longitude ?? 106.660172,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _SecondaryButton(
                                icon: _isSpeaking
                                    ? Icons.stop_circle_outlined
                                    : Icons.volume_up_rounded,
                                label: _isSpeaking ? 'Dừng đọc' : 'Đọc',
                                onPressed: _toggleSpeak,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Gợi ý gần địa điểm
                        const Hotels(),
                        const SizedBox(height: 6),
                        const Restaurents(),

                        const SizedBox(height: 16),

                        // Bản đồ preview (không hiển thị kinh/vĩ độ text)
                        Container(
                          width: double.infinity,
                          height: 60.sp,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              vietmap.VietmapGL(
                                myLocationEnabled: false,
                                trackCameraPosition: true,
                                rotateGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                zoomGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                styleString:
                                    'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=${AppEnv.vietmapKey}',
                                initialCameraPosition: vietmap.CameraPosition(
                                  target: vietmap.LatLng(
                                    p.latitude ?? 10.762622,
                                    p.longitude ?? 106.660172,
                                  ),
                                  zoom: 12,
                                ),
                                onMapCreated: (c) =>
                                    setState(() => _controller = c),
                                onMapClick: (pt, latlng) => Navigator.pushNamed(
                                  context,
                                  VietMapLocationScreen.routeName,
                                  arguments: vietmap.LatLng(
                                    p.latitude ?? 10.762622,
                                    p.longitude ?? 106.660172,
                                  ),
                                ),
                              ),
                              if (_controller != null)
                                vietmap.MarkerLayer(
                                  markers: [
                                    vietmap.Marker(
                                      alignment: Alignment.bottomCenter,
                                      height: 34,
                                      width: 34,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 34,
                                      ),
                                      latLng: vietmap.LatLng(
                                        p.latitude ?? 10.762622,
                                        p.longitude ?? 106.660172,
                                      ),
                                    ),
                                  ],
                                  mapController: _controller!,
                                ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 6)
                                    ],
                                  ),
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.open_in_full_rounded),
                                    tooltip: 'Mở rộng bản đồ',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        VietMapLocationScreen.routeName,
                                        arguments: vietmap.LatLng(
                                          p.latitude ?? 10.762622,
                                          p.longitude ?? 106.660172,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.sp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ======== Small UI building blocks ========
class _Chip extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Chip({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade800),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? tooltip;
  const _RoundAction({required this.child, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white30),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _SecondaryButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

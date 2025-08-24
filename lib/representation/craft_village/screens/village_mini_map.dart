import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' as vietmap;

class VillageMiniMap extends StatefulWidget {
  const VillageMiniMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.styleUrl,
    this.onTap,
  });

  final double lat;
  final double lng;
  final String styleUrl;
  final VoidCallback? onTap;

  @override
  State<VillageMiniMap> createState() => _VillageMiniMapState();
}

class _VillageMiniMapState extends State<VillageMiniMap> {
  vietmap.VietmapController? _controller;

  @override
  void dispose() {
    // KHÔNG gọi _controller?.dispose(); VietmapGL tự quản lý
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = vietmap.LatLng(widget.lat, widget.lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          vietmap.VietmapGL(
            myLocationEnabled: false,
            trackCameraPosition: true,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            tiltGesturesEnabled: false,
            styleString: widget.styleUrl,
            initialCameraPosition: vietmap.CameraPosition(
              target: target,
              zoom: 12,
            ),
            onMapCreated: (c) {
              if (!mounted) return;
              setState(() => _controller = c);
            },
            onMapClick: (_, __) => widget.onTap?.call(),
          ),

          // Gắn marker **chung subtree** với VietmapGL → an toàn khi dispose
          if (_controller != null)
            vietmap.MarkerLayer(
              key: ValueKey(_controller),
              mapController: _controller!,
              markers: [
                vietmap.Marker(
                  alignment: Alignment.bottomCenter,
                  height: 30,
                  width: 30,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                  latLng: target,
                ),
              ],
            ),

          // Layer bắt tap nguyên bản đồ (nếu muốn)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: widget.onTap),
            ),
          ),
        ],
      ),
    );
  }
}

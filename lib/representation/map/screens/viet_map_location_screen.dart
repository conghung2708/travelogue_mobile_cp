import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

class VietMapLocationScreen extends StatefulWidget {
  final LatLng destination;
  static const routeName = '/vietmap_location_route';

  const VietMapLocationScreen({
    super.key,
    required this.destination,
  });

  @override
  State<VietMapLocationScreen> createState() => _VietMapLocationScreenState();
}

class _VietMapLocationScreenState extends State<VietMapLocationScreen> {
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  MapNavigationViewController? _navigationController;

  LatLng? currentLocation;
  bool _locationPermissionGranted = false;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _isLoading = true;
  bool _mapInitialized = false;

  RouteProgressEvent? _routeProgress;
  Widget instructionImage = const SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
    _checkLocationPermission();
  }

  Future<void> _initializeNavigation() async {
    try {
      _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
      _navigationOption.simulateRoute = false;
      _navigationOption.apiKey =
          "840f8a8247cb32578fc81fec50af42b8ede321173a31804b";
      _navigationOption.mapStyle =
          "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=840f8a8247cb32578fc81fec50af42b8ede321173a31804b";

      _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
      setState(() => _mapInitialized = true);
    } catch (e) {
      debugPrint("Lỗi khởi tạo bản đồ: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        setState(() => _locationPermissionGranted = true);
        await _getCurrentLocation();
      }
    } catch (e) {
      debugPrint("Lỗi quyền vị trí: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      if (_navigationController != null && !_routeBuilt) {
        await _buildRoute();
      }
    } catch (e) {
      debugPrint('Lỗi lấy vị trí: $e');
      setState(() => _isLoading = false);
      _showErrorSnackbar('Không thể lấy vị trí hiện tại');
    }
  }

  Future<void> _buildRoute() async {
    if (currentLocation == null) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _navigationController?.buildRoute(
        waypoints: [currentLocation!, widget.destination],
        profile: DrivingProfile.drivingTraffic,
      );
      setState(() {
        _routeBuilt = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi xây dựng tuyến đường: $e');
      setState(() => _isLoading = false);
      _showErrorSnackbar('Lỗi khi xây dựng tuyến đường');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, String tooltip, VoidCallback? onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue[800]),
        iconSize: 24,
        tooltip: tooltip,
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            Icons.navigation,
            "Định vị lại",
            () => _navigationController?.recenter(),
          ),
          _buildControlButton(
            Icons.alt_route,
            "Xem tổng quan",
            () => _navigationController?.overview(),
          ),
          _buildControlButton(
            Icons.close,
            "Dừng chỉ đường",
            () {
              _navigationController?.finishNavigation();
              setState(() => _isNavigating = false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartNavigationButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            if (_routeBuilt) {
              _navigationController?.startNavigation();
              setState(() => _isNavigating = true);
            }
          },
          icon: const Icon(Icons.directions, size: 24),
          label: const Text(
            "BẮT ĐẦU CHỈ ĐƯỜNG",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionBanner() {
    return Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[800]?.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            instructionImage,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _routeProgress?.currentStepInstruction ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_routeProgress?.distanceRemaining != null)
                    Text(
                      'Còn ${_routeProgress!.distanceRemaining!.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionWarning() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CẦN CẤP QUYỀN TRUY CẬP VỊ TRÍ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _checkLocationPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange[800],
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('CẤP QUYỀN NGAY'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(
          _mapInitialized ? 'Đang tải bản đồ...' : 'Đang khởi tạo...',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map View
          if (_mapInitialized)
            NavigationView(
              mapOptions: _navigationOption,
              onMapCreated: (controller) {
                _navigationController = controller;
                if (currentLocation != null) {
                  _navigationController?.animateCamera(
                    latLng: currentLocation!,
                    zoom: 15,
                  );
                }
              },
              onRouteBuilt: (route) => setState(() => _routeBuilt = true),
              onRouteProgressChange: (RouteProgressEvent event) {
                setState(() => _routeProgress = event);

                if (event.currentModifier != null &&
                    event.currentModifierType != null) {
                  final path =
                      'assets/navigation_symbol/${event.currentModifierType!.replaceAll(' ', '_')}_${event.currentModifier!.replaceAll(' ', '_')}.svg';
                  setState(() {
                    instructionImage = SvgPicture.asset(
                      path,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    );
                  });
                }
              },
            ),

          // Loading Indicator
          if (_isLoading || !_mapInitialized) Center(child: _buildMapLoading()),

          // App Bar
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(color: Colors.blue),
              ),
            ),
          ),

          // Navigation UI
          if (_routeBuilt && !_isNavigating && !_isLoading)
            _buildStartNavigationButton(),

          if (_isNavigating && !_isLoading) ...[
            _buildInstructionBanner(),
            _buildNavigationControls(),
          ],

          // Permission Warning
          if (!_locationPermissionGranted && !_isLoading)
            _buildPermissionWarning(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _navigationController?.onDispose();
    super.dispose();
  }
}

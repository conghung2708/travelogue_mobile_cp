import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VietMapNavigationScreen extends StatefulWidget {
  const VietMapNavigationScreen({super.key});

  @override
  State<VietMapNavigationScreen> createState() =>
      _VietMapNavigationScreenState();
}

class _VietMapNavigationScreenState extends State<VietMapNavigationScreen> {
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  MapNavigationViewController? _navigationController;

  LatLng? currentLocation;
  LatLng? destination;
  Widget? instructionImage;
  RouteProgressEvent? routeProgressEvent;
  bool _isLocationLoading = true;
  bool _isNavigationActive = false;

  final TextEditingController _searchController = TextEditingController();
  final String _vietmapApiKey =
      "840f8a8247cb32578fc81fec50af42b8ede321173a31804b";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeNavigation();
  }

  @override
  void dispose() {
    _navigationController?.onDispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {}
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {}
      }

      if (permission == LocationPermission.deniedForever) {}

      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _isLocationLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLocationLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _initializeNavigation() async {
    Vietmap.getInstance(_vietmapApiKey);
    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.apiKey = _vietmapApiKey;
    _navigationOption.mapStyle =
        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$_vietmapApiKey";
    _navigationOption.initialLatitude = 11.383150385232414;
    _navigationOption.initialLongitude = 106.17638105695075;
    _navigationOption.zoom = 14;

    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  void _buildRouteToDestination(LatLng clickedLocation) {
    if (currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please wait while we get your current location..."),
        ),
      );
      return;
    }

    setState(() {
      destination = clickedLocation;
      _isNavigationActive = true;
    });

    _navigationController?.buildRoute(
      waypoints: [currentLocation!, destination!],
      profile: DrivingProfile.drivingTraffic,
    );
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      return;
    }

    final result = await Vietmap.autocomplete(
      VietMapAutoCompleteParams(
        textSearch: query,
        focusLocation: currentLocation,
      ),
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi khi tìm kiếm: $failure")),
        );
      },
      (places) async {
        if (places.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Không tìm thấy địa điểm.")),
          );
          return;
        }

        final place = places.first;
        final refId = place.refId;
        if (refId == null || refId.isEmpty) {
          return;
        }

        final detailResult = await Vietmap.place(refId);
        detailResult.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("⚠️ Không lấy được chi tiết địa điểm.")),
            );
          },
          (detail) async {
            final lat = detail.lat?.toDouble();
            final lng = detail.lng?.toDouble();

            if (lat == null || lng == null) {
              return;
            }

            final location = LatLng(lat, lng);

            await _navigationController?.removeAllMarkers();
            await _navigationController?.moveCamera(latLng: location, zoom: 16);

            await _navigationController?.addImageMarkers([
              NavigationMarker(
                imagePath: AssetHelper.icon_location,
                latLng: location,
                width: 70,
                height: 70,
              ),
            ]);

            _buildRouteToDestination(location);
            _searchController.clear();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("🎯 Đã chọn: ${detail.name}")),
            );
          },
        );
      },
    );
  }

  void _startNavigation() {
    if (destination == null) {
      return;
    }

    setState(() {
      _isNavigationActive = true;
    });
    _navigationController?.startNavigation();
  }

  void _finishNavigation() {
    setState(() {
      _isNavigationActive = false;
      routeProgressEvent = null;
    });
    _navigationController?.finishNavigation();
  }

  Widget _buildRecenterButton() {
    return FloatingActionButton(
      onPressed: () => _navigationController?.recenter(),
      mini: true,
      child: const Icon(Icons.my_location),
    );
  }

  Widget _buildNavigationControlButton() {
    return FloatingActionButton(
      onPressed: _isNavigationActive ? _finishNavigation : _startNavigation,
      child: Icon(_isNavigationActive ? Icons.close : Icons.directions),
    );
  }

  void _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      try {
        List<String> data = [
          type.replaceAll(' ', '_'),
          modifier.replaceAll(' ', '_')
        ];
        String path = 'assets/navigation_symbol/${data.join('_')}.svg';
        setState(() {
          instructionImage = SvgPicture.asset(
            path,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          );
        });
      } catch (e) {
        setState(() {
          instructionImage = const Icon(Icons.directions, color: Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (_isLocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<LocationModel> locations =
              state.props[1] as List<LocationModel>;
          final List<String> _dynamicSuggestions =
              locations.map((e) => e.name ?? '').toSet().toList();

          return SafeArea(
            child: Stack(
              children: [
                NavigationView(
                  mapOptions: _navigationOption,
                  onMapCreated: (controller) async {
                    _navigationController = controller;
                    if (currentLocation != null) {
                      await _navigationController?.moveCamera(
                          latLng: currentLocation!);
                    }
                    await _navigationController?.addImageMarkers(
                      locations
                          .map((e) => NavigationMarker(
                                imagePath: AssetHelper.icon_location,
                                latLng:
                                    LatLng(e.latitude ?? 0, e.longitude ?? 0),
                                width: 30,
                                height: 30,
                              ))
                          .toList(),
                    );
                  },
                  onRouteProgressChange: (event) {
                    if (event.currentStepInstruction != null) {
                      setState(() {
                        routeProgressEvent = event;
                      });
                      _setInstructionImage(
                        event.currentModifier,
                        event.currentModifierType,
                      );
                    }
                  },
                  onMapLongClick: (latLng, point) {
                    if (latLng != null) {
                      _buildRouteToDestination(latLng);
                    }
                  },
                ),
                Positioned(
                  top: 2.h,
                  left: 4.w,
                  right: 4.w,
                  child: Column(
                    children: [
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: _onSearchChanged,
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            hintText: 'Tìm địa điểm...',
                            hintStyle: TextStyle(fontSize: 18.sp),
                            prefixIcon: Icon(Icons.search, size: 18.sp),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.5.h,
                            ),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: _dynamicSuggestions
                                .where((item) => item.toLowerCase().contains(
                                    _searchController.text.toLowerCase()))
                                .map((item) => ListTile(
                                      title: Text(item,
                                          style: TextStyle(fontSize: 14.sp)),
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        await _onSearchChanged(item);
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (routeProgressEvent != null)
                  Positioned(
                    top: 9.h,
                    left: 4.w,
                    right: 4.w,
                    child: BannerInstructionView(
                      routeProgressEvent: routeProgressEvent!,
                      instructionIcon: instructionImage ?? const SizedBox(),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomActionView(
                    recenterButton: _buildRecenterButton(),
                    controller: _navigationController,
                    routeProgressEvent: routeProgressEvent,
                  ),
                ),
                Positioned(
                  bottom: 45.sp,
                  right: 15.sp,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNavigationControlButton(),
                      SizedBox(height: 2.h),
                      FloatingActionButton(
                        onPressed: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 50));
                          _navigationController?.overview();
                        },
                        mini: true,
                        child: const Icon(Icons.route),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/bottom_nav.dart';
import '../../../shared/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onNav;
  const HomeScreen({super.key, required this.onNav});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapboxMap? _mapboxMap;
  bool _locating = false;

  final CameraOptions _initialCamera = CameraOptions(
    center: Point(coordinates: Position(28.0106, -26.0274)),
    zoom: 17.0,
    pitch: 60.0,
    bearing: 30.0,
  );

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _goToUserLocation();
  }

  Future<void> _goToUserLocation() async {
    setState(() => _locating = true);
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) return;
      }

      if (permission == geo.LocationPermission.deniedForever) return;

      final geo.Position pos = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      await _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(pos.longitude, pos.latitude)),
          zoom: 17.5,
          pitch: 60.0,
          bearing: 30.0,
        ),
        MapAnimationOptions(duration: 1500),
      );
    } catch (_) {
      // Fall back to default Johannesburg location silently
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(22, 52, 22, 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                const StatusBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hazard Map', style: AppTextStyles.heading(size: 24)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => widget.onNav('notifications'),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(child: CustomIcon(id: 'bell', size: 18)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => widget.onNav('profile'),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CustomIcon(
                                id: 'user',
                                size: 18,
                                color: AppColors.limeT,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Map ───────────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                MapWidget(
                  key: const ValueKey('mapbox_map'),
                  cameraOptions: _initialCamera,
                  styleUri: MapboxStyles.SATELLITE_STREETS,
                  onMapCreated: _onMapCreated,
                  textureView: true,
                ),

                // ── My Location Button ─────────────────────────
                Positioned(
                  bottom: 104,
                  right: 18,
                  child: GestureDetector(
                    onTap: _goToUserLocation,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _locating
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.my_location_rounded,
                              size: 22,
                            ),
                    ),
                  ),
                ),

                // ── Report FAB ─────────────────────────────────
                Positioned(
                  bottom: 22,
                  right: 18,
                  child: GestureDetector(
                    onTap: () => widget.onNav('camera'),
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lime.withOpacity(0.8),
                            blurRadius: 32,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 32, color: AppColors.limeT),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Navigation ──────────────────────────────────
          BottomNav(active: 'home', onNav: widget.onNav),
        ],
      ),
    );
  }
}
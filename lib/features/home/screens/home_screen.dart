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
      bool serviceEnabled =
          await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) return;
      }
      if (permission == geo.LocationPermission.deniedForever) return;

      final geo.Position pos =
          await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      await _mapboxMap?.flyTo(
        CameraOptions(
          center:
              Point(coordinates: Position(pos.longitude, pos.latitude)),
          zoom: 17.5,
          pitch: 60.0,
          bearing: 30.0,
        ),
        MapAnimationOptions(duration: 1500),
      );
    } catch (_) {
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _confirmSignOut(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _HomeSignOutSheet(onConfirm: () {
        Navigator.pop(context);
        widget.onNav('login');
      }),
    );
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
              border:
                  Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                const StatusBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hazard Map',
                        style: AppTextStyles.heading(size: 24)),
                    Row(
                      children: [
                        // ── Sign Out ──────────────────────────
                        GestureDetector(
                          onTap: () => _confirmSignOut(context),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Icon(Icons.logout_rounded,
                                  size: 18, color: AppColors.ink2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // ── Bell ──────────────────────────────
                        GestureDetector(
                          onTap: () => widget.onNav('notifications'),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                                child: CustomIcon(
                                    id: 'bell', size: 18)),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // ── Profile ───────────────────────────
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
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location_rounded,
                              size: 22),
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
                        child: Icon(Icons.add,
                            size: 32, color: AppColors.limeT),
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

// ── Home Sign Out Sheet ───────────────────────────────────────
class _HomeSignOutSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const _HomeSignOutSheet({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.logout_rounded,
                    size: 26, color: AppColors.red),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Sign out?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will need to sign back in to report and track hazards.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.ink2,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    'Yes, sign me out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
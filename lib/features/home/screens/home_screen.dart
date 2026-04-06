import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/bottom_nav.dart';
import '../../../shared/widgets/custom_icon.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onNav;
  const HomeScreen({super.key, required this.onNav});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          // Header
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
                            child: Center(
                              child: CustomIcon(id: 'bell', size: 18),
                            ),
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
                              child: CustomIcon(id: 'user', size: 18, color: AppColors.limeT),
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

          // Live Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(-26.1072, 28.057),
                    initialZoom: 15.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    ),
                  ],
                ),

                // Big Plus FAB (Camera / Report)
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

          // Bottom Navigation
          BottomNav(
            active: 'home',
            onNav: widget.onNav,
          ),
        ],
      ),
    );
  }
}
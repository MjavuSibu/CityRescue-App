import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/status_bar.dart';

class CameraScreen extends StatefulWidget {
  final Function(String) onNav;
  const CameraScreen({super.key, required this.onNav});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool detected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => detected = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: const Color(0xFF0A0D12),        // Very dark background
      child: Stack(
        children: [
          const StatusBar(dark: true),

          // Simple dark camera preview
          const Center(
            child: Text(
              'Camera Preview',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ),

          // AI Detection banner
          if (detected)
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A00),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.lime, width: 1.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.lime, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Detected: Pothole',
                      style: TextStyle(
                        color: AppColors.lime,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Big shutter button at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => widget.onNav('review'),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lime, width: 6),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, size: 38, color: Color(0xFF0A0D12)),
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 60,
            left: 20,
            child: GestureDetector(
              onTap: () => widget.onNav('home'),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
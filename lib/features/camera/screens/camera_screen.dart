import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/custom_icon.dart';

class CameraScreen extends StatefulWidget {
  final Function(String) onNav;
  const CameraScreen({super.key, required this.onNav});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool scanning = false;
  bool detected = false;
  bool captured = false;
  bool flash = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => scanning = true);
    });
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) setState(() => detected = true);
    });
  }

  void shoot() {
    setState(() => flash = true);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => flash = false);
    });
    setState(() => captured = true);
    Future.delayed(const Duration(milliseconds: 750), () {
      // For now we go to review
      // Later we will go to Review screen
      widget.onNav('review');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFF0A0D12),
      child: Stack(
        children: [
          const StatusBar(dark: true),

          // Camera preview simulation
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B3454), Color(0xFF2E2F3C)],
                ),
              ),
            ),
          ),

          // Flash effect
          if (flash)
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.9)),
            ),

          // Scan overlay
          if (scanning)
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerOverlayPainter(),
              ),
            ),

          // Focus brackets when detected
          if (detected)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.27,
              left: MediaQuery.of(context).size.width * 0.22,
              child: Container(
                width: 144,
                height: 94,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lime, width: 2),
                ),
              ),
            ),

          // Top controls
          Positioned(
            top: 52,
            left: 22,
            right: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.onNav('home'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Photo Mode',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.flash_on, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // AI detection banner
          if (detected)
            Positioned(
              top: 112,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A00).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.lime.withOpacity(0.55)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Detected: Pothole',
                      style: TextStyle(
                        color: AppColors.lime,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '87%',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Location tag
          Positioned(
            bottom: 155,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIcon(id: 'pin', size: 13, color: AppColors.lime),
                    const SizedBox(width: 7),
                    const Text(
                      'Current Location',
                      style: TextStyle(color: Colors.white, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Shutter area
          Positioned(
            bottom: 54,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gallery button
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.photo_library_outlined, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 52),
                // Big shutter button
                GestureDetector(
                  onTap: shoot,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: captured ? AppColors.lime : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: captured
                          ? const Icon(Icons.check, color: AppColors.limeT, size: 40)
                          : const Icon(Icons.camera, color: Color(0xFF0A0D12), size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 52),
                // Settings button
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Simple scanner overlay painter
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lime.withOpacity(0.2)
      ..strokeWidth = 1;

    // Grid lines
    for (double i = 0.25; i < 1; i += 0.25) {
      canvas.drawLine(Offset(0, size.height * i), Offset(size.width, size.height * i), paint);
      canvas.drawLine(Offset(size.width * i, 0), Offset(size.width * i, size.height), paint);
    }

    // Scanning line
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, AppColors.lime, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 3));

    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.3, size.width, 3), scanPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
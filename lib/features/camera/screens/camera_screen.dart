import 'package:city_rescue/features/camera/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/status_bar.dart';

class CameraScreen extends StatefulWidget {
  final Function(String) onNav;
  const CameraScreen({super.key, required this.onNav});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool isAnalyzing = false;
  String? detectedType;

  final List<String> possibleHazards = [
    'Pothole',
    'Water Leak',
    'Broken Streetlight',
    'Waste',
    'Cracked Pavement',
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final XFile picture = await _controller!.takePicture();

    setState(() => isAnalyzing = true);

    await Future.delayed(const Duration(milliseconds: 1400));

    final randomHazard = possibleHazards[DateTime.now().millisecond % possibleHazards.length];

    setState(() {
      isAnalyzing = false;
      detectedType = randomHazard;
    });

    // Pass the detected hazard and image path to Review
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewScreen(
              onNav: widget.onNav,
              imagePath: picture.path,
              detectedHazard: randomHazard,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          const StatusBar(dark: true),

          Positioned(
            top: 52,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.onNav('home'),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Photo Mode',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
          ),

          if (isAnalyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.75),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.lime),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing image with AI...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (detectedType != null)
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A00).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.lime),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.lime, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Detected: $detectedType',
                      style: const TextStyle(
                        color: AppColors.lime,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: takePicture,
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
        ],
      ),
    );
  }
}
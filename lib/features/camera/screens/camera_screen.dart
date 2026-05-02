import 'dart:io';
import 'package:city_rescue/features/camera/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
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
  String analysisStatus = 'Scanning image...';

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

  Map<String, String> _mapLabelsToHazard(List<String> labels) {
    final lower = labels.map((l) => l.toLowerCase()).toList();

    if (lower.any((l) =>
        l.contains('pothole') ||
        l.contains('asphalt') ||
        l.contains('road') ||
        l.contains('crack') ||
        l.contains('pavement'))) {
      return {
        'hazard': 'Pothole / Road Damage',
        'severity': 'High',
        'department': 'City of Johannesburg — Roads & Stormwater',
        'description':
            'Road surface damage detected. Poses risk to vehicles and pedestrians.',
      };
    }
    if (lower.any((l) =>
        l.contains('water') ||
        l.contains('flood') ||
        l.contains('puddle') ||
        l.contains('liquid') ||
        l.contains('drain'))) {
      return {
        'hazard': 'Water Leak / Flooding',
        'severity': 'Critical',
        'department': 'City of Johannesburg — Johannesburg Water',
        'description':
            'Water accumulation or leak detected. May indicate burst pipe or blocked drain.',
      };
    }
    if (lower.any((l) =>
        l.contains('waste') ||
        l.contains('garbage') ||
        l.contains('trash') ||
        l.contains('litter') ||
        l.contains('plastic') ||
        l.contains('bottle') ||
        l.contains('rubbish'))) {
      return {
        'hazard': 'Illegal Dumping',
        'severity': 'Medium',
        'department': 'City of Johannesburg — Pikitup Waste Management',
        'description':
            'Illegal waste dumping detected. Health and environmental hazard.',
      };
    }
    if (lower.any((l) =>
        l.contains('wire') ||
        l.contains('cable') ||
        l.contains('electric') ||
        l.contains('pole') ||
        l.contains('light') ||
        l.contains('lamp'))) {
      return {
        'hazard': 'Electrical Hazard',
        'severity': 'Critical',
        'department': 'City of Johannesburg — City Power',
        'description':
            'Electrical infrastructure damage detected. Immediate safety risk.',
      };
    }
    if (lower.any((l) =>
        l.contains('graffiti') ||
        l.contains('vandal') ||
        l.contains('spray') ||
        l.contains('paint'))) {
      return {
        'hazard': 'Vandalism / Graffiti',
        'severity': 'Low',
        'department': 'City of Johannesburg — Urban Management',
        'description':
            'Vandalism or graffiti detected on public infrastructure.',
      };
    }
    if (lower.any((l) =>
        l.contains('sign') ||
        l.contains('signage') ||
        l.contains('traffic sign') ||
        l.contains('stop'))) {
      return {
        'hazard': 'Damaged Road Sign',
        'severity': 'High',
        'department': 'City of Johannesburg — Transportation',
        'description':
            'Missing or damaged road signage detected. Traffic safety risk.',
      };
    }
    if (lower.any((l) =>
        l.contains('tree') ||
        l.contains('branch') ||
        l.contains('wood') ||
        l.contains('fallen'))) {
      return {
        'hazard': 'Fallen Tree / Branch',
        'severity': 'High',
        'department': 'City of Johannesburg — Parks & Recreation',
        'description':
            'Fallen tree or branch detected. Obstruction and safety hazard.',
      };
    }
    if (lower.any((l) =>
        l.contains('concrete') ||
        l.contains('sidewalk') ||
        l.contains('curb') ||
        l.contains('stone') ||
        l.contains('brick'))) {
      return {
        'hazard': 'Cracked Pavement',
        'severity': 'Medium',
        'department': 'City of Johannesburg — Roads & Stormwater',
        'description':
            'Damaged pavement or sidewalk detected. Pedestrian safety risk.',
      };
    }

    // Fallback
    return {
      'hazard': 'Urban Hazard',
      'severity': 'Medium',
      'department': 'City of Johannesburg — Urban Management',
      'description':
          'Potential urban hazard detected. Requires inspection by city officials.',
    };
  }

  Future<Map<String, String>> _analyzeImageWithMLKit(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final labeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.55),
    );

    final labels = await labeler.processImage(inputImage);
    await labeler.close();

    final labelNames = labels.map((l) => l.label).toList();
    return _mapLabelsToHazard(labelNames);
  }

  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final XFile picture = await _controller!.takePicture();

    setState(() {
      isAnalyzing = true;
      analysisStatus = 'Scanning image...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => analysisStatus = 'Identifying hazard type...');

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => analysisStatus = 'Checking severity level...');

    try {
      final result = await _analyzeImageWithMLKit(picture.path);

      setState(() => analysisStatus = 'Routing to department...');
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() => isAnalyzing = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewScreen(
              onNav: widget.onNav,
              imagePath: picture.path,
              detectedHazard: result['hazard'],
              severity: result['severity'],
              department: result['department'],
              description: result['description'],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.lime)),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ── Camera Preview ─────────────────────────────────────
          CameraPreview(_controller!),
          const StatusBar(dark: true),

          // ── Top Bar ────────────────────────────────────────────
          Positioned(
            top: 52,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.onNav('home'),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Report Hazard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
          ),

          // ── Scan Frame ─────────────────────────────────────────
          if (!isAnalyzing)
            Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lime, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    _Corner(top: 0, left: 0),
                    _Corner(top: 0, right: 0),
                    _Corner(bottom: 0, left: 0),
                    _Corner(bottom: 0, right: 0),
                  ],
                ),
              ),
            ),

          // ── Hint Label ─────────────────────────────────────────
          if (!isAnalyzing)
            Positioned(
              bottom: 170,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Point at a hazard and tap capture',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),
            ),

          // ── Analyzing Overlay ──────────────────────────────────
          if (isAnalyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.82),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.lime, width: 3),
                        color: AppColors.lime.withOpacity(0.1),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lime,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      analysisStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'On-device AI is analyzing your photo',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

          // ── Shutter Button ─────────────────────────────────────
          if (!isAnalyzing)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: takePicture,
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.lime, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lime.withOpacity(0.5),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.camera_alt,
                          size: 36, color: Color(0xFF0A0D12)),
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

class _Corner extends StatelessWidget {
  final double? top, bottom, left, right;
  const _Corner({this.top, this.bottom, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: AppColors.lime, width: 3)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: AppColors.lime, width: 3)
                : BorderSide.none,
            left: left != null
                ? const BorderSide(color: AppColors.lime, width: 3)
                : BorderSide.none,
            right: right != null
                ? const BorderSide(color: AppColors.lime, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
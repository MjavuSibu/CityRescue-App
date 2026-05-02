import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../submit/screens/submit_screen.dart';

class ReviewScreen extends StatefulWidget {
  final Function(String) onNav;
  final String? imagePath;
  final String? detectedHazard;
  final String? severity;
  final String? department;
  final String? description;

  const ReviewScreen({
    super.key,
    required this.onNav,
    this.imagePath,
    this.detectedHazard,
    this.severity,
    this.department,
    this.description,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String locationText = 'Getting location...';
  bool _locationLoaded = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => locationText = 'Location services disabled');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => locationText = 'Location permission denied');
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        locationText =
            '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
        _locationLoaded = true;
      });
    } catch (_) {
      setState(() => locationText = 'Could not get location');
    }
  }

  Color _severityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE53935);
      case 'high':
        return const Color(0xFFF4511E);
      case 'medium':
        return const Color(0xFFFB8C00);
      case 'low':
        return const Color(0xFF43A047);
      default:
        return AppColors.ink2;
    }
  }

  Color _severityBg(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return const Color(0xFFFFEBEE);
      case 'high':
        return const Color(0xFFFBE9E7);
      case 'medium':
        return const Color(0xFFFFF3E0);
      case 'low':
        return const Color(0xFFE8F5E9);
      default:
        return AppColors.surface;
    }
  }

  IconData _severityIcon(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return Icons.emergency_rounded;
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _severityMessage(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return 'Immediate response required';
      case 'high':
        return 'Urgent attention needed';
      case 'medium':
        return 'Requires prompt repair';
      case 'low':
        return 'Schedule for maintenance';
      default:
        return 'Requires inspection';
    }
  }

  String _formattedNow() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year}, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final hazardName = widget.detectedHazard ?? 'Unknown Hazard';
    final severity = widget.severity ?? 'Medium';
    final department =
        widget.department ?? 'City of Johannesburg — Urban Management';
    final description = widget.description ?? '';

    return Material(
      color: AppColors.bg,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.bg,
        child: Column(
          children: [
            // ── Hero Image with Overlay ──────────────────────────
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.imagePath != null
                      ? Image.file(
                          File(widget.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined,
                                size: 48, color: AppColors.ink3),
                          ),
                        ),

                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.55),
                            Colors.black.withOpacity(0.88),
                          ],
                          stops: const [0.0, 0.4, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Status bar
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: StatusBar(dark: true),
                  ),

                  // Back button
                  Positioned(
                    top: 48,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // Hazard name + severity badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.lime,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'HAZARD DETECTED',
                                  style: TextStyle(
                                    color: AppColors.limeT,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hazardName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: _severityColor(severity),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(_severityIcon(severity),
                                  color: Colors.white, size: 20),
                              const SizedBox(height: 4),
                              Text(
                                severity.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Details Section ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description card
                    if (description.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.lime.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(Icons.description_rounded,
                                    size: 16, color: AppColors.limeD),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'AI ASSESSMENT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.ink3,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Location + Department card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Icons.location_on_rounded,
                            iconColor: const Color(0xFF1565C0),
                            iconBg: const Color(0xFFE3F2FD),
                            label: 'GPS COORDINATES',
                            value: locationText,
                            isLoading: !_locationLoaded,
                          ),
                          Divider(
                              height: 1,
                              indent: 66,
                              color: AppColors.border),
                          _DetailRow(
                            icon: Icons.account_balance_rounded,
                            iconColor: const Color(0xFF6A1B9A),
                            iconBg: const Color(0xFFF3E5F5),
                            label: 'ROUTED TO',
                            value: department,
                          ),
                          Divider(
                              height: 1,
                              indent: 66,
                              color: AppColors.border),
                          _DetailRow(
                            icon: Icons.access_time_rounded,
                            iconColor: const Color(0xFF00838F),
                            iconBg: const Color(0xFFE0F7FA),
                            label: 'SUBMITTED',
                            value: _formattedNow(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Severity card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _severityBg(severity),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _severityColor(severity).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color:
                                  _severityColor(severity).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                _severityIcon(severity),
                                size: 18,
                                color: _severityColor(severity),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SEVERITY LEVEL',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: _severityColor(severity),
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$severity — ${_severityMessage(severity)}',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: _severityColor(severity),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Submit Button ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmitScreen(
                        onNav: widget.onNav,
                        hazard: widget.detectedHazard,
                        severity: widget.severity,
                        department: widget.department,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lime.withOpacity(0.55),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Confirm & Submit Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.limeT,
                      ),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool isLoading;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, size: 18, color: iconColor),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink3,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                isLoading
                    ? Container(
                        height: 14,
                        width: 140,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/lime_button.dart';

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
  String departmentText = 'Routing to relevant department...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      // In real app, you would use reverse geocoding or Firebase to determine department
      departmentText = 'City of Johannesburg — Relevant Dept';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hazardName = widget.detectedHazard ?? 'Unknown Hazard';

    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.bg,
      child: Column(
        children: [
          const StatusBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 22, 14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Review Report',
                  style: AppTextStyles.heading(size: 22, letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: widget.imagePath != null
                        ? Image.file(
                            File(widget.imagePath!),
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 260,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('No image captured',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.lime.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(Icons.warning_amber,
                                    color: AppColors.limeD, size: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hazardName,
                                      style: AppTextStyles.heading(
                                          size: 28, letterSpacing: -0.6)),
                                  Text('Road & Infrastructure Hazard',
                                      style: TextStyle(
                                          color: AppColors.ink2, fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        _InfoRow(label: 'Location', value: locationText),
                        _InfoRow(
                            label: 'Auto-routed to',
                            value: widget.department ?? departmentText),
                        _InfoRow(
                            label: 'Severity',
                            value: widget.severity ?? 'Unknown'),
                        _InfoRow(
                            label: 'Details', value: widget.description ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
            child: LimeButton(
              text: 'Confirm & Submit Report',
              onPressed: () => widget.onNav('submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(
              child: Icon(Icons.location_on, size: 16, color: AppColors.ink2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink3)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

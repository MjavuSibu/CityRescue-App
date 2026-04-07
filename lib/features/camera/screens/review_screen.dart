import 'package:city_rescue/shared/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/lottie_icon.dart';
import '../../../shared/widgets/lime_button.dart';

class ReviewScreen extends StatelessWidget {
  final Function(String) onNav;
  const ReviewScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => onNav('camera'),
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
                  // Photo preview
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 60),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Container(
                        color: const Color(0xFF2E2F3C),
                        child: const Center(
                          child: Text(
                            'Captured Photo Preview',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Hazard info card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24),
                      ],
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
                                child: Icon(Icons.warning_amber, color: AppColors.limeD, size: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pothole', style: AppTextStyles.heading(size: 28, letterSpacing: -0.6)),
                                Text('Road & Infrastructure Hazard', style: TextStyle(color: AppColors.ink2, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        _InfoRow(icon: 'pin', label: 'Location', value: 'Current Location'),
                        _InfoRow(icon: 'send', label: 'Auto-routed to', value: 'City of Johannesburg — Roads Dept'),
                        _InfoRow(icon: 'shield', label: 'Severity', value: 'High — Active traffic hazard'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Impact card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.lime, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.lime.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Icon(Icons.people, color: AppColors.limeD, size: 22),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '100+ commuters could be helped by this report',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'High-traffic zone · Response expected within 48h',
                                style: TextStyle(fontSize: 12, color: AppColors.ink3),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
            child: LimeButton(
              text: 'Confirm & Submit Report',
              onPressed: () => onNav('submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
            child: Center(
              child: CustomIcon(id: icon, size: 16, color: AppColors.ink2),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink3,
                  letterSpacing: 1,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
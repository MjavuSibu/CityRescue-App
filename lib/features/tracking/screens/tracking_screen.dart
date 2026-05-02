import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/bottom_nav.dart';

class TrackingScreen extends StatelessWidget {
  final Function(String) onNav;
  const TrackingScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
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
                    Text('My Reports',
                        style: AppTextStyles.heading(size: 24)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '0 Active',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Empty State ───────────────────────────────────────
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 2,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.radar_rounded,
                              size: 36,
                              color: AppColors.ink3,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'No reports yet',
                      style: AppTextStyles.heading(size: 22),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Reports you submit will appear here. You can track their status and see when the city responds.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.ink2,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // CTA Button
                    GestureDetector(
                      onTap: () => onNav('camera'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.lime,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lime.withOpacity(0.45),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded,
                                size: 20, color: AppColors.limeT),
                            SizedBox(width: 8),
                            Text(
                              'Submit a Report',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.limeT,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom Nav ────────────────────────────────────────
          BottomNav(active: 'tracking', onNav: onNav),
        ],
      ),
    );
  }
}
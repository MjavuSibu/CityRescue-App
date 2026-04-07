import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  final Function(String) go;
  const SplashScreen({super.key, required this.go});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showTitle = false;
  bool showSubtitle = false;

  @override
  void initState() {
    super.initState();

    // Sequential animation with better timing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => showTitle = true);
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => showSubtitle = true);
    });

    // Auto navigate to onboarding after full animation (longer delay as requested)
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) widget.go('onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: AppColors.lime,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CityRescue title
            AnimatedOpacity(
              opacity: showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
              child: AnimatedSlide(
                offset: showTitle ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 60,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Text(
                    'CityRescue',
                    style: AppTextStyles.heading(
                      size: 68,
                      weight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -3.0,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle
            AnimatedOpacity(
              opacity: showSubtitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Text(
                'Civic Tech Platform',
                style: AppTextStyles.body(
                  size: 16,
                  weight: FontWeight.w500,
                  color: AppColors.ink3,
                  letterSpacing: 4.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
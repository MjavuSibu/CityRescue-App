import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/lottie_icon.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(String) go;
  const OnboardingScreen({super.key, required this.go});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      'title': 'Snap a Hazard.',
      'subtitle': 'We handle the rest.',
      'body': 'Point your camera at any pothole, broken light, or water leak. AI identifies it instantly and routes it to the right department.',
      'lottie': 'assets/animations/onboarding_pin.json',
    },
    {
      'title': 'Smart Routing.',
      'subtitle': 'Right department. Every time.',
      'body': 'Our system auto-detects the hazard type and dispatches your report directly to the correct city department — zero guesswork.',
      'lottie': 'assets/animations/orbiting_icon.json',
    },
    {
      'title': 'Track Progress.',
      'subtitle': 'Stay in the loop.',
      'body': 'Follow every report from submission through to resolution. Get live updates as the city takes action on your streets.',
      'lottie': 'assets/animations/camera_scan.json',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          const StatusBar(),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                scrollbars: false,
                overscroll: true,
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                },
              ),
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: LottieIcon(
                              assetPath: slide['lottie']!,
                              size: 140,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          slide['title']!,
                          style: AppTextStyles.heading(size: 38, letterSpacing: -0.9),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          slide['subtitle']!,
                          style: AppTextStyles.body(
                            size: 16,
                            weight: FontWeight.w600,
                            color: AppColors.limeD,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['body']!,
                          style: AppTextStyles.body(size: 15, color: AppColors.ink2),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? AppColors.ink : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    // Skip button (already working as GestureDetector)
                    GestureDetector(
                      onTap: () => widget.go('home'),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink3,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Continue / Get Started button - using the same reliable GestureDetector fix
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_currentPage < slides.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            widget.go('login');
                          }
                        },
                        child: Container(
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
                          child: Center(
                            child: Text(
                              _currentPage == slides.length - 1 ? 'Get Started' : 'Continue',
                              style: const TextStyle(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
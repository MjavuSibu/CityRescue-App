import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';

class OnboardingScreen extends StatelessWidget {
  final Function(String) go;
  const OnboardingScreen({super.key, required this.go});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          const StatusBar(),
          const SizedBox(height: 120),
          const Center(
            child: Text(
              'Onboarding Screen',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'This is the onboarding screen.\nNavigation is working.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.ink2),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(28),
            child: ElevatedButton(
              onPressed: () => go('home'),
              child: const Text('Go to Home'),
            ),
          ),
        ],
      ),
    );
  }
}
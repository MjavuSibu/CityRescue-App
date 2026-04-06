import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const CityRescueApp());
}

class CityRescueApp extends StatefulWidget {
  const CityRescueApp({super.key});

  @override
  State<CityRescueApp> createState() => _CityRescueAppState();
}

class _CityRescueAppState extends State<CityRescueApp> {
  String currentScreen = 'login';

  void go(String screen) {
    print('🔄 go() called with: $screen');   // ← Debug print
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityRescue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DM Sans',
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    print('Current screen: $currentScreen');   // ← Debug print
    switch (currentScreen) {
      case 'login':
        return LoginScreen(go: go);
      case 'signup':
        return SignupScreen(go: go);
      case 'onboarding':
        return OnboardingScreen(go: go);
      default:
        return const Center(child: Text('Screen coming soon...'));
    }
  }
}
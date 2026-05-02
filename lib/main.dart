import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/camera/screens/camera_screen.dart';
import 'features/camera/screens/review_screen.dart';
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
    'pk.eyJ1Ijoic2lidWxlbGVtamF2dSIsImEiOiJjbW9td2hpYmowMmU2MnFzNmYyYjY1eG00In0.YY4AeTYm70zkqBVHGuaWVA',
  );

  runApp(const CityRescueApp());
}

class CityRescueApp extends StatefulWidget {
  const CityRescueApp({super.key});

  @override
  State<CityRescueApp> createState() => _CityRescueAppState();
}

class _CityRescueAppState extends State<CityRescueApp> {
  String currentScreen = 'splash';

  void go(String screen) {
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
    switch (currentScreen) {
      case 'splash':
        return SplashScreen(go: go);
      case 'onboarding':
        return OnboardingScreen(go: go);
      case 'login':
        return LoginScreen(go: go);
      case 'signup':
        return SignupScreen(go: go);
      case 'home':
        return HomeScreen(onNav: go);
      case 'camera':
        return CameraScreen(onNav: go);
      case 'review':
        return ReviewScreen(onNav: go);
      default:
        return const Center(child: Text('Screen coming soon...'));
    }
  }
}
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';

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
      case 'login':
        return LoginScreen(go: go);
      // More screens will be added later when you say "Continue"
      default:
        return const Center(child: Text('Screen coming soon...'));
    }
  }
}
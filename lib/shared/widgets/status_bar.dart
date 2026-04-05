import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final bool dark;
  const StatusBar({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    // Completely empty - only keeps the padding so layout doesn't break
    return const SizedBox(height: 44);
  }
}
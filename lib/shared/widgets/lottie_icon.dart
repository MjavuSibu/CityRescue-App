import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? tint;

  const LottieIcon({
    super.key,
    required this.assetPath,
    this.size = 24,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: tint != null
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
              child: Lottie.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            )
          : Lottie.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  final Function(String) go;
  const SplashScreen({super.key, required this.go});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const String _title = 'CityRescue';

  late final AnimationController _lettersCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _subtitleCtrl;
  late final AnimationController _exitCtrl;

  final List<Animation<double>> _slideAnims = [];
  final List<Animation<double>> _fadeAnims = [];

  late final Animation<double> _glowAnim;
  late final Animation<double> _shimmerAnim;

  late final Animation<double> _subtitleFade;
  late final Animation<double> _subtitleSlide;

  late final Animation<double> _exitFade;
  late final Animation<double> _exitRotation;

  @override
  void initState() {
    super.initState();

    _lettersCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _subtitleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buildLetterAnimations();

    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 65),
    ]).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _shimmerAnim = Tween<double>(begin: -0.4, end: 1.4).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOut),
    );

    _subtitleSlide = Tween<double>(begin: 14.0, end: 0.0).animate(
      CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOutCubic),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInOut),
    );

    _exitRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInOut),
    );

    _runSequence();
  }

  void _buildLetterAnimations() {
    const int count = 9;
    for (int i = 0; i < _title.length; i++) {
      final double staggerStart = (i / count) * 0.62;
      final double slideEnd = (staggerStart + 0.38).clamp(0.0, 1.0);
      final double fadeEnd = (staggerStart + 0.22).clamp(0.0, 1.0);

      _slideAnims.add(
        Tween<double>(begin: 28.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _lettersCtrl,
            curve: Interval(staggerStart, slideEnd, curve: Curves.easeOutCubic),
          ),
        ),
      );

      _fadeAnims.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _lettersCtrl,
            curve: Interval(staggerStart, fadeEnd, curve: Curves.easeOut),
          ),
        ),
      );
    }
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 340));
    if (!mounted) return;
    _lettersCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    _glowCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    _subtitleCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 2500)); // Increased delay to make splash stay longer
    if (!mounted) return;
    await _exitCtrl.forward(); // Start exit animation
    if (!mounted) return;
    widget.go('onboarding');
  }

  @override
  void dispose() {
    _lettersCtrl.dispose();
    _glowCtrl.dispose();
    _subtitleCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_exitFade, _exitRotation]),
      builder: (context, child) {
        return Opacity(
          opacity: _exitFade.value,
          child: RotationTransition(
            turns: _exitRotation,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.lime,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 18),
              _buildSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: Listenable.merge([_lettersCtrl, _glowCtrl]),
      builder: (context, _) {
        final glow = _glowAnim.value;
        final shimmer = _shimmerAnim.value;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final shimLeft = (shimmer - 0.25).clamp(0.0, 1.0);
            final shimCenter = shimmer.clamp(0.0, 1.0);
            final shimRight = (shimmer + 0.25).clamp(0.0, 1.0);
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.55 * glow),
                Colors.transparent,
              ],
              stops: [shimLeft, shimCenter, shimRight],
            ).createShader(bounds);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_title.length, (i) {
              return Transform.translate(
                offset: Offset(_slideAnims[i].value, 0),
                child: Opacity(
                  opacity: _fadeAnims[i].value,
                  child: Text(
                    _title[i],
                    style: AppTextStyles.heading(
                      size: 68,
                      weight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -2.8,
                    ).copyWith(
                      shadows: glow > 0.01
                          ? [
                              Shadow(
                                color: AppColors.ink.withOpacity(0.18 * glow),
                                blurRadius: 24 * glow,
                                offset: const Offset(0, 4),
                              ),
                              Shadow(
                                color: Colors.white.withOpacity(0.35 * glow),
                                blurRadius: 16 * glow,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _subtitleCtrl,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _subtitleSlide.value),
          child: Opacity(
            opacity: _subtitleFade.value,
            child: Text(
              'CIVIC TECH PLATFORM',
              style: AppTextStyles.label(
                size: 13,
                weight: FontWeight.w600,
                color: AppColors.ink.withOpacity(0.45),
                letterSpacing: 4.8,
              ),
            ),
          ),
        );
      },
    );
  }
}
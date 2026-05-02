import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/status_bar.dart';

class SubmitScreen extends StatefulWidget {
  final Function(String) onNav;
  final String? hazard;
  final String? severity;
  final String? department;

  const SubmitScreen({
    super.key,
    required this.onNav,
    this.hazard,
    this.severity,
    this.department,
  });

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _contentController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _ringScale;
  late Animation<double> _contentSlide;
  late Animation<double> _contentOpacity;
  late String _refNumber;

  @override
  void initState() {
    super.initState();
    _refNumber = _generateRef();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeIn),
      ),
    );

    _ringScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _checkController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _contentController.forward();
      });
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _generateRef() {
    final rand = Random();
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final l1 = letters[rand.nextInt(letters.length)];
    final l2 = letters[rand.nextInt(letters.length)];
    final numbers = rand.nextInt(90000) + 10000;
    return 'JHB-$l1$l2$numbers';
  }

  Color _severityColor(String? s) {
    switch (s?.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE53935);
      case 'high':
        return const Color(0xFFF4511E);
      case 'medium':
        return const Color(0xFFFB8C00);
      case 'low':
        return const Color(0xFF43A047);
      default:
        return AppColors.ink2;
    }
  }

  String _expectedResponse(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return 'Within 24 hours';
      case 'high':
        return 'Within 3 business days';
      case 'medium':
        return 'Within 7 business days';
      case 'low':
        return 'Within 14 business days';
      default:
        return 'Within 7 business days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A0D12),
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF0A0D12),
        child: Column(
          children: [
            const StatusBar(dark: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // ── Animated Success Ring ──────────────────────
                    AnimatedBuilder(
                      animation: _checkController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _checkOpacity.value,
                          child: Transform.scale(
                            scale: _ringScale.value,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.lime.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lime.withOpacity(0.12),
                                    border: Border.all(
                                      color: AppColors.lime.withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Transform.scale(
                                      scale: _checkScale.value,
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: AppColors.lime,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Heading ────────────────────────────────────
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _contentSlide.value),
                          child: Opacity(
                            opacity: _contentOpacity.value,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Text(
                            'Report Submitted',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your report has been received and\nrouted to the relevant department.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Reference Number ───────────────────────────
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _contentSlide.value * 1.2),
                          child: Opacity(
                            opacity: _contentOpacity.value,
                            child: child,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _refNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Reference number copied'),
                              backgroundColor: AppColors.limeD,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 24),
                          decoration: BoxDecoration(
                            color: AppColors.lime.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.lime.withOpacity(0.25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'REFERENCE NUMBER',
                                style: TextStyle(
                                  color: AppColors.lime.withOpacity(0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _refNumber,
                                style: const TextStyle(
                                  color: AppColors.lime,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.copy_rounded,
                                    size: 12,
                                    color: AppColors.lime.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Tap to copy',
                                    style: TextStyle(
                                      color: AppColors.lime.withOpacity(0.5),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Summary Card ───────────────────────────────
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _contentSlide.value * 1.5),
                          child: Opacity(
                            opacity: _contentOpacity.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              icon: Icons.warning_rounded,
                              label: 'HAZARD TYPE',
                              value: widget.hazard ?? 'Urban Hazard',
                              valueColor: Colors.white,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.08),
                              indent: 64,
                            ),
                            _SummaryRow(
                              icon: Icons.emergency_rounded,
                              label: 'SEVERITY',
                              value: widget.severity ?? 'Medium',
                              valueColor: _severityColor(widget.severity),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.08),
                              indent: 64,
                            ),
                            _SummaryRow(
                              icon: Icons.account_balance_rounded,
                              label: 'ROUTED TO',
                              value: widget.department ??
                                  'City of Johannesburg — Urban Management',
                              valueColor: Colors.white,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.08),
                              indent: 64,
                            ),
                            _SummaryRow(
                              icon: Icons.schedule_rounded,
                              label: 'EXPECTED RESPONSE',
                              value: _expectedResponse(widget.severity),
                              valueColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Info Note ──────────────────────────────────
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _contentOpacity.value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: Colors.white.withOpacity(0.35),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Save your reference number to follow up with the City of Johannesburg.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Back to Home Button ────────────────────────────────
            AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentOpacity.value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                child: GestureDetector(
                  onTap: () => widget.onNav('home'),
                  child: Container(
                    width: double.infinity,
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
                    child: const Center(
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.limeT,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, size: 16, color: Colors.white54),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.35),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
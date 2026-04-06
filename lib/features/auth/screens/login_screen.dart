import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/lottie_icon.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/custom_icon.dart';
import '../../../shared/widgets/custom_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) go;
  const LoginScreen({super.key, required this.go});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool showPass = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          const StatusBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 38),
                    child: Row(
                      children: [
                        LottieIcon(
                          assetPath: 'assets/animations/location_pin.json',
                          size: 78,
                          tint: const Color.fromARGB(255, 109, 186, 2),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CityRescue',
                              style: AppTextStyles.heading(size: 27, letterSpacing: -0.6),
                            ),
                            Text(
                              'Civic Tech Platform',
                              style: AppTextStyles.body(
                                size: 13,
                                weight: FontWeight.w500,
                                color: AppColors.ink3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Sign in to report and track hazards in your city.',
                    style: AppTextStyles.body(size: 15, color: AppColors.ink2),
                  ),
                  const SizedBox(height: 32),
                  CustomField(
                    label: 'Username or email address',
                    controller: emailController,
                    placeholder: '',
                    icon: CustomIcon(id: 'mail', size: 16, color: AppColors.ink3),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink3,
                          letterSpacing: 1.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.limeD,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomField(
                    controller: passController,
                    placeholder: '',
                    obscureText: !showPass,
                    icon: CustomIcon(id: 'lock', size: 16, color: AppColors.ink3),
                    right: GestureDetector(
                      onTap: () => setState(() => showPass = !showPass),
                      child: CustomIcon(
                        id: showPass ? 'eyeOff' : 'eye',
                        size: 16,
                        color: AppColors.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign In Button - using GestureDetector (same fix that worked for Create Account)
                  GestureDetector(
                    onTap: () {
                      setState(() => loading = true);
                      Future.delayed(const Duration(milliseconds: 1600), () {
                        setState(() => loading = false);
                        widget.go('home');
                      });
                    },
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
                      child: Center(
                        child: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.limeT,
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.limeT,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or continue with',
                          style: TextStyle(fontSize: 12, color: AppColors.ink3, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _SocialButton(
                        label: 'Google',
                        svg: '''<svg width="18" height="18" viewBox="0 0 24 24"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/></svg>''',
                        onTap: () => widget.go('home'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'Apple',
                        svg: '''<svg width="17" height="17" viewBox="0 0 24 24" fill="#0C0C0C"><path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/></svg>''',
                        onTap: () => widget.go('home'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'Microsoft',
                        svg: '''<svg width="17" height="17" viewBox="0 0 21 21"><rect x="1" y="1" width="9" height="9" fill="#F25022"/><rect x="11" y="1" width="9" height="9" fill="#7FBA00"/><rect x="1" y="11" width="9" height="9" fill="#00A4EF"/><rect x="11" y="11" width="9" height="9" fill="#FFB900"/></svg>''',
                        onTap: () => widget.go('home'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: AppColors.ink2),
                        children: [
                          const TextSpan(text: 'No account? '),
                          TextSpan(
                            text: 'Create one',
                            style: const TextStyle(color: AppColors.limeD, fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = () => widget.go('signup'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String svg;
  final VoidCallback onTap;

  const _SocialButton({
    super.key,
    required this.label,
    required this.svg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(svg, width: 18, height: 18),
              const SizedBox(width: 9),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar.dart';
import '../../../shared/widgets/custom_icon.dart';
import '../../../shared/widgets/custom_field.dart';

class SignupScreen extends StatefulWidget {
  final Function(String) go;
  const SignupScreen({super.key, required this.go});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool loading = false;

  int get strength {
    final len = passController.text.length;
    if (len == 0) return 0;
    if (len < 6) return 1;
    if (len < 10) return 2;
    if (len < 14) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Column(
        children: [
          const StatusBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 28, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.go('login'),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Create account',
                  style: AppTextStyles.heading(size: 22, letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join thousands making their city safer every day.',
                    style: AppTextStyles.body(size: 15, color: AppColors.ink2),
                  ),
                  const SizedBox(height: 28),
                  CustomField(
                    label: 'Full name',
                    controller: nameController,
                    placeholder: '',
                    icon: CustomIcon(id: 'user', size: 16, color: AppColors.ink3),
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Email address',
                    controller: emailController,
                    placeholder: '',
                    icon: CustomIcon(id: 'mail', size: 16, color: AppColors.ink3),
                  ),
                  const SizedBox(height: 16),
                  CustomField(
                    label: 'Password',
                    controller: passController,
                    placeholder: '',
                    obscureText: true,
                    icon: CustomIcon(id: 'lock', size: 16, color: AppColors.ink3),
                  ),
                  if (passController.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(4, (i) {
                        final active = strength >= i + 1;
                        final color = strength == 1
                            ? AppColors.red
                            : strength == 2
                                ? AppColors.amber
                                : AppColors.limeD;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: active ? color : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strength == 0 ? '' : ['Too short', 'Could be stronger', 'Good password', 'Strong password'][strength - 1],
                      style: TextStyle(fontSize: 12, color: AppColors.ink3),
                    ),
                  ],
                  const SizedBox(height: 40),
                  // Create Account button using GestureDetector (same logic as "Create one")
                  GestureDetector(
                    onTap: () {
                      setState(() => loading = true);
                      Future.delayed(const Duration(milliseconds: 1600), () {
                        setState(() => loading = false);
                        widget.go('onboarding');
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
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.limeT,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 12, color: AppColors.ink3, height: 1.7),
                        children: [
                          const TextSpan(text: 'By creating an account you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(color: AppColors.limeD, fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(color: AppColors.limeD, fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: '.'),
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
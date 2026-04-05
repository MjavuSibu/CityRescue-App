import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'custom_icon.dart';

class CustomField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final Widget? icon;
  final Widget? right;

  const CustomField({
    super.key,
    this.label,
    required this.controller,
    required this.placeholder,
    this.obscureText = false,
    this.icon,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    final active = controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink3,
                letterSpacing: 1.1,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: active ? AppColors.lime.withOpacity(0.1) : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active ? AppColors.lime : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: icon,
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(fontSize: 15, color: AppColors.ink),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: AppColors.ink3.withOpacity(0.7)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: icon != null ? 12 : 20,
                      vertical: 17,
                    ),
                  ),
                ),
              ),
              if (right != null) Padding(padding: const EdgeInsets.only(right: 18), child: right),
            ],
          ),
        ),
      ],
    );
  }
}
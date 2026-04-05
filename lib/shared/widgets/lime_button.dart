import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LimeButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool ghost;

  const LimeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.ghost = false,
  });

  @override
  State<LimeButton> createState() => _LimeButtonState();
}

class _LimeButtonState extends State<LimeButton> with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.ghost ? Colors.transparent : AppColors.lime,
          borderRadius: BorderRadius.circular(20),
          border: widget.ghost ? Border.all(color: AppColors.border, width: 1.5) : null,
          boxShadow: widget.ghost
              ? null
              : [
                  BoxShadow(
                    color: AppColors.lime.withOpacity(_pressed ? 0.3 : 0.55),
                    blurRadius: _pressed ? 12 : 32,
                    offset: Offset(0, _pressed ? 4 : 12),
                  ),
                ],
        ),
        transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0)
          ..scale(_pressed ? 0.97 : 1.0),
        child: Center(
          child: widget.isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.limeT,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.limeT,
                      ),
                    ),
                  ],
                )
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: widget.ghost ? AppColors.ink : AppColors.limeT,
                  ),
                ),
        ),
      ),
    );
  }
}
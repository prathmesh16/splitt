import 'package:flutter/material.dart';
import 'package:splitt/theme/theme_extension.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const Button({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.c.primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Text(
            label,
            style: context.f.body2.copyWith(
              color: context.c.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

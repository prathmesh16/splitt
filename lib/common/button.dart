import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splitt/theme/theme_extension.dart';

enum ButtonState { idle, loading }

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonState state;

  const Button({
    super.key,
    required this.label,
    this.onTap,
    this.state = ButtonState.idle,
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
          child: state == ButtonState.idle
              ? Text(
                  label,
                  style: context.f.body2.copyWith(
                    color: context.c.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20,
                ),
        ),
      ),
    );
  }
}

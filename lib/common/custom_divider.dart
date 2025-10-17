import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;

  const CustomDivider({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: color ?? Colors.grey[300],
    );
  }
}

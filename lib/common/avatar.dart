import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double? height;
  final double? width;

  const Avatar({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 36,
      width: width ?? 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.network(
        "https://avatar.iran.liara.run/public/boy",
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            height: height ?? 36,
            width: width ?? 36,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
          );
        },
      ),
    );
  }
}

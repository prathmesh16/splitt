import 'package:flutter/material.dart';

class ElevatedWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? horizontalPadding;
  final double? verticalPadding;

  const ElevatedWidget({
    super.key,
    required this.child,
    this.onTap,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  State<ElevatedWidget> createState() => _ElevatedWidgetState();
}

class _ElevatedWidgetState extends State<ElevatedWidget> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped = false;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black12, width: 0.5),
          boxShadow: !_isTapped
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        margin: const EdgeInsets.all(1),
        padding: EdgeInsets.symmetric(
          vertical: widget.verticalPadding ?? 6,
          horizontal: widget.horizontalPadding ?? 6,
        ),
        child: widget.child,
      ),
    );
  }
}

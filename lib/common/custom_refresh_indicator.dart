import 'package:flutter/material.dart';
import 'package:splitt/theme/theme_extension.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final ScrollController controller;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    required this.controller,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  double dragOffset = 0;
  bool isDragging = false;
  bool isRefreshing = false;
  bool show = true;

  static const double trigger = 120;

  late AnimationController snapBackController;
  late Animation<double> snapBackAnimation;

  @override
  void initState() {
    super.initState();

    snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    snapBackController.dispose();
    super.dispose();
  }

  void snapBack({
    bool show = true,
  }) {
    setState(() {
      this.show = show;
    });
    snapBackAnimation = Tween<double>(begin: dragOffset, end: 0).animate(
      CurvedAnimation(parent: snapBackController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          dragOffset = snapBackAnimation.value;
          if (snapBackAnimation.isCompleted) {
            this.show = true;
          }
        });
      });
    snapBackController.reset();
    snapBackController.forward();
  }

  Future<void> triggerRefresh() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
      dragOffset = trigger;
    });

    await widget.onRefresh();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => isRefreshing = false);
        snapBack(show: false);
      }
    });
  }

  bool atTop() {
    return widget.controller.positions.isNotEmpty &&
        widget.controller.offset <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (details) {
        if (!isRefreshing) {
          setState(() {
            isDragging = true;
            dragOffset += details.delta.dy * 0.5;
            dragOffset = dragOffset.clamp(0, trigger);
          });
        }
      },
      onPointerUp: (_) {
        if (isDragging) {
          isDragging = false;
          if (dragOffset >= trigger) {
            triggerRefresh();
          } else if (dragOffset > 0) {
            snapBack();
          }
        }
      },
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, dragOffset),
            child: widget.child,
          ),
          if (dragOffset > 0 && show)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: dragOffset,
              child: Center(
                child:
                    isRefreshing ? _loader() : _progress(dragOffset / trigger),
              ),
            ),
        ],
      ),
    );
  }

  Widget _progress(double value) {
    return SizedBox(
      height: 32,
      width: 32,
      child: CircularProgressIndicator(
        value: value.clamp(0, 1),
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(context.c.primaryColor),
      ),
    );
  }

  Widget _loader() {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: context.c.primaryColor,
        shape: BoxShape.circle,
      ),
      child: const Padding(
        padding: EdgeInsets.all(7),
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}

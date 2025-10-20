import 'package:flutter/material.dart';
import 'package:splitt/theme/theme_extension.dart';

class HierarchyWidget extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  final double childLeftPadding;

  const HierarchyWidget({
    super.key,
    required this.header,
    required this.children,
    required this.childLeftPadding,
  });

  @override
  Widget build(BuildContext context) {
    final length = children.length;
    return Column(
      children: [
        header,
        ...children
            .asMap()
            .map(
              (index, child) => MapEntry(
                index,
                Padding(
                  padding: EdgeInsets.only(left: childLeftPadding),
                  child: IntrinsicHeight(
                    child: Row(
                      key: key,
                      children: [
                        _VerticalLine(
                          isLast: length - 1 == index,
                        ),
                        Container(
                          width: 24,
                          height: 1,
                          color: context.c.hintColor,
                        ),
                        const SizedBox(width: 8),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            )
            .values,
      ],
    );
  }
}

class _VerticalLine extends StatefulWidget {
  const _VerticalLine({
    required this.isLast,
  });

  final bool isLast;

  @override
  State<_VerticalLine> createState() => _VerticalLineState();
}

class _VerticalLineState extends State<_VerticalLine> {
  double lineHeight = 0;
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          lineHeight = renderBox.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: 1,
      margin: EdgeInsets.only(
        bottom: widget.isLast ? lineHeight / 2 : 0,
      ),
      color: context.c.hintColor,
    );
  }
}

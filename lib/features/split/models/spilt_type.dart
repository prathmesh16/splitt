import 'package:flutter/material.dart';

enum SplitType {
  equal,
  amount,
  percentage,
  share,
  adjustment;

  Widget get tab => switch (this) {
        SplitType.equal => const Text("="),
        SplitType.amount => const Text("1.23"),
        SplitType.percentage => const Text("%"),
        SplitType.share => const Icon(Icons.bar_chart_outlined),
        SplitType.adjustment => const Text("+/-"),
      };
}

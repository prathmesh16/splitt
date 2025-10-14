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

  String get splitTypeName => this == SplitType.equal ? "equally" : "unequally";

  String get backendValue => switch (this) {
        SplitType.equal => "EQUAL_SPLIT",
        SplitType.amount => "EXACT_AMOUNT_SPLIT",
        SplitType.percentage => "SPLIT_BY_PERCENTAGES",
        SplitType.share => "SHARES_SPLIT",
        SplitType.adjustment => "ADJUSTMENT_SPLIT",
      };

  static SplitType fromString(String value) {
    switch (value) {
      case 'EQUAL_SPLIT':
        return SplitType.equal;
      case 'EXACT_AMOUNT_SPLIT':
        return SplitType.amount;
      case 'SPLIT_BY_PERCENTAGES':
        return SplitType.percentage;
      case 'SHARES_SPLIT':
        return SplitType.share;
      case 'ADJUSTMENT_SPLIT':
        return SplitType.adjustment;
      default:
        throw ArgumentError('Invalid SplitType: $value');
    }
  }
}

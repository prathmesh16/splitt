import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitt/theme/colors.dart';
import 'package:splitt/theme/fonts.dart';

extension AppThemeExtension on BuildContext {
  IColors get c => LightColors();

  IFonts get f => LightFonts();
}

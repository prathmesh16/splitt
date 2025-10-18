import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitt/theme/colors.dart';

abstract class IFonts {
  TextStyle get heading1;

  TextStyle get heading2;

  TextStyle get body1;

  TextStyle get body2;

  TextStyle get body3;
}

class LightFonts implements IFonts {
  IColors get colors => LightColors();

  @override
  TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: colors.primaryTextColor,
      );

  @override
  TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 20,
        color: colors.primaryTextColor,
      );

  @override
  TextStyle get body1 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.primaryTextColor,
      );

  @override
  TextStyle get body2 => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.primaryTextColor,
      );

  @override
  TextStyle get body3 => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.primaryTextColor,
      );
}

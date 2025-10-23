import 'dart:ui';

abstract class IColors {
  Color get primaryColor;

  Color get secondaryColor;

  Color get backgroundColor;

  Color get primaryTextColor;

  Color get secondaryTextColor;

  Color get hintColor;

  Color get white;

  Color get black;

  Color get inactiveColor;

  Color get darkPrimary;
}

class LightColors implements IColors {
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF);

  @override
  Color get hintColor => const Color(0xBFe5e8ee);

  @override
  Color get primaryColor => const Color(0xFF21a987);

  @override
  Color get primaryTextColor => const Color(0xFF383c40);

  @override
  Color get secondaryColor => const Color(0xFFed5f0f);

  @override
  Color get secondaryTextColor => const Color(0xFF727a82);

  @override
  Color get black => const Color(0xFF000000);

  @override
  Color get white => const Color(0xFFFFFFFF);

  @override
  Color get inactiveColor => const Color(0xFFc9d3dc);

  @override
  Color get darkPrimary => const Color(0xFF1c856c);
}

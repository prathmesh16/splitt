import 'dart:ui';

abstract class IColors {
  Color get primaryColor;

  Color get secondaryColor;

  Color get backgroundColor;

  Color get primaryTextColor;

  Color get secondaryTextColor;

  Color get hintColor;
}

class LightColors implements IColors {
  @override
  Color get backgroundColor => const Color(0xFFF4F6F8);

  @override
  Color get hintColor => const Color(0xBFb2beb5);

  @override
  Color get primaryColor => const Color(0xFF1CC29F);

  @override
  Color get primaryTextColor => const Color(0xFF101010);

  @override
  Color get secondaryColor => const Color(0xFFEC5601);

  @override
  Color get secondaryTextColor => const Color(0xFF979797);
}

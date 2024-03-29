import 'dart:ui';

abstract class Palette {
  static const primary = Color.fromRGBO(255, 128, 170, 1);

  /// Pressed / Splash / Selected color
  static const primaryLight = Color.fromRGBO(253, 161, 191, 1);

  static const primaryDark = Color.fromRGBO(255, 77, 136, 1);
  static const secondary = Color.fromRGBO(143, 191, 175, 1);

  static const white = Color.fromRGBO(244, 248, 249, 1);
  static const black = Color.fromRGBO(27, 27, 29, 1);

  /// Disabled color
  static const grey = Color.fromRGBO(147, 151, 155, 1);

  /// Hover color
  static const lightGrey = Color.fromRGBO(200, 205, 210, 1);
}

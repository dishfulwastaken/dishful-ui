import 'package:dishful/theme/font.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  primaryColor: Palette.primary,
  primaryColorDark: Palette.primaryDark,
  primaryColorLight: Palette.primaryLight,
  secondaryHeaderColor: Palette.secondary,
  scaffoldBackgroundColor: Palette.white,
  textTheme: TextTheme(
    titleSmall: titleTextStyle.copyWith(fontSize: 18),
    titleMedium: titleTextStyle,
    titleLarge: titleTextStyle.copyWith(fontSize: 28),
    bodyMedium: bodyTextStyle,
  ),
  iconTheme: IconThemeData(color: Palette.lightGrey),
  scrollbarTheme: ScrollbarThemeData(),
  buttonTheme: ButtonThemeData(
    shape: StadiumBorder(),
    buttonColor: Palette.secondary,
    disabledColor: Palette.disabled,
  ),
);

final _baseTextStyle = TextStyle(
  fontFamily: Fonts.rest,
  color: Palette.black,
);

final titleTextStyle = _baseTextStyle.copyWith(
  fontWeight: FontWeight.bold,
  fontSize: 22,
);
final bodyTextStyle = _baseTextStyle.copyWith(fontSize: 16);

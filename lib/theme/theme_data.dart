import 'package:dishful/theme/font.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  fontFamily: Fonts.text,
  primaryColor: Palette.primary,
  primaryColorDark: Palette.primaryDark,
  primaryColorLight: Palette.primaryLight,
  secondaryHeaderColor: Palette.secondary,
  scaffoldBackgroundColor: Colors.transparent,
  textTheme: TextTheme(
    headline1: headlineTextStyle,
    headline2: headlineTextStyle,
    headline3: headlineTextStyle,
    headline4: headlineTextStyle,
    headline5: headlineTextStyle,
    headline6: headlineTextStyle,
    subtitle1: subtitleTextStyle,
    subtitle2: subtitleTextStyle,
    bodyText1: bodyTextStyle,
    bodyText2: bodyTextStyle,
    caption: bodyTextStyle,
    button: bodyTextStyle,
  ),
  iconTheme: IconThemeData(color: Colors.white),
  scrollbarTheme: ScrollbarThemeData(),
  buttonTheme: ButtonThemeData(
    shape: StadiumBorder(),
    buttonColor: Palette.secondary,
    disabledColor: Palette.disabled,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Palette.primaryDark,
    elevation: 0,
  ),
);

final headlineTextStyle = TextStyle(fontFamily: Fonts.headline);
final subtitleTextStyle = TextStyle(
  fontFamily: Fonts.text,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
final bodyTextStyle = TextStyle(
  fontFamily: Fonts.text,
  fontSize: 13,
  // color: Colors.white,
);

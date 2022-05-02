import 'package:dishful/theme/font.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  primaryColor: Palette.primary,
  primaryColorDark: Palette.primaryDark,
  primaryColorLight: Palette.primaryLight,
  secondaryHeaderColor: Palette.secondary,
  scaffoldBackgroundColor: Palette.white,
  canvasColor: Palette.white,
  backgroundColor: Palette.white,
  splashColor: Palette.primaryLight,
  textTheme: TextTheme(
    titleSmall: titleTextStyle.copyWith(fontSize: 18),
    titleMedium: titleTextStyle,
    titleLarge: titleTextStyle.copyWith(fontSize: 28),
    bodyMedium: bodyTextStyle,
    bodySmall: bodyTextStyle.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      height: 1.8,
    ),
  ),
  iconTheme: IconThemeData(color: Palette.lightGrey),
  scrollbarTheme: ScrollbarThemeData(),
  buttonTheme: ButtonThemeData(
    disabledColor: Palette.grey,
    hoverColor: Palette.lightGrey,
    splashColor: Palette.primaryLight,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.pressed))
            return Palette.primaryLight;
          if (states.contains(MaterialState.hovered)) return Palette.lightGrey;

          return Colors.white;
        },
      ),
    ),
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

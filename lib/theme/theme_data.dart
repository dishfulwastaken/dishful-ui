import 'package:dishful/theme/font.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  fontFamily: Fonts.text,
  primaryColor: Palette.primary,
  primaryColorDark: Palette.primaryDark,
  primaryColorLight: Palette.primaryLight,
  secondaryHeaderColor: Palette.secondary,
  scaffoldBackgroundColor: Colors.grey.shade50,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    backgroundColor: Colors.white,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.grey.shade400,
  ),
  textTheme: TextTheme(
    headlineSmall: headlineSmallTextStyle,
    headlineMedium: headlineTextStyle,
    titleMedium: titleTextStyle,
    bodyMedium: bodyTextStyle,
    labelMedium: bodyTextStyle,
  ),
  iconTheme: IconThemeData(color: Colors.grey.shade50),
  scrollbarTheme: ScrollbarThemeData(),
  buttonTheme: ButtonThemeData(
    shape: StadiumBorder(),
    buttonColor: Palette.secondary,
    disabledColor: Palette.disabled,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade50,
    elevation: 0,
  ),
);

final headlineTextStyle = TextStyle(
  fontFamily: Fonts.headline,
  fontSize: 38,
  height: 1.15,
  color: Colors.black87,
);
final headlineSmallTextStyle = TextStyle(
  fontFamily: Fonts.headline,
  fontSize: 28,
  color: Colors.black87,
);
final titleTextStyle = TextStyle(
  fontFamily: Fonts.text,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
final bodyTextStyle = TextStyle(
  fontFamily: Fonts.text,
  fontSize: 13,
  // color: Colors.white,
);

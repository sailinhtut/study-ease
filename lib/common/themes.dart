import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/common/colors.dart';

// Light Theme
final lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    primarySwatch: createMaterialColor(primaryLight),
    textTheme: const TextTheme(
        headline6: TextStyle(color: Color(0xff333333)),
        bodyText2: TextStyle(color: Color(0xff333333)),
        subtitle2: TextStyle(color: Colors.black54)),
    dividerTheme: const DividerThemeData(color: Colors.grey),
    scaffoldBackgroundColor: backgroundLight,
    backgroundColor: surfaceLight,
    cardColor: appBarLight,
    cardTheme: CardTheme(shape: dialogShape(10), elevation: 3),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: radius(10))),
            backgroundColor: MaterialStateProperty.all(Colors.redAccent))),
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemStatusBarContrastEnforced: false,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: appBarLight,
        elevation: 1,
        foregroundColor: Color(0xff333333)));

// Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.poppins().fontFamily,
  primaryColor: primaryDark,
  primarySwatch: createMaterialColor(primaryDark),
  textTheme: const TextTheme(
      headline6: TextStyle(color: Color(0xffd1d1d1)),
      bodyText2: TextStyle(color: Color(0xffd1d1d1)),
      subtitle2: TextStyle(color: Colors.white54)),
  dividerTheme: const DividerThemeData(color: Colors.grey),
  scaffoldBackgroundColor: backgroundDark,
  backgroundColor: surfaceDark,
  cardColor: appBarDark,
  cardTheme: CardTheme(shape: dialogShape(10), elevation: 3),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: radius(10))),
          backgroundColor: MaterialStateProperty.all(Colors.redAccent))),
  appBarTheme: const AppBarTheme(
      backgroundColor: appBarDark,
      systemOverlayStyle: SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: false,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      elevation: 1,
      foregroundColor: Color(0xfff1f2f3)),
  dialogBackgroundColor: const Color(0xff0F0F0F),
);

/// System navigation bar color
void changeNavigationBarState(bool isDarkMode) {
  if (isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: appBarDark,
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: appBarLight,
    ));
  }
}

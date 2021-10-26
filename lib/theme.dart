import 'package:flutter/material.dart';

//color
const Color primaryColor = Color(0xFFFF8E6E);
const Color primaryLight = Color(0xFFFFBB91);
const Color primaryDark = Color(0xFFc85f42);
const Color secondaryColor = Color(0xFF515070);
const Color secondaryLight = Color(0xFF7E7C9F);
const Color secondaryDark = Color(0xFF272845);
const Color errorColor = Color(0xFFFF0000);
const Color surfaceColor = Colors.white;
const Color backgroundColor = Color(0xFFF6F6F6);
const Color whiteColor = Colors.white;

//color scheme
const ColorScheme _appColorScheme = ColorScheme(
  primary: secondaryColor,
  primaryVariant: primaryDark,
  secondary: secondaryColor,
  secondaryVariant: secondaryLight,
  surface: surfaceColor,
  background: backgroundColor,
  error: errorColor,
  onPrimary: whiteColor,
  onSecondary: whiteColor,
  onSurface: secondaryColor,
  onBackground: secondaryColor,
  onError: whiteColor,
  brightness: Brightness.light,
);

//text theme
const TextTheme textTheme = TextTheme(
  headline3: TextStyle(fontSize: 53, fontWeight: FontWeight.w400),
  headline4: TextStyle(fontSize: 38, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: TextStyle(fontSize: 27, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      // Define text theme
      fontFamily: "Prompt",
      textTheme: textTheme,

      //define the default brightness and color
      colorScheme: _appColorScheme,
      // accentColor: secondaryColor,
      primaryColor: primaryColor,
      // buttonColor: secondaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      errorColor: errorColor,
      indicatorColor: whiteColor,
      // inputDecorationTheme: InputDecorationTheme(
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //       width: 2.0,
      //       color: secondaryColor,
      //     ),
      //   ),
      //   border: OutlineInputBorder(),
      // ),
      buttonTheme: const ButtonThemeData(
        colorScheme: _appColorScheme,
        // textTheme: textTheme,
      ),
      // textSelectionColor: secondaryColor,
      // cursorColor: secondaryColor ,
    );
  }
}

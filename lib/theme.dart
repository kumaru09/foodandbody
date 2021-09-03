import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get themeData {
    //text theme
    const TextTheme textTheme = TextTheme(
        headline3: TextStyle(fontSize: 53, fontWeight: FontWeight.w300),
        headline4: TextStyle(fontSize: 38, fontWeight: FontWeight.w300),
        headline5: TextStyle(fontSize: 27, fontWeight: FontWeight.w300),
        headline6: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        subtitle1: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        subtitle2: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        bodyText2: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
        button: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        caption: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        overline: TextStyle(fontSize: 11, fontWeight: FontWeight.w300));

    return ThemeData(
        // Define text theme
        fontFamily: "Prompt",
        textTheme: textTheme,

        //define the default brightness and color
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(255, 142, 110, 1.0),
        accentColor: Color.fromRGBO(81, 80, 112, 1.0));
  }
}
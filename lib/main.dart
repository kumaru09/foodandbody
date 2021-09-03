import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(255, 142, 110, 1.0),
        accentColor: Color.fromRGBO(81, 80, 112, 1.0),

        // Define the default font family.
        fontFamily: 'Prompt',

        // Define the default TextTheme. Use this to specify the default text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 106, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: TextStyle(
              fontSize: 66, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3: TextStyle(fontSize: 53, fontWeight: FontWeight.w400),
          headline4: TextStyle(
              fontSize: 38, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headline5: TextStyle(fontSize: 27, fontWeight: FontWeight.w400),
          headline6: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          caption: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
        // cardTheme : const CardTheme(
        //   color: Colors.white,
        //   // shape: ShapeBorder(),
        //   // shadowColor: Shadow
        // )
      ),
      home: Start(),
    );
  }
}

class Start extends StatelessWidget {
  const Start({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
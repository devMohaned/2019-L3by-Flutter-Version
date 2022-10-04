import 'package:flutter/material.dart';

class Utils{

  ThemeData myThemeData = ThemeData.dark().copyWith(
      cursorColor: Colors.white,
      textSelectionHandleColor: Colors.white,
      accentColor: Colors.white,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey[700],
      ),
      inputDecorationTheme: new InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          gapPadding: 10.0,
        ),
      ));


}
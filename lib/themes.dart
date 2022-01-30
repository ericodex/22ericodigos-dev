import 'package:flutter/material.dart';

// Theme Dark
final ThemeData _darkTheme = ThemeData(
  //primarySwatch: Colors.green,
  //primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
      onPrimary: Colors.amber,
      secondary: Colors.green,
      onSecondary: Colors.pink,
      primary: Colors.green,
      background: Colors.cyan,
      brightness: Brightness.dark,
      primaryVariant: Colors.greenAccent,
      onBackground: Colors.purple,
      onSurface: Colors.green,
      secondaryVariant: Colors.black12,
      surface: Colors.black38,
      error: Colors.red,
      onError: Colors.redAccent),
);

// Theme Light
final ThemeData _lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
     primary: Colors.green,
     onPrimary: Colors.white,
     secondary: Colors.green,
     onSecondary: Colors.pink,
     background: Colors.cyan,
     brightness: Brightness.light,
     primaryVariant: Colors.greenAccent,
     //onBackground: Colors.purple,
     onSurface: Colors.green,
     //secondaryVariant: Colors.blueGrey,
     surface: Colors.grey,
     error: Colors.red,
     onError: Colors.redAccent
  ),
);


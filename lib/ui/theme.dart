import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Themes {
  static final light = ThemeData(
    primaryColor: Colors.indigo,
    primarySwatch:Colors.indigo ,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo
    ),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    primarySwatch:Colors.indigo,
    primaryColor: Colors.indigo,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    brightness: Brightness.dark,
  );
}



TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,

    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,

    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,

    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,

    ),
  );
}

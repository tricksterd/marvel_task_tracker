import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static const Color primaryRed = Color.fromARGB(255, 237, 29, 36);
  static const Color primaryOrange = Color.fromARGB(255, 255, 102, 0);
  static const Color darkBlue = Color.fromARGB(255, 0, 31, 84);
  static const Color grey = Color.fromARGB(255, 55, 71, 79);

  static TextStyle get titleText => GoogleFonts.bangers(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: primaryRed,
      );

  static TextStyle get inputLabel => GoogleFonts.bangers(
        fontSize: 20,
        letterSpacing: 2,
      );

  static TextStyle get inputText => GoogleFonts.bangers(
        fontSize: 16,
        letterSpacing: 2,
      );

  static TextStyle get buttonText => titleText.copyWith(
        color: Colors.white,
        fontSize: 20,
      );
  static TextStyle get linkTextDefault => GoogleFonts.bangers(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      );

  static TextStyle get linkTextActive => linkTextDefault.copyWith(
        color: Colors.blue[700],
      );

  static TextStyle get primaryText => GoogleFonts.bangers(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Colors.black,
      );

  static TextStyle get secondaryText => GoogleFonts.bangers(
        fontSize: 15,
        letterSpacing: 2,
        color: Colors.black,
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SnackBar styledSnackbar(String text, [double? fontSize]) {
  return SnackBar(
    backgroundColor: const Color.fromARGB(255, 237, 29, 36),
    content: Text(
      text,
      style: GoogleFonts.bangers(
        fontSize: fontSize ?? 26,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Colors.white,
      ),
    ),
  );
}

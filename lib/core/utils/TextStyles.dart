import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle(
    {Color? color = Colors.blue,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w700}) {
  return GoogleFonts.almarai(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

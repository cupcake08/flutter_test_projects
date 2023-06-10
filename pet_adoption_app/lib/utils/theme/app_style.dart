import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

sealed class AppColor {
  static const Color orange = Color(0xFFFCAB4C);
  static const Color iconColor = Color.fromARGB(255, 205, 81, 36);
}

sealed class Styles {
  static ThemeData themeData(ThemeMode themeMode) {
    return ThemeData(
      colorScheme: themeMode == ThemeMode.dark
          ? const ColorScheme.dark(
              secondary: Color.fromARGB(255, 252, 208, 157),
            )
          : const ColorScheme.light(
              secondary: AppColor.orange,
            ),
      fontFamily: GoogleFonts.oswald().fontFamily,
    );
  }
}

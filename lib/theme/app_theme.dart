import 'package:flutter/material.dart';

class AppTheme {
  // 🌸 Light Mode (Pastel Wellness)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "SF Pro",
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: Colors.purple.shade300,
      secondary: Colors.pink.shade200,
    ),
  );

  // 🌙 Dark Mode (Galaxy Calm Theme)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "SF Pro",
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9D84FF),
      secondary: Color(0xFFCE9CFF),
    ),
  );
}

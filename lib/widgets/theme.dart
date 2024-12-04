import 'package:flutter/material.dart';

// Light theme configuration
final ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Default text color for bodyLarge
    bodyMedium: TextStyle(color: Colors.black), // Default text color for bodyMedium
    headlineMedium: TextStyle(color: Colors.black), // Default color for headlineMedium
    titleLarge: TextStyle(color: Colors.black), // Default color for titleLarge
  ),
  brightness: Brightness.light, // Set theme brightness to light
  primaryColor: Colors.black, // Primary color for the light theme
);

// Dark theme configuration
final ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Default text color for bodyLarge
    bodyMedium: TextStyle(color: Colors.white), // Default text color for bodyMedium
    headlineMedium: TextStyle(color: Colors.white), // Default color for headlineMedium
    titleLarge: TextStyle(color: Colors.white), // Default color for titleLarge
  ),
  brightness: Brightness.dark, // Set theme brightness to dark
  primaryColor: Colors.white12, // Primary color for the dark theme
);

// Theme notifier to manage theme mode changes
class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default theme is system's setting

  ThemeMode get themeMode => _themeMode; // Getter for the current theme mode

  // Set the theme mode and notify listeners of the change
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

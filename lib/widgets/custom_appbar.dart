import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatbot_gemini/widgets/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.appbarTitle});

  final String appbarTitle; // Title to display in the app bar

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode from ThemeNotifier
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Change gradient colors based on theme mode
            colors: themeNotifier.themeMode == ThemeMode.light
                ? [Colors.blue.shade200, Colors.blue.shade400] // Light theme colors
                : [Colors.black, Colors.blue.shade800], // Dark theme colors
          ),
        ),
      ),
      elevation: 6.0, // Shadow effect for app bar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Rounded corners at the bottom
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            // Toggle icon based on current theme mode
            themeNotifier.themeMode == ThemeMode.light
                ? Icons.brightness_7 // Light mode icon
                : Icons.brightness_4, // Dark mode icon
            color: Colors.white,
          ),
          onPressed: () {
            // Toggle between light and dark themes
            if (themeNotifier.themeMode == ThemeMode.light) {
              themeNotifier.setTheme(ThemeMode.dark); // Switch to dark theme
            } else {
              themeNotifier.setTheme(ThemeMode.light); // Switch to light theme
            }
          },
        ),
      ],
      title: Text(
        appbarTitle, // Title passed to the app bar
        style: TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 5.0,
              color: Colors.black.withOpacity(0.5), // Text shadow effect
            ),
          ],
        ),
      ),
    );
  }
}

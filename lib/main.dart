import 'package:flutter/material.dart';
import 'package:chatbot_gemini/UI/home.dart';
import 'package:chatbot_gemini/UI/chat.dart';
import 'package:chatbot_gemini/widgets/theme.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Providing the theme change notifier for the entire app
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Chatbot',
          themeAnimationCurve: Curves.easeInSine,
          themeAnimationDuration: const Duration(milliseconds: 500),
          debugShowCheckedModeBanner: false, // Hide the debug banner
          theme: lightTheme, // Light theme
          darkTheme: darkTheme, // Dark theme
          themeMode: themeNotifier.themeMode, // Dynamically switch themes
          initialRoute: LandingScreen.routeName, // Initial screen route
          routes: {
            LandingScreen.routeName: (context) => const LandingScreen(),
            ChatScreen.routeName: (context) => const ChatScreen(),
          },
          onGenerateRoute: (settings) {
            // Handling custom route generation for the chat screen
            if (settings.name == ChatScreen.routeName) {
              final sessionId = _generateSessionId();
              return MaterialPageRoute(
                builder: (context) => const ChatScreen(),
                settings: RouteSettings(arguments: sessionId),
              );
            }
            return null;
          },
        );
      },
    );
  }

  // Helper method to generate a unique session ID
  String _generateSessionId() {
    final random = Random();
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString() +
        random.nextInt(1000).toString();
    return sessionId;
  }
}

void main() {
  runApp(const ChatApp()); // Run the app
}

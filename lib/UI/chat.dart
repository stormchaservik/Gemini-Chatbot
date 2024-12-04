import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:chatbot_gemini/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController(); // Controller for the input field
  List<Map<String, dynamic>> chatHistory = []; // Stores chat history
  bool isLoading = false; // Flag to show loading spinner
  late String sessionId; // Unique session ID for the chat

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve session ID from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      sessionId = args;
      _loadChatHistory(); // Load chat history for the session
    }
  }

  // Load chat history from SharedPreferences
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChats = prefs.getStringList('savedChats') ?? [];
    final savedSession = savedChats.firstWhere(
          (chat) => jsonDecode(chat)['sessionId'] == sessionId,
      orElse: () => '{}', // Empty string if session is not found
    );
    if (savedSession.isNotEmpty) {
      final chatData = jsonDecode(savedSession) as Map<String, dynamic>;
      setState(() {
        chatHistory = List<Map<String, dynamic>>.from(chatData['chatHistory']);
      });
    }
  }

  // Save chat history to SharedPreferences
  Future<void> saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedChats = prefs.getStringList('savedChats') ?? [];

    final chatData = jsonEncode({
      'sessionId': sessionId,
      'chatHistory': chatHistory,
    });

    savedChats
        .removeWhere((chat) => jsonDecode(chat)['sessionId'] == sessionId);
    savedChats.add(chatData);
    await prefs.setStringList('savedChats', savedChats);
  }

  // Get answer from generative AI model
  void getAnswer(String text) async {
    late final dynamic response;
    const apiKey = "YOUR_API_KEY"; // API key for the AI model
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-8b',
      apiKey: apiKey,
    );
    dynamic content;

    // Handle specific case for adding events to the calendar
    if (text.contains("add to calendar")) {
      final now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      content =
      "$text. This is the event. Today is $formattedDate. Return a response in the format {\"title\", \"description\", \"location\", \"startDate\", \"endDate\"} only and nothing else.";
      response = await model.generateContent([Content.text(content)]);
      dynamic calValues = jsonDecode(response.text) as Map<String, dynamic>;
      final Event event = Event(
        title: calValues['title'],
        description: calValues['description'],
        location: calValues['location'],
        startDate: DateTime.parse(calValues['startDate']),
        endDate: DateTime.parse(calValues['endDate']),
      );
      Add2Calendar.addEvent2Cal(event); // Add the event to the calendar
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    } else {
      setState(() {
        isLoading = true; // Start loading indicator
      });
      content = text;
      response = await model.generateContent([Content.text(content)]);
      setState(() {
        chatHistory.add({
          "message": response.text,
          "isSender": false, // Message from the AI (not the user)
        });
        isLoading = false; // Stop loading indicator
      });
    }
    await saveChatHistory(); // Save chat history after getting the response
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      appBar: const CustomAppBar(appbarTitle: 'Chat with Gemini'),
      resizeToAvoidBottomInset: true, // Ensure the keyboard doesn't overlap UI
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // Scroll from the bottom
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    ...chatHistory.map((msg) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: Align(
                          alignment: (msg["isSender"]
                              ? Alignment.topRight
                              : Alignment.topLeft),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (msg["isSender"]
                                  ? const Color(0xFF6BCEF3)
                                  : const Color(0xFFF3F3F3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              msg["message"],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: msg["isSender"]
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Show loading spinner while waiting for response
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.lightBlueAccent, size: 40),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, -5), // Shadow on top
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.5)
                                : const Color(0xFF001D2B),
                            width: 1,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: _chatController,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          if (_chatController.text.isNotEmpty) {
                            chatHistory.add({
                              "message": _chatController.text,
                              "isSender": true, // Message from the user
                            });
                          }
                          isLoading = true; // Start loading animation
                        });
                        getAnswer(_chatController.text); // Get AI response
                        _chatController.clear(); // Clear the input field
                      },
                      color: const Color(0xE400E8FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.topLeft,
                            colors: [Color(0xFF6A00FF), Color(0xFF00C6FF)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

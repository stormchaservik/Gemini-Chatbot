import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_history_page.dart';
import 'package:chatbot_gemini/widgets/custom_appbar.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/home';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Map<String, dynamic>> recentChats = []; // Stores the recent chats

  // Load saved chat history from SharedPreferences
  Future<void> loadSavedChats() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChats = prefs.getStringList('savedChats') ?? [];

    setState(() {
      recentChats = savedChats
          .map((chatData) => jsonDecode(chatData) as Map<String, dynamic>)
          .toList(); // Convert saved chat data into a list of maps
    });
  }

  @override
  void initState() {
    super.initState();
    loadSavedChats(); // Load recent chats when screen is initialized
  }

  // Delete a specific chat from the saved chats
  Future<void> deleteChat(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedChats = prefs.getStringList('savedChats') ?? [];

    savedChats.removeAt(index); // Remove the selected chat
    await prefs.setStringList('savedChats', savedChats); // Save updated chats
    loadSavedChats(); // Reload the chat list after deletion
  }

  // Refresh the recent chats list
  Future<void> _refreshChats() async {
    await loadSavedChats(); // Reload saved chats
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      appBar: const CustomAppBar(appbarTitle: 'Home'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card with button to start a new chat
            Card(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color(0xFF6A00FF),
                      Color(0xFF00C6FF),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            "Hello! Ask Me Anything",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16.0, bottom: 16.0),
                          child: TextButton(
                            onPressed: () async {
                              // Navigate to the chat screen with a new session ID
                              final result = await Navigator.pushNamed(
                                context,
                                '/chat',
                                arguments: DateTime.now().toIso8601String(),
                              );
                              if (result != null) {
                                loadSavedChats(); // Reload chats if there's a result
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 30)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0))),
                            ),
                            child: const Text(
                              "Ask Now",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A00FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Recent Chats Section
            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 16.0),
              child: Text(
                "Recent Chats",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Display a list of recent chats with the option to delete
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshChats, // Allow pull-to-refresh
                child: recentChats.isEmpty
                    ? const Center(child: Text("No recent chats"))
                    : ListView.builder(
                  itemCount: recentChats.length,
                  itemBuilder: (context, index) {
                    final chat = recentChats[index];
                    final chatPreview = chat['chatHistory'].isNotEmpty
                        ? chat['chatHistory'][0]['message']
                        : "No messages"; // Preview of the first message

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? theme.cardColor.withOpacity(0.2)
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          "Session #${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica',
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        subtitle: Text(
                          chatPreview, // Display the chat preview
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        onTap: () {
                          // Navigate to chat history page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatHistoryPage(
                                chatHistory: List<Map<String, dynamic>>.from(
                                    chat['chatHistory']),
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () async {
                            await deleteChat(index); // Delete chat
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

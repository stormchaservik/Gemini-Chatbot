import 'package:chatbot_gemini/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> chatHistory; // List of messages in the chat

  const ChatHistoryPage({
    super.key,
    required this.chatHistory, // Accepts the chat history passed from previous screen
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appbarTitle: 'Chat History', // Title for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chat History", // Section header
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              // Display the list of chat messages
              child: ListView.builder(
                itemCount: chatHistory.length, // Number of messages in chatHistory
                itemBuilder: (context, index) {
                  final chatMessage = chatHistory[index]; // Individual chat message

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      // Align the message based on the sender
                      alignment: (chatMessage["isSender"]
                          ? Alignment.topRight // Align sender messages to the right
                          : Alignment.topLeft), // Align receiver messages to the left
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: chatMessage["isSender"]
                              ? const Color(0xFF6BCEF3) // Sender's message color
                              : Colors.white, // Receiver's message color
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          chatMessage["message"], // Display the message text
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 16,
                            color: chatMessage["isSender"]
                                ? Colors.white // Sender message text color
                                : Colors.black, // Receiver message text color
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

# Gemini Chatbot

## Description

A simple chatbot built using Google's Gemini model and Flutter framework. Chat with Gemini, view recent chats, and explore all previous chat history. The app also includes basic calendar integration, enabling adding events directly to device calendar.

**Note on Calendar Integration:**
The current handling of calendar event input is an **experimental feature**. It works by checking for specific substrings in the user's messages to identify event-related content. However, this approach is unreliable and may lead to inaccurate or inconsistent event detection. The feature requires further enhancement.

## Features

- **Chat Interface:** Communicate with the chatbot and receive responses.
- **Recent Chats:** View a list of recent chatbot sessions.
- **Chat History:** Review past conversations in detail.
- **Dark/Light Mode:** Toggle between light and dark themes.
- **Calendar Integration:** Add events directly to your device calendar from the chat conversations.

## Packages

- **Gemini (Google's Generative AI)**
- **Provider state management package**
- **loading_animation_widget**
- **shared_preferences**
- **flutter_native_splash**
- **add_2_calendar**

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/stormchaservik/gemini_chatbot.git
    ```

2. Navigate to the project directory:
    ```bash
    cd gemini_chatbot
    ```

3. Install dependencies:
    ```bash
    flutter pub get
    ```

4. **Get your own API key for Gemini API from Google's AI Studio:**
    - Go to [Google AI Studio](https://ai.google/) and sign in.
    - Set up a new project and obtain an API key for the Gemini API.
    - Replace the placeholder in `chat.dart` with your API key.

5. Run the app:
    ```bash
    flutter run
    ```

## Configuration

- You can modify the `assets/images/splash.png` file to customize the splash screen.
- Adjust the `google_generative_ai` API setup in the `chat.dart` file to use a different model.

## Contributing

Not accepting contributions at the moment. If you find any bugs or have improvement suggestions, please open an issue.

## License

This project is open-source and available under the [GPL-3.0 License](LICENSE).

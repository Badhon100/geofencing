import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> sendMessage(String message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl() : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    developer.log('ChatRemoteDataSource initialized', name: 'ChatAPI');
  }

  @override
  Future<ChatMessageModel> sendMessage(String message) async {
    developer.log('Sending message: "$message"', name: 'ChatAPI');
    
    // List of chat providers (using local chatbot since free APIs are deprecated)
    final List<_ChatProvider> providers = [
      // Smart local chatbot - always works, no API needed
      _SmartMockProvider(),
      
      // Basic fallback (should never be needed)
      _MockProvider(),
    ];

    // Try each provider until one succeeds
    for (var i = 0; i < providers.length; i++) {
      developer.log(
        'Trying provider ${i + 1}/${providers.length}: ${providers[i].name}',
        name: 'ChatAPI',
      );
      
      try {
        final response = await providers[i].sendMessage(_dio, message);
        developer.log(
          'SUCCESS with ${providers[i].name}: "$response"',
          name: 'ChatAPI',
        );
        return ChatMessageModel(text: response, isUser: false);
      } catch (e) {
        developer.log(
          'FAILED with ${providers[i].name}: $e',
          name: 'ChatAPI',
          error: e,
        );
        
        // If this is the last provider, throw the error
        if (i == providers.length - 1) {
          developer.log(
            'All providers failed. Throwing error.',
            name: 'ChatAPI',
            error: e,
          );
          throw Exception(
            'All AI providers are currently unavailable. Please try again later.',
          );
        }
        // Otherwise, continue to next provider
        developer.log('Trying next provider...', name: 'ChatAPI');
        continue;
      }
    }

    // Fallback (should never reach here)
    throw Exception('Unable to get AI response');
  }
}

/// Abstract provider interface
abstract class _ChatProvider {
  String get name;
  Future<String> sendMessage(Dio dio, String message);
}

/// Enhanced mock provider with intelligent responses
class _SmartMockProvider implements _ChatProvider {
  @override
  String get name => 'SmartChatbot';

  @override
  Future<String> sendMessage(Dio dio, String message) async {
    developer.log('Using smart chatbot provider', name: 'ChatAPI');
    
    // Simulate a small delay to feel more natural
    await Future.delayed(const Duration(milliseconds: 500));
    
    final lowerMessage = message.toLowerCase().trim();
    
    // Greetings
    if (_containsAny(lowerMessage, ['hello', 'hi', 'hey', 'greetings'])) {
      return _randomChoice([
        "Hello! How can I assist you today?",
        "Hi there! What can I help you with?",
        "Hey! Nice to chat with you. What's on your mind?",
      ]);
    }
    
    // How are you
    if (_containsAny(lowerMessage, ['how are you', 'how r u', 'how do you do'])) {
      return _randomChoice([
        "I'm doing great, thanks for asking! How about you?",
        "I'm functioning well! How can I help you today?",
        "I'm here and ready to chat! What would you like to talk about?",
      ]);
    }
    
    // Help/assistance
    if (_containsAny(lowerMessage, ['help', 'assist', 'support'])) {
      return "I'm here to chat with you! You can ask me questions, have a conversation, or just say hello. Try asking me about various topics!";
    }
    
    // Goodbye
    if (_containsAny(lowerMessage, ['bye', 'goodbye', 'see you', 'farewell'])) {
      return _randomChoice([
        "Goodbye! Have a wonderful day!",
        "See you later! Take care!",
        "Farewell! Come back anytime!",
      ]);
    }
    
    // Thanks
    if (_containsAny(lowerMessage, ['thank', 'thanks', 'appreciate'])) {
      return _randomChoice([
        "You're welcome! Happy to help!",
        "My pleasure! Anything else I can do for you?",
        "Glad I could help!",
      ]);
    }
    
    // Name questions
    if (_containsAny(lowerMessage, ['your name', 'who are you', 'what are you'])) {
      return "I'm a friendly chatbot assistant built into this app. I'm here to chat with you!";
    }
    
    // Weather (common question)
    if (_containsAny(lowerMessage, ['weather', 'temperature', 'forecast'])) {
      return "I don't have access to real-time weather data, but I hope it's nice where you are! You might want to check a weather app for accurate forecasts.";
    }
    
    // Time/date
    if (_containsAny(lowerMessage, ['time', 'date', 'day'])) {
      final now = DateTime.now();
      return "The current date and time is ${now.toString().split('.')[0]}. How can I help you today?";
    }
    
    // Questions (contains ?)
    if (lowerMessage.contains('?')) {
      return _randomChoice([
        "That's an interesting question! While I'm a simple chatbot, I'd love to chat more about that. What specifically would you like to know?",
        "Great question! I'm here to have a friendly conversation with you. Tell me more!",
        "Hmm, that's something to think about! I'm a basic chatbot, but I enjoy our conversation. What else is on your mind?",
      ]);
    }
    
    // Default responses
    return _randomChoice([
      "I understand you said: '$message'. That's interesting! Tell me more.",
      "Thanks for sharing that! I'm a simple chatbot, so my responses are limited, but I'm here to chat.",
      "I hear you! While I'm a basic chatbot, I enjoy our conversation. What else would you like to talk about?",
      "That's cool! I'm here to keep you company. Feel free to ask me anything or just chat!",
    ]);
  }
  
  /// Helper to check if message contains any of the keywords
  bool _containsAny(String message, List<String> keywords) {
    return keywords.any((keyword) => message.contains(keyword));
  }
  
  /// Helper to return a random choice from a list
  String _randomChoice(List<String> options) {
    return options[DateTime.now().millisecondsSinceEpoch % options.length];
  }
}

/// Simple mock provider for basic responses (kept as backup)
class _MockProvider implements _ChatProvider {
  @override
  String get name => 'BasicChatbot';

  @override
  Future<String> sendMessage(Dio dio, String message) async {
    developer.log('Using basic mock provider', name: 'ChatAPI');
    
    // Simple keyword-based responses
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return "Hello! I'm a simple chatbot. How can I help you today?";
    } else if (lowerMessage.contains('how are you')) {
      return "I'm doing well, thank you for asking!";
    } else if (lowerMessage.contains('help')) {
      return "I'm here to chat with you! Try asking me questions or just say hello.";
    } else if (lowerMessage.contains('bye')) {
      return "Goodbye! Have a great day!";
    } else {
      return "I understand you said: '$message'. I'm a simple chatbot, so my responses are limited. Try asking me how I'm doing or say hello!";
    }
  }
}

import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({required super.text, required super.isUser});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['reply'], // Adjust based on your backend response
      isUser: false,
    );
  }
}

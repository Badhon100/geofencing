import 'package:geofencing/core/services/api_service.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> sendMessage(String message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService apiService;

  ChatRemoteDataSourceImpl(this.apiService);

  @override
  Future<ChatMessageModel> sendMessage(String message) async {
    final response = await apiService.post(
      "chat/completions", // ❗ no leading slash when baseUrl already ends with /
      data: {
        "model": "gpt-4o-mini", // REQUIRED
        "messages": [
          {"role": "user", "content": message},
        ],
        "temperature": 0.7,
      },
    );

    final aiText = response.data["choices"][0]["message"]["content"];

    return ChatMessageModel(text: aiText.trim(), isUser: false);
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        "/v1/models/gemini-pro:generateContent", // ✅ Use v1, not v1beta
        queryParams: {"key": dotenv.env['OPENAI_API_KEY']},
        data: {
          "contents": [
            {
              "role": "user", // ✅ Add role field
              "parts": [
                {"text": message}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 1000,
          },
          "safetySettings": [ // Optional but recommended
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        },
      );
    final aiText = response.data["choices"][0]["message"]["content"];

    return ChatMessageModel(text: aiText.trim(), isUser: false);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_urls.dart';
import '../../models/chat_message_model.dart';

class ChatProvider {
  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> conversationHistory,
    String? modelName,
  }) async {
    try {
      final requestBody = {
        'message': message,
        'conversation_history':
            conversationHistory
                .map((msg) => {'role': msg.role, 'content': msg.content})
                .toList(),
        if (modelName != null) 'model_name': modelName,
      };

      final response = await http.post(
        Uri.parse(AppUrls.chatMessage),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);

        if (responseMap['success'] == true) {
          return responseMap['data']['message'] ?? '';
        } else {
          throw Exception(responseMap['message'] ?? 'Failed to get response');
        }
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChatRules({String? modelName}) async {
    try {
      final uri = Uri.parse(AppUrls.chatRules);
      final uriWithParams =
          modelName != null
              ? uri.replace(queryParameters: {'model_name': modelName})
              : uri;

      final response = await http.get(
        uriWithParams,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);

        if (responseMap['success'] == true) {
          return List<Map<String, dynamic>>.from(responseMap['data'] ?? []);
        } else {
          throw Exception(responseMap['message'] ?? 'Failed to get rules');
        }
      } else {
        throw Exception('Failed to load chat rules: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chat rules: $e');
    }
  }
}

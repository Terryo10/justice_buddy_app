import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'chat_provider.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_conversation_model.dart';

class ChatRepository {
  final ChatProvider provider;
  final FlutterSecureStorage secureStorage;

  static const String _conversationsKey = 'chat_conversations';
  static const String _currentConversationKey = 'current_conversation_id';

  ChatRepository({required this.provider, required this.secureStorage});

  // Send message and get AI response
  Future<ChatMessage> sendMessage({
    required String message,
    required List<ChatMessage> conversationHistory,
    String? modelName,
  }) async {
    final aiResponse = await provider.sendMessage(
      message: message,
      conversationHistory: conversationHistory,
      modelName: modelName,
    );

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      content: aiResponse,
      timestamp: DateTime.now(),
    );
  }

  // Get chat rules from API
  Future<List<Map<String, dynamic>>> getChatRules({String? modelName}) =>
      provider.getChatRules(modelName: modelName);

  // Save conversation to secure storage
  Future<void> saveConversation(ChatConversation conversation) async {
    try {
      final conversationsJson = await secureStorage.read(
        key: _conversationsKey,
      );
      final conversations = <String, dynamic>{};

      if (conversationsJson != null) {
        conversations.addAll(json.decode(conversationsJson));
      }

      conversations[conversation.id] = conversation.toJson();

      await secureStorage.write(
        key: _conversationsKey,
        value: json.encode(conversations),
      );
    } catch (e) {
      throw Exception('Error saving conversation: $e');
    }
  }

  // Load conversation from secure storage
  Future<ChatConversation?> loadConversation(String conversationId) async {
    try {
      final conversationsJson = await secureStorage.read(
        key: _conversationsKey,
      );

      if (conversationsJson == null) return null;

      final conversations =
          json.decode(conversationsJson) as Map<String, dynamic>;
      final conversationData = conversations[conversationId];

      if (conversationData == null) return null;

      final conversation = ChatConversation.fromJson(conversationData);

      // Check if conversation is expired
      if (conversation.isExpired) {
        await deleteConversation(conversationId);
        return null;
      }

      return conversation;
    } catch (e) {
      throw Exception('Error loading conversation: $e');
    }
  }

  // Load all conversations
  Future<List<ChatConversation>> loadAllConversations() async {
    try {
      final conversationsJson = await secureStorage.read(
        key: _conversationsKey,
      );

      if (conversationsJson == null) return [];

      final conversations =
          json.decode(conversationsJson) as Map<String, dynamic>;
      final validConversations = <ChatConversation>[];
      final expiredIds = <String>[];

      for (final entry in conversations.entries) {
        try {
          final conversation = ChatConversation.fromJson(entry.value);

          if (conversation.isExpired) {
            expiredIds.add(entry.key);
          } else {
            validConversations.add(conversation);
          }
        } catch (e) {
          // Invalid conversation data, mark for deletion
          expiredIds.add(entry.key);
        }
      }

      // Clean up expired conversations
      if (expiredIds.isNotEmpty) {
        for (final id in expiredIds) {
          conversations.remove(id);
        }
        await secureStorage.write(
          key: _conversationsKey,
          value: json.encode(conversations),
        );
      }

      // Sort by creation date (newest first)
      validConversations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return validConversations;
    } catch (e) {
      throw Exception('Error loading conversations: $e');
    }
  }

  // Delete a specific conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      final conversationsJson = await secureStorage.read(
        key: _conversationsKey,
      );

      if (conversationsJson == null) return;

      final conversations =
          json.decode(conversationsJson) as Map<String, dynamic>;
      conversations.remove(conversationId);

      await secureStorage.write(
        key: _conversationsKey,
        value: json.encode(conversations),
      );

      // If this was the current conversation, clear the current conversation ID
      final currentId = await getCurrentConversationId();
      if (currentId == conversationId) {
        await clearCurrentConversationId();
      }
    } catch (e) {
      throw Exception('Error deleting conversation: $e');
    }
  }

  // Clear all conversations
  Future<void> clearAllConversations() async {
    try {
      await secureStorage.delete(key: _conversationsKey);
      await clearCurrentConversationId();
    } catch (e) {
      throw Exception('Error clearing conversations: $e');
    }
  }

  // Current conversation management
  Future<void> setCurrentConversationId(String conversationId) async {
    await secureStorage.write(
      key: _currentConversationKey,
      value: conversationId,
    );
  }

  Future<String?> getCurrentConversationId() async {
    return await secureStorage.read(key: _currentConversationKey);
  }

  Future<void> clearCurrentConversationId() async {
    await secureStorage.delete(key: _currentConversationKey);
  }

  // Create a new conversation
  Future<ChatConversation> createNewConversation() async {
    final conversationId = DateTime.now().millisecondsSinceEpoch.toString();
    final conversation = ChatConversation.create(conversationId);

    await saveConversation(conversation);
    await setCurrentConversationId(conversationId);

    return conversation;
  }

  // Auto-cleanup expired conversations (call this periodically)
  Future<void> cleanupExpiredConversations() async {
    await loadAllConversations(); // This will automatically clean up expired ones
  }
}

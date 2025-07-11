import 'chat_message_model.dart';

class ChatConversation {
  final String id;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime expiresAt;

  ChatConversation({
    required this.id,
    required this.messages,
    required this.createdAt,
    required this.expiresAt,
  });

  factory ChatConversation.create(String id) {
    final now = DateTime.now();
    return ChatConversation(
      id: id,
      messages: [],
      createdAt: now,
      expiresAt: now.add(Duration(hours: 24)), // 24 hours expiry
    );
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      messages:
          (json['messages'] as List<dynamic>? ?? [])
              .map((msg) => ChatMessage.fromJson(msg))
              .toList(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      expiresAt:
          json['expires_at'] != null
              ? DateTime.parse(json['expires_at'])
              : DateTime.now().add(Duration(hours: 24)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  ChatConversation copyWith({
    String? id,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  ChatConversation addMessage(ChatMessage message) {
    return copyWith(messages: [...messages, message]);
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isEmpty => messages.isEmpty;

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;
}

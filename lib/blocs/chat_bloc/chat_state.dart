part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatConversationsLoaded extends ChatState {
  final List<ChatConversation> conversations;

  const ChatConversationsLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class ChatConversationLoaded extends ChatState {
  final ChatConversation conversation;
  final bool isLoading;

  const ChatConversationLoaded({
    required this.conversation,
    this.isLoading = false,
  });

  ChatConversationLoaded copyWith({
    ChatConversation? conversation,
    bool? isLoading,
  }) {
    return ChatConversationLoaded(
      conversation: conversation ?? this.conversation,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [conversation, isLoading];
}

class ChatMessageSending extends ChatState {
  final ChatConversation conversation;
  final String pendingMessage;

  const ChatMessageSending({
    required this.conversation,
    required this.pendingMessage,
  });

  @override
  List<Object?> get props => [conversation, pendingMessage];
}

class ChatError extends ChatState {
  final String message;
  final ChatConversation? conversation;

  const ChatError({required this.message, this.conversation});

  @override
  List<Object?> get props => [message, conversation];
}

part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ChatEvent {}

class LoadConversation extends ChatEvent {
  final String conversationId;

  const LoadConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class CreateNewConversation extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  final String? conversationId;

  const SendMessage({required this.message, this.conversationId});

  @override
  List<Object?> get props => [message, conversationId];
}

class DeleteConversation extends ChatEvent {
  final String conversationId;

  const DeleteConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class ClearAllConversations extends ChatEvent {}

class SelectConversation extends ChatEvent {
  final ChatConversation conversation;

  const SelectConversation(this.conversation);

  @override
  List<Object?> get props => [conversation];
}

class ClearCurrentConversation extends ChatEvent {}

class CleanupExpiredConversations extends ChatEvent {}

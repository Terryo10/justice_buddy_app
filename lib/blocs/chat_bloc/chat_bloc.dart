import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_conversation_model.dart';
import '../../repositories/chat_repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadConversation>(_onLoadConversation);
    on<CreateNewConversation>(_onCreateNewConversation);
    on<SendMessage>(_onSendMessage);
    on<DeleteConversation>(_onDeleteConversation);
    on<ClearAllConversations>(_onClearAllConversations);
    on<SelectConversation>(_onSelectConversation);
    on<ClearCurrentConversation>(_onClearCurrentConversation);
    on<CleanupExpiredConversations>(_onCleanupExpiredConversations);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversations = await chatRepository.loadAllConversations();
      emit(ChatConversationsLoaded(conversations: conversations));
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onLoadConversation(
    LoadConversation event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversation = await chatRepository.loadConversation(
        event.conversationId,
      );
      if (conversation != null) {
        emit(ChatConversationLoaded(conversation: conversation));
      } else {
        emit(ChatError(message: 'Conversation not found or expired'));
      }
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onCreateNewConversation(
    CreateNewConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final conversation = await chatRepository.createNewConversation();
      emit(ChatConversationLoaded(conversation: conversation));
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Get current conversation or create new one
      ChatConversation currentConversation;

      if (event.conversationId != null) {
        final loaded = await chatRepository.loadConversation(
          event.conversationId!,
        );
        if (loaded != null) {
          currentConversation = loaded;
        } else {
          currentConversation = await chatRepository.createNewConversation();
        }
      } else if (state is ChatConversationLoaded) {
        currentConversation = (state as ChatConversationLoaded).conversation;
      } else {
        currentConversation = await chatRepository.createNewConversation();
      }

      // Add user message
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'user',
        content: event.message,
        timestamp: DateTime.now(),
      );

      final conversationWithUserMessage = currentConversation.addMessage(
        userMessage,
      );
      await chatRepository.saveConversation(conversationWithUserMessage);

      // Show loading state with pending message
      emit(
        ChatMessageSending(
          conversation: conversationWithUserMessage,
          pendingMessage: event.message,
        ),
      );

      // Get AI response
      final aiMessage = await chatRepository.sendMessage(
        message: event.message,
        conversationHistory: conversationWithUserMessage.messages,
      );

      // Add AI response to conversation
      final finalConversation = conversationWithUserMessage.addMessage(
        aiMessage,
      );
      await chatRepository.saveConversation(finalConversation);

      emit(ChatConversationLoaded(conversation: finalConversation));
    } catch (error) {
      // Try to restore previous state if available
      if (state is ChatMessageSending) {
        final sendingState = state as ChatMessageSending;
        emit(
          ChatError(
            message: error.toString(),
            conversation: sendingState.conversation,
          ),
        );
      } else {
        emit(ChatError(message: error.toString()));
      }
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.deleteConversation(event.conversationId);

      // If we're currently viewing this conversation, clear it
      if (state is ChatConversationLoaded) {
        final currentState = state as ChatConversationLoaded;
        if (currentState.conversation.id == event.conversationId) {
          emit(ChatInitial());
          return;
        }
      }

      // Reload conversations list
      final conversations = await chatRepository.loadAllConversations();
      emit(ChatConversationsLoaded(conversations: conversations));
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onClearAllConversations(
    ClearAllConversations event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.clearAllConversations();
      emit(ChatInitial());
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  void _onSelectConversation(
    SelectConversation event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatConversationLoaded(conversation: event.conversation));
  }

  void _onClearCurrentConversation(
    ClearCurrentConversation event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatInitial());
  }

  Future<void> _onCleanupExpiredConversations(
    CleanupExpiredConversations event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.cleanupExpiredConversations();

      // If we have conversations loaded, refresh the list
      if (state is ChatConversationsLoaded) {
        final conversations = await chatRepository.loadAllConversations();
        emit(ChatConversationsLoaded(conversations: conversations));
      }
    } catch (error) {
      // Silently fail cleanup - it's not critical
    }
  }
}

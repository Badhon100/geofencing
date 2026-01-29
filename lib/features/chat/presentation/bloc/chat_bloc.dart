import 'dart:developer' as developer;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/chat/domain/usecases/chat_usecase.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.sendMessageUseCase) : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    developer.log('ChatBloc initialized', name: 'ChatBloc');
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    developer.log('Received message event: "${event.message}"', name: 'ChatBloc');
    
    // Make a mutable copy of current messages
    final updatedMessages = List<ChatMessage>.from(state.messages);

    // 1️⃣ Add user message instantly
    final userMessage = ChatMessage(text: event.message, isUser: true);

    updatedMessages.add(userMessage);
    developer.log('Added user message to list', name: 'ChatBloc');

    emit(state.copyWith(messages: updatedMessages, isLoading: true));
    developer.log('Emitted state with loading=true', name: 'ChatBloc');

    try {
      // 2️⃣ Get AI response
      developer.log('Calling sendMessageUseCase...', name: 'ChatBloc');
      final aiMessage = await sendMessageUseCase(event.message);
      developer.log('Received AI message: "${aiMessage.text}"', name: 'ChatBloc');

      // 3️⃣ Add AI message to SAME list
      updatedMessages.add(aiMessage);

      emit(state.copyWith(messages: updatedMessages, isLoading: false));
      developer.log('Emitted state with AI message, loading=false', name: 'ChatBloc');
    } catch (e) {
      developer.log(
        'ERROR getting AI response: $e',
        name: 'ChatBloc',
        error: e,
      );
      emit(state.copyWith(isLoading: false));
      developer.log('Emitted state with loading=false (error)', name: 'ChatBloc');
    }
  }
}
